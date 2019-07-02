//
//  LocationView.swift
//  Shake2.0
//
//  Created by Antonio Padilla on 5/30/19.
//  Copyright © 2019 GenOrg. All rights reserved.
//
//  LocationView contains an image of the location, the name, and the rating of the location
//
//  Visually: the circle/bubble in the middle of the screen which displays basic, upfront
//            information pertaining to the current "shake"
//

import Foundation
import UIKit

// MARK: LocationView

class LocationView: UIView {
    
    var view: UIView!  // this will be our nib
    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var infoViewLabel: UILabel!
    @IBOutlet weak var cosmosView: CosmosView!
    
    // Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    // Load the corresponding nib & replace aliases
    private func loadViewFromNib() -> UIView {
        return UINib(nibName: "LocationBubble", bundle: nil)
            .instantiate(withOwner: self, options: nil)[0] as! UIView
    }
    
}
