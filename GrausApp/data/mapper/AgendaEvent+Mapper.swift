//
//  AgendaEvent+Mapper.swift
//  GrausApp
//
//  Created by Pallas, Ricardo on 5/6/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import Foundation
import RxFeedback

extension AgendaEvent {
    static func parse(httpResponse: HTTPURLResponse, data: Data) throws -> LoadAgendaEventsResponse {
        if httpResponse.statusCode != 200 {
            return Result.failure(ApiError.serverError)
        }
        
        let jsonRoot = try AgendaEvent.parseJSON(httpResponse, data: data)
        
        guard let json = jsonRoot as? [String: AnyObject] else {
            throw SystemError("Casting to dictionary failed")
        }
        
        let agendaEvents = try AgendaEvent.parse(json)
        
        
        return Result.success(agendaEvents)
    }
    
    private static func parse(_ json: [String: AnyObject]) throws -> [AgendaEvent] {
        guard let items = json["eventos"] as? [[String: AnyObject]] else {
            throw SystemError("Can't find items")
        }
        return try parse(items)
    }
    
    static func parse(_ json: [[String: AnyObject]]) throws -> [AgendaEvent] {
        return try json.map { item in
            guard let eventId = item["idEvento"] as? String,
                let name = item["nombre"] as? String,
                let city = item["lugar"] as? String,
                let description = item["texto"] as? String,
                let lat = item["coordenadaX"] as? String,
                let lon = item["coordenadaY"] as? String,
                let date = item["fecha"] as? String,
                let parsedLat = Float.init(lat),
                let parsedLon = Float.init(lon)
                
                else {
                    throw SystemError("Can't parse AgendaEvent")
            }
            
            let imageUrl = item["imagen"] as? String
            let imageThumbnailUrl = item["thumbnail"] as? String
            
            let parsedDate = try parseDate(object: date)
            
            
            
            return AgendaEvent(eventId: eventId, name: name, city: city, description: description, lat: parsedLat, lon: parsedLon, imageUrl: imageUrl, imageThumbnailUrl: imageThumbnailUrl, date: parsedDate)
        }
    }
    
    static func toJsonDict(agendaEvents: [AgendaEvent]) -> [[String: AnyObject]] {
        return agendaEvents.map { agendaEvent in
            var jsonDict = [String: AnyObject]()
            jsonDict["idEvento"] = agendaEvent.eventId as AnyObject
            jsonDict["nombre"] = agendaEvent.name as AnyObject
            jsonDict["lugar"] = agendaEvent.city as AnyObject
            jsonDict["texto"] = agendaEvent.description as AnyObject
            jsonDict["coornedadaX"] = String(agendaEvent.lat) as AnyObject
            jsonDict["coornedadaY"] = String(agendaEvent.lon) as AnyObject
            jsonDict["fecha"] = agendaEvent.date.toJsonString() as AnyObject
            jsonDict["imagen"] = agendaEvent.imageUrl as AnyObject
            jsonDict["thumbnail"] = agendaEvent.imageThumbnailUrl as AnyObject

            return jsonDict
        }
    }
    
    
    private static func parseJSON(_ httpResponse: HTTPURLResponse, data: Data) throws -> AnyObject {
        if !(200 ..< 300 ~= httpResponse.statusCode) {
            throw SystemError("Call failed")
        }
        
        return try JSONSerialization.jsonObject(with: data, options: []) as AnyObject
    }
    
    private static func parseDate(object: Any?) throws -> Date {
        guard let dateString = object as? String else {
            throw SystemError("Date is not a String")
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = dateFormatter.date(from: dateString) {
            return date
        }
        
        throw SystemError("Couldn't parse the date!")
    }
}

