//
//  Detail.swift
//  Shake2.0
//
//  Created by Antonio Padilla on 6/11/19.
//  Copyright © 2019 GenOrg. All rights reserved.
//

import Foundation

// MARK: GoogleDetailResponse

struct GoogleDetailResponse: Codable {
    let result: Detail
    
    enum CodingKeys: String, CodingKey {
        case result = "result"
    }
}

// MARK: Detail

struct Detail: Codable {
    
    let fAddress: String        // formatted address
    let fPNumber: String        // formatted phone number
    let id: String
    let reviews: [Reviews]
    let photoRef: [PhotoReference]
    let iconLink: String
    let name: String
    let openingHours: OpeningHours
    let components: [AddressComponents]?
    let rating: Double

    enum CodingKeys: String, CodingKey {
        case fAddress = "formatted_address"
        case fPNumber = "formatted_phone_number"
        case id = "place_id"
        case reviews = "reviews"
        case photoRef = "photos"
        case iconLink = "icon"
        case name = "name"
        case openingHours = "opening_hours"
        case components = "address_components"
        case rating = "rating"
    }

    struct AddressComponents: Codable {
        let longName: String
        let shortName: String
        let types: [String]
        
        enum CodingKeys: String, CodingKey {
            case longName = "long_name"
            case shortName = "short_name"
            case types = "types"
        }
    
    }
    
    struct Reviews: Codable {
        let name: String
        let photoRef: String
        let text: String
        let rating: Int

        enum CodingKeys: String, CodingKey {
            case name = "author_name"
            case photoRef = "profile_photo_url"
            case text = "text"
            case rating = "rating"
        }
    }
    
    struct PhotoReference: Codable {
        let ref: String
        
        enum CodingKeys: String, CodingKey {
            case ref = "photo_reference"
        }
    }
    
    struct OpeningHours: Codable {
        let text: [String]
        let openNow: Bool
        
        enum CodingKeys: String, CodingKey {
            case text = "weekday_text"
            case openNow = "open_now"
        }
    }
    
}
