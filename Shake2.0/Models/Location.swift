//
//  Location.swift
//  Shake2.0
//
//  Created by Jack Kasbeer on 6/7/19.
//  Copyright © 2019 GenOrg. All rights reserved.
//
//
//  This file contains thee location model
//

import Foundation

// Response codable struct to contain the initial response from google nearby api
struct GooglePlacesResponse: Codable {
    let results: [Place]
    enum CodingKeys: String, CodingKey {
        case results = "results"
    }
}

// place model
struct Place: Codable {
    
    let geometry: Location
    let name: String
    let openingHours: OpenNow?
    let photos: [PhotoInfo]
    let types: [String]
    let address: String
    let pID: String
    let rating: Float?
    
    enum CodingKeys: String, CodingKey {
        case geometry = "geometry"
        case name = "name"
        case openingHours = "opening_hours"
        case photos = "photos"
        case types = "types"
        case address = "vicinity"
        case pID = "place_id"
        case rating = "rating"
    }
    
    // model for location data
    struct Location: Codable {
        let location: LatLong
        enum CodingKeys: String, CodingKey { case location = "location" }
        struct LatLong: Codable {
            let latitude: Double
            let longitude: Double
            enum CodingKeys: String, CodingKey {
                case latitude = "lat"
                case longitude = "lng"
            }
        }
    }
    
    // model for getting open data
    struct OpenNow: Codable {
        let isOpen: Bool
        enum CodingKeys: String, CodingKey { case isOpen = "open_now" }
    }
    
    // model for image information to be used in image query
    struct PhotoInfo: Codable {
        let height: Int
        let width: Int
        let photoReference: String
        enum CodingKeys: String, CodingKey {
            case height = "height"
            case width = "width"
            case photoReference = "photo_reference"
        }
    }
}
