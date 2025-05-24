//
//  CityForecast+CoreDataProperties.swift
//  Forecaster
//
//  Created by Sizwe Khathi on 2025/05/23.
//
//

import Foundation
import CoreData


extension CityForecast {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CityForecast> {
        return NSFetchRequest<CityForecast>(entityName: "CityForecast")
    }

    @NSManaged public var dayOfWeek: String
    @NSManaged public var currentTemperature: String
    @NSManaged public var condition: Int16
    @NSManaged public var relationship: FavouriteCity

}
