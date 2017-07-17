//
//  AgendaEvent.swift
//  GrausApp
//
//  Created by Ricardo Pallás on 28/04/2017.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import Foundation
import RxDataSources

struct AgendaEvent {
    let eventId: String
    let name: String
    let city: String
    let description: String
    let lat: Float
    let lon: Float
    let imageUrl: String?
    let imageThumbnailUrl: String?
    let date: Date
    
    
    init(eventId:String, name: String, city: String, description: String, lat: Float, lon: Float, imageUrl:String?,
         imageThumbnailUrl:String?, date: Date) {

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
    
    
    func getUrl() -> URL?{
        if let thumbnailUrl = self.imageThumbnailUrl {
            return URL(string: thumbnailUrl)
        }
        return nil
    }
    
}

extension AgendaEvent: Equatable {}
func ==(left: AgendaEvent, right: AgendaEvent) -> Bool {
    return left.eventId == right.eventId
}


extension AgendaEvent: Hashable {
    var hashValue: Int {
        return eventId.hashValue
    }
}

extension AgendaEvent: IdentifiableType {
    var identity: Int {
        return eventId.hashValue
    }
}
