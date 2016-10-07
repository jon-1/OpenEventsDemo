//
//  OpenEvent.swift
//
//
//  Created by Jon on 10/6/16.
//
//

import Foundation
import SwiftyJSON

protocol JSONable {
    static func fromJSON(_: JSON) -> Self
}

struct OpenEvent : JSONable {
    
    let id : String
    let eventName : String
    let description : String
    let distance : Int
    let groupName : String
    let eventURL: String
    let photoURL : String
    let venueAddress : Address
    
    init(id: String, eventName: String, description: String, distance: Int, eventURL: String, groupName: String, photoURL: String, venueAddress: Address) {
        self.id = id
        self.eventName = eventName
        self.description = description
        self.distance = distance
        self.groupName = groupName
        self.eventURL = eventURL
        self.photoURL = photoURL
        self.venueAddress = venueAddress
    }
    
    static func fromJSON(_ json: JSON) -> OpenEvent {
        let id = json["id"].stringValue
        let eventName = json["name"].stringValue
        let description = json["description"].stringValue
        let distance = json["distance"].intValue
        let eventURL = json["event_url"].stringValue
        let groupName = json["group"]["name"].stringValue
        let photoURL = json["photo_url"].stringValue
        let venueAddress = Address.fromJSON(json["venue"])
        return OpenEvent(id: id, eventName: eventName, description: description, distance: distance, eventURL: eventURL, groupName: groupName, photoURL: photoURL, venueAddress: venueAddress)
    }
    
    
}
