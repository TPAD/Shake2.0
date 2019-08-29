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

// MARK: LocationViewModel

/// A LocationViewModel consists of:
///  - an array of Place's
///  - a ViewModelDelegate
///  - an array of images for the Place's
///  - an array of location names
class LocationViewModel: NSObject {
    
    var places: [Place]!
    var placeImgs: [UIImage] = [UIImage]()
    var locationNames: [String]!
    
    weak var delegate: LocationViewModelDelegate!
    
    override init() {
        super.init()
        places = [Place]()
        locationNames = [String]()
    }
    
    
    // GoogleMaps API call
    // Runs a nearby search for the closest CoinFlip Bitcoin ATMs
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
    
    private func handleStatusOK(data: Data) {
        let concurrentQueue = DispatchQueue(label: "concurrent", attributes: .concurrent)
        do {
            let resp = try JSONDecoder().decode(GooglePlacesResponse.self, from: data)
            places = resp.results
            locationNames = places.map({($0.name)})
        } catch {
            // TODO: - handle json decoder error robustly
            print("Location Completion Error: \(error)")
        }
        // check if results is not empty
        appDelegate.locationManager.stopUpdatingLocation()
        print("done")
        concurrentQueue.async { self.delegate!.runNextImageSearch() }
        concurrentQueue.async { self.delegate!.runNextDetailSearch() }
    }
    
    
    // Retrieves JSON data on a successful http request with a successful response and parses
    // location names
    func responseHandler(data: Data?) {
        if let data = data {
            do {
                let json = try JSONSerialization
                    .jsonObject(with: data, options: .mutableContainers) as! NSDictionary
                let status: String? = json["status"] as? String
                if let status = status {
                    switch(status) {
                    case "OK":
                        print("status OK")
                        handleStatusOK(data: data); break
                    case "UNKNOWN_ERROR":
                        print("Error: \(status)")
                        break   // TODO: - indicates a server side error; possible success on retry
                    case "ZERO_RESULTS":
                        print("Error: \(status)")
                        break   // TODO: - update UI to indicate no results were returned
                    case "OVER_QUERY_LIMIT":
                        print("Error: \(status)")
                        break   // TODO: -
                    case "REQUEST_DENIED":
                        print("Error: \(status)")
                        break   // TODO: - request might be missing API key or invalid key parameter
                    case "INVALID_REQUEST":
                        print("Error: \(status)")
                        break   // TODO: - generally indicates a missing placeid
                    case "NOT_FOUND":
                        print("Error: \(status)")
                        break   // TODO: - indicates placeid was not found in Places database
                    default:
                        print("Error: \(status)")
                        break
                    }
                } else {
                        // TODO: - status is nil
                }
            } catch {
                // TODO: - present alert on json conversion error
                // Error on app-side: handleInHouseError(json)
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
                placeImgs.append(image)
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
    private func handleHttpStatusError(response: NSDictionary, status: String) {
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
        if let userLocation: CLLocation = manager.location {
            let distance = userLocation.distanceInMilesFromLocation(destination)
            let distanceString = String(format: "%.2f", distance)
            label.text = "\(distanceString)mi"
        }
        // TODO: - notify user distance update failed
       
    }
    
    func configure(locationBubble: LocationView, using place: Place) {
        let name = place.name
        // place name in bubble displays the neighborhood of location (usually in parentheses)
        if let r1 = name.range(of: "(")?.upperBound, let r2 = name.range(of: ")")?.lowerBound {
            let hrs = place.openingHours
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
