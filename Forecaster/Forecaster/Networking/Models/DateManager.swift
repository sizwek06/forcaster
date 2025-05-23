//
//  DateManager.swift
//  Forecaster
//
//  Created by Sizwe Khathi on 2025/05/22.
//

import Foundation

enum DateManager: String {

    case day = "EEEE"
    case date = "EEEE, MMM d"
    case time = "h:mm a"

    func stringFrom(date: Date) -> String {
        let dateFormatter = DateFormatter()
        switch self {
        case .day:
            dateFormatter.dateFormat = DateManager.day.rawValue
        case .date:
            dateFormatter.dateFormat = DateManager.date.rawValue
        case .time:
            dateFormatter.dateFormat = DateManager.time.rawValue
        }
        return dateFormatter.string(from: date)
    }
}
