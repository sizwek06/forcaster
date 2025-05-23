//
//  ForecasterApp.swift
//  Forecaster
//
//  Created by Sizwe Khathi on 2025/05/22.
//

import SwiftUI

@main
struct ForecasterApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ContentViewModel())
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
