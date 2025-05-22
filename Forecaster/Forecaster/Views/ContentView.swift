//
//  ContentView.swift
//  Forecaster
//
//  Created by Sizwe Khathi on 2025/05/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        NavigationView {
            
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

// Define your navigation data model
enum NavigationDestination: Hashable, View {
    case weather
//    case profile
//    case settings
    
    // return the associated view for each case
    var body: some View {
        switch self {
            case .weather:
                WeatherView()
//            case .profile:
//                ProfileView()
//            case .settings:
//                SettingsView()
        }
    }
}
