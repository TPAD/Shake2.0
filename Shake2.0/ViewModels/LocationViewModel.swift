//
//  LocationViewModel.swift
//  Shake2.0
//
//  Created by Antonio Padilla on 6/4/19.
//  Copyright © 2019 GenOrg. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation


class LocationViewModel: NSObject {
    
    var places: [Place]?
    var locationNames: [String]?
    var userCoord: CLLocationCoordinate2D?
    var didGetValidResponse: Bool = false
    
    override init() {
        super.init()
    }
    
    // runs a nearby search for the closest CoinFlip Bitcoin ATMs
    func runNearbyQuery() {
        if let location = appDelegate.locationManager.location {
            let session = URLSession.shared
            let coord = location.coordinate
            let lat: String = "\(coord.latitude)"
            let lng: String = "\(coord.longitude)"
            let cfParams: Parameters = ["location":"\(lat),\(lng)",
                "name":"CoinFlip",
                //"radius":"\(searchRadius)",
                "rankby":"distance",
                "type":"establishment",
                "key":"\(getApiKey())"]
            
            var searchCF = GoogleSearch(type: .NEARBY, parameters: cfParams)
            searchCF.makeRequest(session, handler: responseHandler)
        } else {
            //TODO: - alert on nil location
        }
    }
    
    ///
    /// retrieves JSON data on a http request with a successful response and parses
    /// location names
    ///
    func responseHandler(data: Data?) {
        if data != nil {
            do {
                let json = try JSONSerialization
                    .jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
                let status: String? = json["status"] as? String
                if status != nil && status! == "OK" {
                    let resp = try? JSONDecoder().decode(GooglePlacesResponse.self, from: data!)
                    let result: [Place] = resp!.results
                    print(result[0])
                    locationNames = result.map({($0.name)})
                    let manager = appDelegate.locationManager
                    if let location = manager.location {
                        userCoord = location.coordinate
                    }
                    manager.stopUpdatingLocation()
                    print("done")
                    //print(GooglePlacesResponse(results: json))
                } else if status != nil {
                    // TODO: - present alert on bad response status
                    print(status!)
                }
            } catch {
                // TODO: - present alert on json conversion error
            }
        } else {
            // TODO: - present alert if the response is invalid or the data is nil
        }
    }
    
}
