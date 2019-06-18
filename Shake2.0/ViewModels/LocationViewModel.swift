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
    
    var places: [Place] = [Place]()
    var locationNames: [String] = [String]()
    var imageWidth: Float = 0.0
    
    weak var delegate: ViewModelDelegate!
    
    override init() {
        super.init()
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
        }
    }
    
    ///
    /// retrieves JSON data on a successful http request with a successful response and parses
    /// location names
    ///
    func responseHandler(data: Data?) {
        if data != nil {
            do {
                let json = try JSONSerialization
                    .jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
                let status: String? = json["status"] as? String
                if status != nil && status! == "OK" {
                    do {
                        let resp = try JSONDecoder().decode(GooglePlacesResponse.self, from: data!)
                        places = resp.results
                        locationNames = places.map({($0.name)})
                    } catch {
                        // TODO: - handle json decoder error robustly
                        print("error: \(error)")
                    }
                    let manager = appDelegate.locationManager
                    // check if results is not empty
                    let photoReference = places[0].photos[0].photoReference
                    manager.stopUpdatingLocation()
                    //print(json)
                    print("done")
                    DispatchQueue.main.async {
                        self.delegate!.runNextDetailSearch()
                        self.getImage(from: photoReference, with: self.imageWidth)
                    }
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
        if data == nil {
            //TODO: - handle
        }
        let image = UIImage(data: data!)
        if image == nil {
            //TODO: - handle
        } else {
            delegate!.setLocationImage(to: image!)
        }
    }
    
    
}
