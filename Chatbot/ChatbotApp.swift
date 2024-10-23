//
//  ChatbotApp.swift
//  Chatbot
//
//  Created by Leo De jesus on 22/10/24.
//

import SwiftUI

@main
struct ChatbotApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
