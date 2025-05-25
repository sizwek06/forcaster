//
//  IntExtenstion.swift
//  Forecaster
//
//  Created by Sizwe Khathi on 2025/05/24.
//

import Foundation


extension Int {
    var dateFromInt: Date {
        Date(timeIntervalSince1970: TimeInterval(integerLiteral: Int64(self)))
    }
    
    var updatedWhenString: String {
        let dateValue = self.dateFromInt
        return DateManager.day.stringFrom(date: Date()) == DateManager.date.stringFrom(date: dateValue) ? "Today" : "\(DateManager.date.stringFrom(date: dateValue)) at \(DateManager.time.stringFrom(date: dateValue))"
    }
    
    var dayOfWeekString: String {
        let dateValue = self.dateFromInt
        return DateManager.day.stringFrom(date: Date()) == DateManager.day.stringFrom(date: dateValue) ? "Today" : DateManager.day.stringFrom(date: dateValue)
    }
}
