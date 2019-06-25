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

///
///
///
///
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
                    //let manager = appDelegate.locationManager
                    // check if results is not empty
                    //manager.stopUpdatingLocation()
                    DispatchQueue.main.sync {
                        self.delegate!.runNextDetailSearch()
                        self.delegate!.runNextImageSearch()
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
    
    func configureLocationName(_ label: UILabel, using place: Place) {
        let addressComponents: [String] = place.address.components(separatedBy: ",")
        // TODO: - might have to check if the above seperation of components fails
        label.text = addressComponents[0]
        UIView.animate(withDuration: 0.5, animations: { label.alpha = 1.0 })
    }
    
    func configureDistance(_ label: UILabel, using place: Place, _ manager: CLLocationManager) {
        // TODO: - implement calculation of distance logic
        UIView.animate(withDuration: 0.5, animations: { label.alpha = 1.0 })
        let lat = place.geometry.location.latitude
        let long = place.geometry.location.longitude
        let destination: CLLocation = CLLocation(latitude: lat, longitude: long)
        if let userLocation: CLLocation = manager.location {
            let distance = userLocation.distanceInMilesFromLocation(destination)
            let distanceString = String(format: "%.2f", distance)
            label.text = "\(distanceString)mi"
        } else {
            // TODO: - notify the user location manager failed to get their location
        }
    }
    
    func updateDistance(_ label: UILabel, using place: Place, _ manager: CLLocationManager) {
        let lat: Double = place.geometry.location.latitude
        let long: Double = place.geometry.location.longitude
        let destination: CLLocation = CLLocation(latitude: lat, longitude: long)
        DispatchQueue.main.async {
            if let userLocation: CLLocation = manager.location {
                let distance = userLocation.distanceInMilesFromLocation(destination)
                let distanceString = String(format: "%.2f", distance)
                label.text = "\(distanceString)mi"
            }
            // TODO: - notify user distance update failed
        }
       
    }
    
    func configure(locationBubble: LocationView, using place: Place) {
        let name = place.name
        // place name in bubble displays the neighborhood of location (usually in parentheses)
        if let r1 = name.range(of: "(")?.upperBound, let r2 = name.range(of: ")")?.lowerBound,
            let hrs = place.openingHours {
            // TODO: - check for case: desired name not in parentheses
            locationBubble.infoViewLabel.text = String(name[r1..<r2])
            // TODO: - check for case: place missing openingHours
            locationBubble.ratingView.backgroundColor =
                hrs.isOpen ? Colors.mediumSeaweed: Colors.mediumFirebrick
            locationBubble.name.textColor = hrs.isOpen ? Colors.mediumSeaweed: Colors.mediumFirebrick
        }
        locationBubble.cosmosView.settings.fillMode = .precise
        locationBubble.cosmosView.rating = place.rating
        locationBubble.cosmosView.starSize = 15
    }
}
