//
//  FavouriteCity+CoreDataProperties.swift
//  Forecaster
//
//  Created by Sizwe Khathi on 2025/05/23.
//
//

import Foundation
import CoreData


extension FavouriteCity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavouriteCity> {
        return NSFetchRequest<FavouriteCity>(entityName: "FavouriteCity")
    }

    @NSManaged public var cityName: String
    @NSManaged public var itemIdentifier: UUID
    @NSManaged public var timeStamp: Int16
    @NSManaged public var minTemp: String
    @NSManaged public var maxTemp: String
    @NSManaged public var currentTemp: String
    @NSManaged public var cityCondition: Int16
    @NSManaged public var forecast: NSSet

}

// MARK: Generated accessors for forecast
extension FavouriteCity {

    @objc(addForecastObject:)
    @NSManaged public func addToForecast(_ value: CityForecast)

    @objc(removeForecastObject:)
    @NSManaged public func removeFromForecast(_ value: CityForecast)

    @objc(addForecast:)
    @NSManaged public func addToForecast(_ values: NSSet)

    @objc(removeForecast:)
    @NSManaged public func removeFromForecast(_ values: NSSet)

}

extension FavouriteCity : Identifiable {

}
