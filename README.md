# Boomers Chatbot

Este es el proyecto del Chatbot de Boomers desarrollado en Swift para dispositivos iOS. El chatbot permite a los usuarios interactuar de manera sencilla para ver el menú, combos, hacer pedidos y confirmar sus compras.

## Características principales

- **Visualización de menú**: El chatbot permite al usuario ver el menú y los combos de Boomers.
- **Realizar pedidos**: Los usuarios pueden hacer pedidos separando los productos con comas.
- **Confirmación de pedido**: Al finalizar un pedido, el chatbot solicita confirmación y procesa el pedido.
- **Finalización del chat**: Al confirmar o cancelar el pedido, el chatbot termina la conversación mostrando un mensaje de despedida.

## Estructura del proyecto

- `ContentView.swift`: Este archivo contiene la estructura principal de la interfaz y la lógica del chatbot.
- **Recursos**:
  - `logoBoomers`: Imagen del logotipo de Boomers.
  - `menu`: Imagen del menú de Boomers.
  - `combos`: Imagen de los combos disponibles.
  
## Uso del chatbot

Una vez que la aplicación esté en ejecución:

1. **Inicia la conversación**: El chatbot mostrará un mensaje de bienvenida y las opciones que el usuario puede seguir.
2. **Visualiza el menú o los combos**: Puedes escribir mensajes como "Ver menú" o "Ver combos" para que el chatbot te muestre imágenes del menú o los combos disponibles.
3. **Realiza un pedido**: Escribe los productos que deseas pedir, separándolos con comas, como "sencilla, papas boomers, malteada oreo".
4. **Confirma el pedido**: El chatbot calculará el total y te pedirá confirmar el pedido respondiendo "sí" o "no".
5. **Recoge tu pedido**: Si confirmas, el chatbot te mostrará la dirección de Boomers para recoger tu pedido y luego finalizará el chat.

## Tecnologías utilizadas

- **SwiftUI**: Utilizado para construir la interfaz de usuario del chatbot.
- **Swift**: Lenguaje principal utilizado para desarrollar la lógica de la aplicación.
- **Xcode**: Ambiente de desarrollo integrado (IDE) utilizado para crear la aplicación.
  
## Archivos clave

- **`ContentView.swift`**: Implementa la lógica del chatbot, incluyendo la gestión de los mensajes, la visualización de imágenes y la confirmación del pedido.
- **`Assets.xcassets`**: Carpeta donde se encuentran los recursos visuales como el logotipo, menú y combos.

## Personalización

Si deseas modificar o ampliar el chatbot, considera lo siguiente:

- **Agregar más productos**: Puedes actualizar el diccionario `menuProductos` en `ContentView.swift` para agregar más productos o cambiar los precios.
- **Añadir nuevas funcionalidades**: Puedes expandir las capacidades del chatbot agregando más comandos y funcionalidades en la función `handleUserInput()`.

## Contribuciones

Las contribuciones son bienvenidas. Si deseas mejorar este proyecto o añadir nuevas funcionalidades, abre un pull request o crea un issue en el repositorio.

1. **Fork este repositorio**.
2. Crea tu rama de características (`git checkout -b feature/nueva-caracteristica`).
3. Realiza commit de tus cambios (`git commit -m 'Añadir nueva característica'`).
4. Sube tus cambios (`git push origin feature/nueva-caracteristica`).
5. Abre un Pull Request.

## Licencia

Este proyecto está bajo la Licencia MIT. Consulta el archivo `LICENSE` para más detalles.

## Autor

Este proyecto fue desarrollado por **Leobardo de Jesús Carbajal** ([L3CHUGU1T4](https://github.com/L3CHUGU1T4)).
