import SwiftUI
import Foundation

// Estructura para representar una imagen que es identificable
struct ImagenIdentificable: Identifiable {
    let id = UUID() // Genera un identificador único
    let nombre: String
}

// Diccionario que contiene los productos del menú y sus precios
let menuProductos: [String: Double] = [
    "sencilla": 69.0,
    "sencilla tocino": 79.0,
    "sencilla double cheese": 79.0,
    "doble": 89.0,
    "doble tocino": 99.0,
    "doble double cheese": 99.0,
    "chicken boomy": 89.0,
    "papas boomers": 49.0,
    "baby nuggets 6pz": 59.0,
    "big nuggets 10pz": 95.0,
    "malteada vainilla": 79.0,
    "malteada chocolate": 79.0,
    "malteada fresa": 79.0,
    "malteada oreo": 79.0,
    "refresco": 35.0,
    "agua embotellada": 16.0,
    "café americano": 34.0,
    "capuccino": 42.0,
    "chiles boomers": 8.0,
    "tocino": 17.0,
    "dip de pepinillo": 14.0,
    "queso": 12.0
]

// Estructura de la vista principal del chatbot
struct ContentView: View {
    @State private var inputText: String = ""
    @State private var messages: [(String, Bool, Bool)] = [] // Inicialmente vacío
    @State private var scrollProxy: ScrollViewProxy? = nil // Proxy para el scroll automático
    @State private var carrito: [String: Int] = [:] // Para almacenar los productos que el usuario pide y la cantidad
    @State private var estaHaciendoPedido = false // Indica si el usuario está en el proceso de hacer un pedido
    @State private var estaConfirmandoPedido = false // Indica si estamos en el proceso de confirmación
    @State private var imagenSeleccionada: ImagenIdentificable? = nil // Estado para controlar la imagen seleccionada
    @State private var chatTerminado = false // Nuevo estado para indicar el fin del chat

    var body: some View {
        ZStack {
            // Fondo de color amarillo
            Color.yellow.edgesIgnoringSafeArea(.all)

            VStack(spacing: 5) {
                // Mostrar el logo de Boomers to Go en la parte superior, con tamaño más pequeño
                Image("logoBoomers")  // Nombre del archivo en Assets (sin extensión)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180, height: 80)  // Tamaño ajustado del logo
                    .padding(.top, 5)  // Reducimos el espacio superior

                // ScrollView con ScrollViewReader para hacer scroll automático al final
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(messages.indices, id: \.self) { index in
                                let message = messages[index].0
                                let isUser = messages[index].1
                                let isImage = messages[index].2

                                HStack {
                                    if isUser {
                                        Spacer()
                                        if isImage {
                                            Image(message)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(maxWidth: 350, maxHeight: 250) // Tamaño ajustado de la imagen
                                                .cornerRadius(10)
                                                .onTapGesture {
                                                    // Mostrar la hoja con la imagen maximizada al tocar
                                                    imagenSeleccionada = ImagenIdentificable(nombre: message)
                                                }
                                        } else {
                                            Text(message)
                                                .font(.system(size: 18, weight: .medium, design: .rounded))
                                                .foregroundColor(.white)
                                                .padding()
                                                .background(Color.blue)
                                                .cornerRadius(10)
                                                .shadow(radius: 5)
                                                .frame(maxWidth: 250, alignment: .trailing)
                                        }
                                    } else {
                                        if isImage {
                                            Image(message)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(maxWidth: 350, maxHeight: 250) // Tamaño ajustado de la imagen
                                                .cornerRadius(10)
                                                .onTapGesture {
                                                    // Mostrar la hoja con la imagen maximizada al tocar
                                                    imagenSeleccionada = ImagenIdentificable(nombre: message)
                                                }
                                        } else {
                                            Text(message)
                                                .font(.system(size: 18, weight: .medium, design: .rounded))
                                                .foregroundColor(.black)
                                                .padding()
                                                .background(Color.white)
                                                .cornerRadius(10)
                                                .shadow(radius: 5)
                                                .frame(maxWidth: 250, alignment: .leading)
                                        }
                                        Spacer()
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        .onAppear {
                            scrollProxy = proxy // Guardar el proxy del ScrollViewReader
                            sendInitialMessages() // Enviar mensajes automáticos al iniciar
                        }
                        .onChange(of: messages.count) {
                            // Hacer scroll al último mensaje cuando haya cambios en los mensajes
                            withAnimation {
                                proxy.scrollTo(messages.count - 1, anchor: .bottom)
                            }
                        }
                    }
                }

                if !chatTerminado { // Mostrar el TextField solo si el chat no ha terminado
                    // HStack para colocar el TextField y el botón de enviar en la misma línea
                    HStack {
                        TextField("Escribe tu pregunta aquí", text: $inputText)
                            .foregroundColor(.black)  // Cambiar el color del texto a negro
                            .padding(.vertical, 5)    // Reducir la altura del campo de texto
                            .padding(.horizontal, 15)  // Espaciado horizontal dentro del campo de texto
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        
                        Button(action: {
                            let currentInput = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
                            guard !currentInput.isEmpty else {
                                messages.append(("No has ingresado un pedido válido", false, false))
                                return
                            }
                            messages.append((currentInput, true, false)) // Mensaje del usuario (lado derecho)
                            inputText = "" // Limpiar el campo de texto
                            handleUserInput(input: currentInput) { response, imageNames in
                                DispatchQueue.main.async {
                                    if let response = response {
                                        messages.append((response, false, false)) // Respuesta del chatbot (lado izquierdo)
                                    }
                                    if let imageNames = imageNames {
                                        // Agregar imágenes como mensajes en el historial
                                        for imageName in imageNames {
                                            messages.append((imageName, false, true)) // Imagen en lugar de texto
                                        }
                                    }
                                }
                            }
                        }) {
                            Text("Enviar")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.vertical, 5)  // Reducir la altura del botón
                                .padding(.horizontal, 20)  // Reducir el ancho del botón
                                .background(Color.blue)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        }
                        .padding(.leading, 10)  // Espacio entre el TextField y el botón
                    }
                    .padding(.horizontal, 20)
                } else {
                    Text("¡Gracias por usar Boomers! El chat ha terminado.")
                        .font(.headline)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }

                Spacer()
            }
        }
        .sheet(item: $imagenSeleccionada) { imagen in
            VStack {
                Image(imagen.nombre)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity) // Imagen maximizada
                    .background(Color.black)
                    .onTapGesture {
                        imagenSeleccionada = nil // Cerrar la hoja al tocar la imagen
                    }
            }
        }
    }

    // Función para enviar los mensajes automáticos al iniciar
    func sendInitialMessages() {
        let mensajesIniciales = [
            "¡Hola! Soy tu asistente de Boomers!",
            "Puedes ver el menú, ver combos o hacer un pedido.",
            "Para hacer un pedido, separa los productos con comas."
        ]

        for (index, mensaje) in mensajesIniciales.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 1.5) {
                messages.append((mensaje, false, false))
            }
        }
    }

    // Función para manejar las preguntas del usuario y mostrar imágenes o texto
    func handleUserInput(input: String, completion: @escaping (String?, [String]?) -> Void) {
        let lowercasedInput = input.lowercased()

        // Si estamos esperando una confirmación de pedido
        if estaConfirmandoPedido {
            if lowercasedInput == "sí" || lowercasedInput == "si" {
                completion("¡Gracias! Tu pedido ha sido confirmado y se está procesando.", nil)
                // Enviar la ubicación inmediatamente después de confirmar
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    messages.append(("Puedes recoger tu pedido en: Boomers Mx, Av. Principal #123, Colonia Centro \n https://www.google.com/maps?q=Boomers%20Mx. ¡Te esperamos!", false, false))
                    endChat() // Terminar el chat después de confirmar
                }
                estaConfirmandoPedido = false
            } else if lowercasedInput == "no" {
                completion("El pedido ha sido cancelado.", nil)
                endChat() // Terminar el chat si se cancela el pedido
                estaConfirmandoPedido = false
            } else {
                completion("Por favor responde 'sí' o 'no' para confirmar tu pedido.", nil)
            }
            return
        }

        // Si el usuario está en el proceso de hacer un pedido
        if estaHaciendoPedido {
            // Procesar el pedido ahora que el usuario ha dado detalles
            processOrder(input: lowercasedInput, completion: completion)
        } else {
            // Si el usuario pide ver el menú, mostramos la imagen del menú
            if lowercasedInput.contains("menu") {
                let images = ["menu"]
                completion(nil, images)
            }
            // Si el usuario pide ver los combos, mostramos la imagen de los combos
            else if lowercasedInput.contains("combo") {
                let images = ["combos"]
                completion(nil, images)
            }
            // Si el usuario indica que quiere hacer un pedido
            else if lowercasedInput.contains("pedido") || lowercasedInput.contains("ordenar") {
                estaHaciendoPedido = true
                completion("¡Claro! ¿Qué te gustaría pedir?\nRecuerda separar los productos con comas.", nil)
            }
            // Si el input no coincide, mostramos opciones
            else {
                completion("No estoy seguro qué quisiste decir. Puedes escribir:\n- Ver menú\n- Ver combos\n- Hacer pedido", nil)
            }
        }
    }

    // Función para procesar el pedido del usuario
    func processOrder(input: String, completion: @escaping (String?, [String]?) -> Void) {
        // Dividir el input en productos separados por comas
        let productosSeparados = input.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        var total: Double = 0.0
        var pedidoDetalles = "Has pedido:\n"
        var productosEncontrados: [String: Int] = [:]

        // Procesar cada producto individualmente
        for producto in productosSeparados {
            let palabras = producto.split(separator: " ").map { String($0) }
            var cantidad = 1
            var nombreProducto = ""

            // Detectar la cantidad si existe al principio
            if let numero = Int(palabras[0]) {
                cantidad = numero
                nombreProducto = palabras.dropFirst().joined(separator: " ")
            } else {
                nombreProducto = palabras.joined(separator: " ")
            }

            // Verificar si el producto completo coincide en el menú
            if let precio = menuProductos[nombreProducto.lowercased()] {
                productosEncontrados[nombreProducto, default: 0] += cantidad
                total += Double(cantidad) * precio
                pedidoDetalles += "- \(cantidad) \(nombreProducto.capitalized): $\(precio * Double(cantidad))\n"
            } else {
                completion("El producto '\(nombreProducto)' no está en el menú.", nil)
                return
            }
        }

        if total > 0 {
            pedidoDetalles += "\nTotal: $\(total)"
            pedidoDetalles += "\n¿Te gustaría confirmar tu pedido? (responde 'sí' o 'no')"
            completion(pedidoDetalles, nil)
            estaConfirmandoPedido = true // Iniciamos la confirmación del pedido
        } else {
            completion("No se han reconocido productos válidos en tu pedido.", nil)
        }
    }

    // Función para terminar el chat
    func endChat() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            messages.append(("Gracias por usar Boomers! El chat ha finalizado.", false, false))
            chatTerminado = true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: ContentView {
        ContentView()
    }
}

