//
//  ForecasterApp.swift
//  Forecaster
//
//  Created by Sizwe Khathi on 2025/05/22.
//

import SwiftUI

@main
struct ForecasterApp: App {
    @StateObject private var manager: DataManager = DataManager()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ContentViewModel())
                .environment(\.managedObjectContext, manager.container.viewContext)
        }
    }
}
