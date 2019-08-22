//
//  ViewModelDelegate.swift
//  Shake2.0
//
//  Created by Antonio Padilla on 8/22/19.
//  Copyright © 2019 GenOrg. All rights reserved.
//

import Foundation
import UIKit

protocol LocationViewModelDelegate: class {
    func willLoadData()
    func runNextDetailSearch()
    func runNextImageSearch()
    func setLocationImage(to image: UIImage)
    func updateLocationUI()
}

extension ViewController: LocationViewModelDelegate {
    
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
                }) { (_) in
                    self.initialLoad = false
                }
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
