//
//  AgendaEvent.swift
//  GrausApp
//
//  Created by Ricardo Pallás on 28/04/2017.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import Foundation
import Mapper

//TODO Anemic model

struct AgendaEvent : Mappable {
    let eventId: Int
    let name: String
    let city: String
    let description: String
    let lat: Float
    let lon: Float
    let imageUrl: String
    let imageThumbnailUrl: String
    let date: Date
    
    
    init(map: Mapper) throws {
        try eventId = map.from("idEvento")
        try name = map.from("nombre")
        try city = map.from("lugar")
        try description = map.from("texto")
        try lat = map.from("coordenadaX")
        try lon = map.from("coordenadaY")
        try imageUrl = map.from("imagen")
        try imageThumbnailUrl = map.from("thumbnail")
        try date = map.from("fecha", transformation: parseDate)
    }
    
}

private func parseDate(object: Any?) throws -> Date {
    guard let dateString = object as? String else {
        throw MapperError.customError(field: nil, message: "Date is not an string")
    }
    
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale.current
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    if let date = dateFormatter.date(from: dateString) {
        return date
    }
    
    throw MapperError.customError(field: nil, message: "Couldn't parse the date!")
}
