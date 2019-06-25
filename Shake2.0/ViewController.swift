//
//  ViewController.swift
//  Shake2.0
//
//  Created by Antonio Padilla on 5/30/19.
//  Copyright © 2019 GenOrg. All rights reserved.
//

import UIKit
import CoreLocation

///
/// App launches to this view controller
///
class ViewController: UIViewController {
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var locationView: LocationView!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    var viewModel: LocationViewModel = LocationViewModel()
    var detailModel: DetailViewModel = DetailViewModel()
    var indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .gray)
    var userCoord: CLLocationCoordinate2D?
    var initialLoad: Bool = true
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
        DispatchQueue.main.async { self.locationView.view.roundView(borderWidth: 6) }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //locationViewInit()
    }
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        // requires that the view is loaded
        if (self.isViewLoaded == true && self.view.window != nil) {
            if let motion = event {
                if motion.subtype == .motionShake {
                    let max = viewModel.places.count
                    shakeNum = (shakeNum < max - 1 && max != 0) ? (shakeNum + 1): 0
                    DispatchQueue.main.async {
                        self.locationView.shakeAnimation()
                        self.runNextImageSearch()
                        self.runNextDetailSearch()
                        self.updateLocationUI()
                    }
                }
            }
        }
    }
    
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
    
}

//
protocol ViewModelDelegate: class {
    func willLoadData()
    func runNextDetailSearch()
    func runNextImageSearch()
    func setLocationImage(to image: UIImage)
    func updateLocationUI()
}

protocol DetailViewModelDelegate: class {
    func willLoadDetail()
    func detailSearchSucceded()
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
        let places = viewModel.places!
        // check if valid indices
        if places.count > 0 {
            detailModel.getDetail(from: places, at: shakeNum)
        }
    }
    
    func runNextImageSearch() {
        let info = viewModel.places[shakeNum].photos

        if info.count != 0 {
            let photoRef = info[0].photoReference
            let width = Float(locationView!.frameW)
            viewModel.getImage(from: photoRef, with: width)
        } else {    // TODO: - change deafult image in case where location has no images
            if let warrington = UIImage(named: "warrington") {
                setLocationImage(to: warrington)
            }
            self.locationView.locationImage.backgroundColor = Colors.pearlBlack
        }
        
    }
    
    // called by viewModel in getImage response handler
    func setLocationImage(to image: UIImage) {
        DispatchQueue.main.async {
            self.locationView!.locationImage.image = image
            self.indicator.stopAnimating()
            if self.initialLoad {
                UIView.animate(withDuration: 0.5, animations: {
                    self.locationView.alpha = 1
                })
                self.updateLocationUI()
            }
        }
    }
    
    func updateLocationUI() {
        let location = viewModel.places[shakeNum]
        let manager = appDelegate.locationManager
        UIView.animate(withDuration: 0.5, animations: { self.saveButton.alpha = 1.0 })
        viewModel.configureLocationName(locationNameLabel, using: location)
        viewModel.configureDistance(distanceLabel, using: location, manager)
        viewModel.configure(locationBubble: locationView, using: location)
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




