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
    var detailView: DetailView?
    var detailShouldDisplay: Bool = false {
        didSet {
            DispatchQueue.main.async {
                if self.detailShouldDisplay {
                    if self.detailView == nil { self.initDetailView() }
                    UIView.animate(withDuration: 0.5, animations:{
                        self.detailView!.frame.origin.y = self.view.frameH - self.detailView!.frameH
                    })
                } else {
                    if self.detailView == nil { return }
                    UIView.animate(withDuration: 0.25, animations: {
                        self.detailView!.frame.origin.y += self.view.frameH
                    }, completion: { (completed) in
                        self.shrinkDetailView()
                    })
                }
            }
        }
    }
    
    
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(toggleDetail(_:)))
        view.addGestureRecognizer(tap)
        initDetailView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func initDetailView() {
        let w = view.frameW*0.9
        let h = view.frameH*0.825
        let x = view.frame.origin.x + (view.frameW - w)/2
        let y = view.frameH
        let rect = CGRect(x: x, y: y, width: w, height: h)
        detailView = DetailView(frame: rect)
        detailView!.backgroundColor = UIColor.white
        detailView!.delegate = self
        view.addSubview(detailView!)
    }
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        // requires that the view is loaded
        if (self.isViewLoaded == true && self.view.window != nil) {
            if let motion = event {
                if motion.subtype == .motionShake {
                    let max = viewModel.places.count
                    shakeNum = (shakeNum < max && max != 0) ? (shakeNum + 1): 0
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
    
    @objc func toggleDetail(_ sender: UITapGestureRecognizer) {
        if detailShouldDisplay == false {
            let bounds: CGRect = locationView!.frame
            let pointTapped: CGPoint = sender.location(in: view)
            if bounds.contains(pointTapped) {
                detailShouldDisplay = !detailShouldDisplay
            }
        }
    }
}




// MARK: - delegate funtions
protocol ViewModelDelegate: class {
    func willLoadData()
    func runNextDetailSearch()
    func runNextImageSearch()
    func setLocationImage(to image: UIImage)
    func updateLocationUI()
}

protocol DetailViewModelDelegate: class {
    func detailSearchSucceded()
}

protocol DetailViewDelegate: class {
    func removeDetailView()
    func expandDetailView()
}

extension ViewController: ViewModelDelegate {
    
    func willLoadData() {
        if initialLoad {
            activitySetup()
            indicator.startAnimating()
        }
    }
    
    func runNextDetailSearch() {
        let places = viewModel.places!
        // check if valid indices
        if places.count > 0 {
            detailModel.getDetail(from: places, at: shakeNum)
        }
    }
    
    func runNextImageSearch() {
        if let info = viewModel.places[shakeNum].photos {
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
        } else {
            print("no photos")
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
    
    func detailSearchSucceded() {
        // TODO: - send view updates!
        let detail = detailModel.placeDetails[shakeNum]
        DispatchQueue.main.async {
            self.detailView?.scrollView!.details = detail
            self.updateLocationUI()
        }
    }
    
}

extension ViewController: DetailViewDelegate {
    
    // returns detail view to the dimensions of when it should display
    private func shrinkDetailView() {
        let w = view.frameW*0.9
        let h = view.frameH*0.825
        let x = view.frame.origin.x + (view.frameW - w)/2
        let y = view.frameH
        self.detailView!.frame = CGRect(x: x, y: y, width: w, height: h)
    }
    
    func removeDetailView() {
        self.detailShouldDisplay = false
    }
    
    // expands the detail view to fit screen 
    func expandDetailView() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, animations: {
                self.detailView!.frame.origin.y = self.view.frame.origin.y
                self.detailView!.frame.size.width = self.view.frame.width
                self.detailView!.frame.size.height = self.view.frame.height
                self.detailView!.frame.origin.x = self.view.frame.origin.x
            })
        }
    }
    
}



