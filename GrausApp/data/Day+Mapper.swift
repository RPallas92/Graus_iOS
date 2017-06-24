//
//  Day+Mapper.swift
//  GrausApp
//
//  Created by Pallas, Ricardo on 5/6/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import Foundation

extension Day {
    static func parse(httpResponse: HTTPURLResponse, data: Data) throws -> LoadDaysResponse {
        if httpResponse.statusCode != 200 {
            return Result.failure(ApiError.serverError)
        }
        
        let jsonRoot = try Day.parseJSON(httpResponse, data: data)
        
        guard let json = jsonRoot as? [String: AnyObject] else {
            throw SystemError("Casting to dictionary failed")
        }
        
        let days = try Day.parse(json)
        return Result.success(days)
    }
    
    private static func parse(_ json: [String: AnyObject]) throws -> [Day] {
        guard let items = json["dias"] as? [[String: AnyObject]] else {
            throw SystemError("Can't find items")
        }
        return try items.map { item in
            guard let rawDay = item["dia"] as? String else {
                    throw SystemError("Can't parse Day")
            }
            
            let parsedDay = try parseDay(object: rawDay)
            return parsedDay
        }
    }
    
    
    
    private static func parseJSON(_ httpResponse: HTTPURLResponse, data: Data) throws -> AnyObject {
        if !(200 ..< 300 ~= httpResponse.statusCode) {
            throw SystemError("Call failed")
        }
        
        return try JSONSerialization.jsonObject(with: data, options: []) as AnyObject
    }
    
    private static func parseDay(object: Any?) throws -> Day {
        guard let dateString = object as? String else {
            throw SystemError("Date is not a String")
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "dd/MM/yyyy"
        if let date = dateFormatter.date(from: dateString) {
            return date
        }
        
        throw SystemError("Couldn't parse the date!")
    }
}
  
