//
//  ViewController.swift
//  Shake2.0
//
//  Created by Antonio Padilla on 5/30/19.
//  Copyright © 2019 GenOrg. All rights reserved.
//

import UIKit
import CoreLocation

protocol ViewModelDelegate: class {
    func willLoadData()
    func runNextDetailSearch()
    func setLocationImage(to image: UIImage)
}

protocol DetailViewModelDelegate: class {
    func willLoadDetail()
    func detailSearchSucceded()
}


/// App launches to this view controller
///
class ViewController: UIViewController {
    
    @IBOutlet weak var iconImage: UIImageView!
    var indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .gray)
    var results = [Place]()
    var userCoord: CLLocationCoordinate2D?
    var locationNames: [String?]?
    var locationView: LocationView?
    var initialLoad: Bool = true
    var viewModel: LocationViewModel = LocationViewModel()
    var detailModel: DetailViewModel = DetailViewModel()
    var shakeNum: Int = 0
    
    
    // light status bar for dark background
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - Override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        iconImage.rotationAnimation()
        viewModel.delegate = self
        detailModel.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationViewInit()
        viewModel.imageWidth = 0.5
    }
    
}

extension ViewController: ViewModelDelegate {
    func willLoadData() {
        if initialLoad {
            activitySetup()
            indicator.startAnimating()
        }
    }
    
    func runNextDetailSearch() {
        // TODO: - run detail query
        let places = viewModel.places
        // check if valid indices
        if places.count > 0 {
            detailModel.getDetail(from: places, at: shakeNum)
        }
    }
    
    func setLocationImage(to image: UIImage) {
        self.indicator.stopAnimating()
        DispatchQueue.main.async {
            self.locationView!.locationImage.image = image
        }
        if self.initialLoad {
            UIView.animate(withDuration: 0.5, animations: {
                self.locationView?.alpha = 1
            })
        }
    }
    
}

extension ViewController: DetailViewModelDelegate {
    func willLoadDetail() {
        // TODO: - update UI to show activity
    }
    
    func detailSearchSucceded() {
        // TODO: - send view updates!
    }
}


// nearby query
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
                    do {
                        let resp = try JSONDecoder().decode(GooglePlacesResponse.self, from: data!)
                        self.results = resp.results
                        locationNames = results.map({($0.name)})
                    } catch {
                        // TODO: - handle json decoder error robustly
                        print("error: \(error)")
                    }
                    let manager = appDelegate.locationManager
                    if let location = manager.location {
                        userCoord = location.coordinate
                    }
                    manager.stopUpdatingLocation()
                    //print(json)
                    print("done")
                    DispatchQueue.main.async {
//                        self.getDetail(at: 0)
//                        self.getDetail(at: 1)
                        print(self.results[0].photos[0].photoReference)
                        self.getImage(from: self.results[0].photos[0].photoReference)
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
    
    func locationViewInit() {
        let w: CGFloat = view.frameH/2.25
        let x: CGFloat = view.center.x - w/2
        let y: CGFloat = view.center.y - w/1.5
        let frame = CGRect(x: x, y: y, width: w, height: w)
        
        locationView = LocationView(frame: frame)
        locationView!.roundView(borderWidth: 2.0)
        locationView!.alpha = 0
        view.addSubview(locationView!)
    }
    
}

// detail query
extension ViewController {
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
                        do {
                            let resp = try JSONDecoder().decode(GoogleDetailResponse.self, from: data!)
                            print(resp)
                        } catch {
                            // TODO: - handle json decoding error robustly
                            print("error: \(error)")
                        }
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

// getting an image from location photo reference
extension ViewController {
    
    func getImage(from reference: String) {
        self.locationViewInit()
        let width = Int(self.locationView!.frameW)
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
            DispatchQueue.main.async {
                self.locationView!.locationImage.image = image!
                self.indicator.stopAnimating()
                if self.initialLoad {
                    UIView.animate(withDuration: 0.5, animations: {
                        self.locationView?.alpha = 1
                    })
                }
            }
        }
    }
    
}



