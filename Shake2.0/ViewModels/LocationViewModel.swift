//
//  LocationViewModel.swift
//  Shake2.0
//
//  Created by Antonio Padilla on 6/4/19.
//  Copyright © 2019 GenOrg. All rights reserved.
//

import Foundation
import UIKit

class LocationViewModel: NSObject {
    
    var places: [Place]!
    var locationNames: [String]!
    
    weak var delegate: ViewModelDelegate!
    
    override init() {
        super.init()
        places = [Place]()
        locationNames = [String]()
    }
    
    // runs a nearby search for the closest CoinFlip Bitcoin ATMs
    func runNearbyQuery() {
        delegate!.willLoadData()
        if let location = appDelegate.locationManager.location {
            let session = URLSession.shared
            let coord = location.coordinate
            let lat: String = "\(coord.latitude)"
            let lng: String = "\(coord.longitude)"
            let gasParams: Parameters = ["location":"\(lat),\(lng)",
                "name":"CoinFlip",
                //"radius":"\(searchRadius)",
                "rankby":"distance",
                "type":"establishment",
                "key":"\(getApiKey())"]
            
            var searchCF = GoogleSearch(type: .NEARBY, parameters: gasParams)
            searchCF.makeRequest(session, handler: responseHandler)
        } else {
            //TODO: - alert on nil location
            // 1) Present dialog box on screen:
            // "Unfortunately, there are no CoinFlip ATMs within 100 mi of you.
            //  Call us for more info: (773) 800-0106"
            //
            // 2) Make view the background + ':(' where location bubble would normally be
        }
    }
    
    ///
    /// retrieves JSON data on a successful http request with a successful response and parses
    /// location names
    ///
    func responseHandler(data: Data?) {
        if let data = data {
            do {
                let json = try JSONSerialization
                    .jsonObject(with: data, options: .mutableContainers) as! NSDictionary
                let status: String? = json["status"] as? String
                if let status = status {
                    if status == "OK" {
                        do {
                            let resp = try JSONDecoder().decode(GooglePlacesResponse.self, from: data)
                            places = resp.results
                            locationNames = places.map({($0.name)})
                        } catch {
                            // TODO: - handle json decoder error robustly
                            print("error: \(error)")
                        }
                        let manager = appDelegate.locationManager
                        // check if results is not empty
                        manager.stopUpdatingLocation()
                        print("done")
                        print(json)
                        DispatchQueue.main.async {
                            self.delegate!.runNextDetailSearch()
                            self.delegate!.runNextImageSearch()
                            self.delegate!.updateLocationUI()
                        }
                    } else {
                        // TODO: - status != OK
                        // handleHttpStatusError(json, status)
                    }
                } else {
                    // TODO: - present alert on bad response status
                    // SHOULD NEVER REACH HERE
                    print(status!)
                }
            } catch {
                // TODO: - present alert on json conversion error
            }
        } else {
            // TODO: - present alert if the response is invalid or the data is nil
        }
    }
    
    func getImage(from reference: String, with width: Float) {
        let width = Int(width)
        let session = URLSession.shared
        let params: Parameters = ["maxwidth":"\(width)",
            "photoreference":"\(reference)",
            "key":"\(getApiKey())"]
        var search = GoogleSearch(type: .PHOTO, parameters: params)
        search.makeRequest(session, handler: imageCompletion)
    }
    
    func imageCompletion(data: Data?) {
        if let data = data {
            if let image = UIImage(data: data) {
                delegate!.setLocationImage(to: image)
            } else {
                // TODO: handle error
            }
        } else {
            // TODO: handle error
        }
    }
    
    // MARK: Helper functions
    
    // Function to handle all HTTP responses with status != OK
    // e.g. 301, 304, 404,...
    func handleHttpStatusError(response: NSDictionary, status: String) {
        switch status {
        case "Moved Permanently",
             "Permanent Redirect":
            // Re-execute HTTP request with new URI from response
            let _ = 5
        case "Not Modified":
            // Re-use previous results (they haven't been altered)
            let _ = 5
        case "Bad Request",
             "Forbidden",
             "Not Found":
            // Error on OUR PART: misformed URI
            let _ = 5
        case "Request Timeout":
            // Re-configure connection to server & re-excute request
            let _ = 5
        case "Internal Server Error",
             "Service Unavailable":
            // GoogleMaps API is failing (on their end); inform the user service is unavailable
            let _ = 5
        default:
            // Some default way of handling non-OK HTTP response statuses
            let _ = 5
        }
    }
}
