//
//  DataManager.swift
//  Forecaster
//
//  Created by Sizwe Khathi on 2025/05/23.
//

import CoreData
import Foundation

class DataManager: NSObject, ObservableObject {
    
    let container: NSPersistentContainer = NSPersistentContainer(name: "Forecaster")
    
    @Published var cities: [FavouriteCity] = [FavouriteCity]()
    
    override init() {
        super.init()
        container.loadPersistentStores { _, _ in }
    }
}
