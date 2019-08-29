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

protocol LocationViewDelegate: class {
    func handleTap()
}

// MARK: LocationView
class LocationView: UIView {
    
    weak var delegate: LocationViewDelegate!
    
    var view: UIView!  // this will be our nib
    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var infoViewLabel: UILabel!
    @IBOutlet weak var cosmosView: CosmosView!
    var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    var indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .gray)
    
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
        configTapGestureRecognizer()
        activityIndicatorSetup()
        addSubview(view)
    }
    
    // Load the corresponding nib & replace aliases
    private func loadViewFromNib() -> UIView {
        return UINib(nibName: "LocationBubble", bundle: nil)
            .instantiate(withOwner: self, options: nil)[0] as! UIView
    }
    
    private func configTapGestureRecognizer() {
        tapGestureRecognizer.addTarget(self, action: #selector(toggleDetail(_:)))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func toggleDetail(_ sender: UITapGestureRecognizer) {
        delegate.handleTap()
    }
    
    private func activityIndicatorSetup() {
        indicator.color = Colors.CFOrange
        indicator.frame = bounds
        indicator.hidesWhenStopped = true
        view.addSubview(indicator)
    }
    
}

extension ViewController: LocationViewDelegate {
    
    func handleTap() {
        if (!detailShouldDisplay) { showDetailView() }
        else { hideDetailView() }
        detailShouldDisplay = (detailShouldDisplay) ? false:true
    }
}
