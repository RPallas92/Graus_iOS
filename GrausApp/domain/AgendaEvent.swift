//
//  AgendaEvent.swift
//  GrausApp
//
//  Created by Ricardo Pallás on 28/04/2017.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import Foundation

struct AgendaEvent {
    let eventId: Int
    let name: String
    let city: String
    let description: String
    let lat: Float
    let lon: Float
    let imageUrl: String
    let imageThumbnailUrl: String
    let date: Date
    
    
    init(eventId:Int, name: String, city: String, description: String, lat: Float, lon: Float, imageUrl:String,
         imageThumbnailUrl:String, date: Date) {

        self.eventId = eventId
        self.name = name
        self.city = city
        self.description = description
        self.lat = lat
        self.lon = lon
        self.imageUrl = imageUrl
        self.imageThumbnailUrl = imageThumbnailUrl
        self.date = date
    }
    
}


