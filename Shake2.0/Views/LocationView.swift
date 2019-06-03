//
//  LocationView.swift
//  Shake2.0
//
//  Created by Antonio Padilla on 5/30/19.
//  Copyright © 2019 GenOrg. All rights reserved.
//
//  LocationView contains an image of the location, the name, and the rating of the location
//

import Foundation
import UIKit

class LocationView: UIView {
    
    var view: UIView!               // to be loaded from xib
    var info: LocationInfo?         // information related to the location
    var image: UIImage?             // location image
    var ratingView: UIView?         // view containing the location's rating
    var infoView: UIView?           // view containing the rest of the location information
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //commonInit()
    }
    
//    private func commonInit() {
//        view = loadViewFromNib()
//        view.frame = bounds
//        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        addSubview(view)
//    }
//
//    private func loadViewFromNib() -> UIView {
//        return UINib(nibName: "Place", bundle: nil)
//            .instantiate(withOwner: self, options: nil)[0] as! UIView
//    }
    
}

//
//  Structure containing the mimimum information displayed by the Location View
//
struct LocationInfo {
    var image: UIImage?
    var rating: Double?
    var name: String?
    
    init(image: UIImage, name: String, rating: Double) {
        self.image = image
        self.name = name
        self.rating = rating
    }
}
