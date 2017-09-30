//
//  Day.swift
//  GrausApp
//
//  Created by Pallas, Ricardo on 5/6/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import Foundation
import Cache

typealias Day = Date

extension Day {
    
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
    
    func toReadableString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "EEEEMMddyyyy", options: 0, locale: Locale.current)
        return dateFormatter.string(from: self)
    }
    
    func toHourString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "HH:mm", options: 0, locale: Locale.current)
        return dateFormatter.string(from: self)
    }
    
    static func getToday() -> Day {
        let date = Date()
        let cal = Calendar(identifier: .gregorian)
        return cal.startOfDay(for: date)
    }
    
    static func getTheDayBefore(from day:Day) -> Day {
        let date = Date()
        let cal = Calendar(identifier: .gregorian)
        let currentDay = cal.startOfDay(for: date)
        let theDayBefore = cal.date(byAdding: .day, value: -1, to: currentDay)
        return theDayBefore!
    }
    
    func toJsonString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: self)
    }
    
    static func fromString(dateString: String) -> Day {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: dateString) {
            return date
        }
        return Date()
    }
}
