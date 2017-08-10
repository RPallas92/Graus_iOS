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
    
    func toJsonDict() -> [String:[[String: AnyObject]]]{
        var jsonDict = [String:[[String: AnyObject]]]()
        for (day, agendaEvents) in self {
            jsonDict[day.toString()] = AgendaEvent.toJsonDict(agendaEvents: agendaEvents)
        }
        return jsonDict
    }
    
    static func fromJsonDict(jsonDict: [String:Any]) -> DaysWithEvents{
        var dayWithEventsDict = DaysWithEvents()
        for (dayString, agendaEventsAny) in jsonDict {
            let agendaEvents = agendaEventsAny as! [AgendaEvent] //TODO parse
            let day = Day.fromString(dateString: dayString)
            dayWithEventsDict[day] = agendaEvents
        }
        return dayWithEventsDict
    }
}
