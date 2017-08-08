//
//  DaysWithEvents.swift
//  GrausApp
//
//  Created by Pallas, Ricardo on 6/24/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import Foundation
import Cache

typealias DaysWithEvents = [Day:[AgendaEvent]]

extension Dictionary where Key == Day, Value == Array<AgendaEvent> {
    
    func toJsonDict() -> [String:[AgendaEvent]]{
        var jsonDict = [String:[AgendaEvent]]()
        for (day, agendaEvents) in self {
            jsonDict[day.toString()] = agendaEvents
        }
        return jsonDict
    }
    
    func fromJsonDict(jsonDict: [String:[AgendaEvent]]) -> DaysWithEvents{
        var dayWithEventsDict = DaysWithEvents()
        for (dayString, agendaEvents) in jsonDict {
            let day = Day.fromString(dateString: dayString)
            dayWithEventsDict[day] = agendaEvents
        }
        return dayWithEventsDict
    }
}
