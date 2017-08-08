//
//  AgendaEvent.swift
//  GrausApp
//
//  Created by Ricardo Pallás on 28/04/2017.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import Foundation
import RxDataSources
import Cache

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

extension AgendaEvent: Coding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(eventId, forKey: "eventId")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(city, forKey: "city")
        aCoder.encode(description, forKey: "description")
        aCoder.encode(lat, forKey: "lat")
        aCoder.encode(lon, forKey: "lon")
        aCoder.encode(imageUrl, forKey: "imageUrl")
        aCoder.encode(imageThumbnailUrl, forKey: "imageThumbnailUrl")
        aCoder.encode(date, forKey: "date")
    }

    init?(coder aDecoder: NSCoder) {
        guard
            let anEventId = aDecoder.decodeObject(forKey: "eventId") as? String,
            let aName = aDecoder.decodeObject(forKey: "name") as? String,
            let aCity = aDecoder.decodeObject(forKey: "city") as? String,
            let aDescription = aDecoder.decodeObject(forKey: "description") as? String,
            let aLat = aDecoder.decodeObject(forKey: "lat") as? Float,
            let aLon = aDecoder.decodeObject(forKey: "lon") as? Float,
            let aDate = aDecoder.decodeObject(forKey: "date") as? Date
        else { return nil }
        
        let anImageUrl = aDecoder.decodeObject(forKey: "imageUrl") as? String
        let anImageThumbnailUrl = aDecoder.decodeObject(forKey: "imageThumbnailUrl") as? String
        
        self.init(eventId: anEventId, name: aName, city: aCity, description: aDescription, lat: aLat, lon: aLon, imageUrl: anImageUrl, imageThumbnailUrl: anImageThumbnailUrl, date: aDate)
    }
}
