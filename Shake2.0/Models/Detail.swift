//
//  Detail.swift
//  Shake2.0
//
//  Created by Antonio Padilla on 6/11/19.
//  Copyright © 2019 GenOrg. All rights reserved.
//

import Foundation

struct GoogleDetailResponse: Codable {
    let result: Detail
    enum CodingKeys: String, CodingKey {
        case result = "result"
    }
}

struct Detail: Codable {
    
    let fAddress: String        // formatted address
    let fPNumber: String        // formatted phone number
    let id: String
    let reviews: [Reviews]
    let photoRef: [PhotoReference]
    let iconLink: String
    let name: String
    let openingHours: OpeningHours

    enum CodingKeys: String, CodingKey {
        case fAddress = "formatted_address"
        case fPNumber = "formatted_phone_number"
        case id = "place_id"
        case reviews = "reviews"
        case photoRef = "photos"
        case iconLink = "icon"
        case name = "name"
        case openingHours = "opening_hours"
    }

    struct Reviews: Codable {
        let name: String
        let text: String
        let rating: Int

        enum CodingKeys: String, CodingKey {
            case name = "author_name"
            case text = "text"
            case rating = "rating"
        }
    }
    
    struct PhotoReference: Codable {
        let ref = "photo_reference"
        
        enum CodingKeys: String, CodingKey {
            case ref = "photo_reference"
        }
    }
    
    struct OpeningHours: Codable {
        let text: [String]
        enum CodingKeys: String, CodingKey {
            case text = "weekday_text"
        }
    }
    
}
