//
//  ViewController.swift
//  Shake2.0
//
//  Created by Antonio Padilla on 5/30/19.
//  Copyright © 2019 GenOrg. All rights reserved.
//

import UIKit
import CoreLocation



/// App launches to this view controller
///
class ViewController: UIViewController {
    
    @IBOutlet weak var iconImage: UIImageView!
    var indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .gray)
    var results = [Place]()
    var userCoord: CLLocationCoordinate2D?
    var locationNames: [String?]?
    var locationView: LocationView?
    
    // light status bar for dark background
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - Override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        iconImage.rotationAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
}

extension ViewController {
    
    // places the activity indicator directly underneath the icon image
    func activitySetup() {
        let x = iconImage.bx(withOffset: -iconImage.frameW)
        let y = iconImage.by(withOffset: -iconImage.frameH/4)
        let w = iconImage.frameW
        let h = iconImage.frameH
        indicator.color = Colors.CFOrange
        view.addSubview(self.indicator)
        indicator.frame = CGRect(x: x, y: y, width: w, height: h)
        indicator.hidesWhenStopped = true
    }
    
    // runs a nearby search for the closest CoinFlip Bitcoin ATMs
    func runNearbyQuery() {
        activitySetup()
        indicator.startAnimating()
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
                    let resp = try? JSONDecoder().decode(GooglePlacesResponse.self, from: data!)
                    self.results = resp!.results
                    locationNames = results.map({($0.name)})
                    let manager = appDelegate.locationManager
                    if let location = manager.location {
                        userCoord = location.coordinate
                    }
                    manager.stopUpdatingLocation()
                    print("done")
                    DispatchQueue.main.async {
                        self.locationViewInit()
                    }
                    self.getDetail(at: 0)
//                    self.getDetail(at: 1)
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
    
    func locationViewInit() {
        let w: CGFloat = view.frameH/2.25
        let x: CGFloat = view.center.x - w/2
        let y: CGFloat = view.center.y - w/1.5
        let frame = CGRect(x: x, y: y, width: w, height: w)
        
        locationView = LocationView(frame: frame)
        locationView?.roundView(borderWidth: 2.0)
        
        view.addSubview(locationView!)
    }
    
    func getDetail(at index: Int) {
        let id = results[index].pID
        let params: Parameters = ["placeid": "\(id)",
            "key": "\(getApiKey())"]
        let session = URLSession.shared
        var search = GoogleSearch(type: .DETAIL, parameters: params)
        search.makeRequest(session, handler: detailCompletion)
    }
    
    func detailCompletion(data: Data?) {
        if data != nil {
            DispatchQueue.main.sync {
                do {
                    let json = try
                        JSONSerialization.jsonObject(with: data!,
                                                     options: .mutableContainers)
                        as! NSDictionary
                    let status: String? = json["status"] as? String
                    if status != nil && status! == "OK" {
//                        let resp = try? JSONDecoder().decode(GoogleDetailResponse.self, from: data!)
                        //print(resp!)
                        print("\n\n\(json)\n\n")
                        DispatchQueue.main.async { self.indicator.stopAnimating() }
                    }
                } catch {
                    //TODO: - handle invalid json conversion error
                }
            }
        } else {
            //TODO: - handle invalid response
        }
    }
}

