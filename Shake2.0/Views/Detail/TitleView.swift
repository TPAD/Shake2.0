//
//  TitleView.swift
//  Shake2.0
//
//  Created by Antonio Padilla on 7/2/19.
//  Copyright © 2019 GenOrg. All rights reserved.
//

import UIKit

internal class DVHeader: UIView {
    
    /// Header View Labels
    var nameLabel: UILabel = UILabel(frame: .zero)
    var locationLabel: UILabel = UILabel(frame: .zero)
    var addressLabel: UILabel = UILabel(frame: .zero)
    
    /// constants
    let labelWidthMultiplier: CGFloat = 0.9             // relative to superview
    let nameLabelMidYMultiplier: CGFloat = 0.25         // relative to superview
    let locationLabelMidYMultiplier: CGFloat = 0.175    // relative to nameLabel base y coord
    let addressLabelMidYMultiplier: CGFloat = 0.225     // relative to locationLabel base y coord
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        headerLabelsInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func headerLabelsInit() {
        locationLabelInit()
        nameLabelInit()
        addressLabelInit()
    }
    
    private func nameLabelInit() {
        let midY: CGFloat = nameLabelMidYMultiplier * frameH
        let w: CGFloat = labelWidthMultiplier * frameW
        let rect: CGRect = CGRect(x: 0.0, y: 0.0, width: w, height: 0.0)
        nameLabel = UILabel(frame: rect)
        nameLabel.center.x = center.x
        nameLabel.center.y = midY
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        nameLabel.adjustsFontForContentSizeCategory = true
        nameLabel.text = "Coinflip Bitcoin ATM (Avondale)"
        addSubview(nameLabel)
    }
    
    private func locationLabelInit() {
        let w: CGFloat = labelWidthMultiplier * frameW
        let rect: CGRect = CGRect(x: 0.0, y: 0.0, width: w, height: 0.0)
        locationLabel = UILabel(frame: rect)
        locationLabel.center.x = center.x
        locationLabel.center.y = center.y
        locationLabel.textAlignment = .center
        locationLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        locationLabel.adjustsFontForContentSizeCategory = true
        locationLabel.text = "Worldwide Food & Liquors"
        addSubview(locationLabel)
    }
    
    private func addressLabelInit() {
        let offset: CGFloat = addressLabelMidYMultiplier * frameH
        let midY: CGFloat = locationLabel.by(withOffset: offset)
        let rect: CGRect = CGRect(x: 0.0, y: 0.0, width: frameW, height: 0.0)
        addressLabel = UILabel(frame: rect)
        addressLabel.center.x = center.x
        addressLabel.center.y = midY
        addressLabel.textAlignment = .center
        addressLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        addressLabel.adjustsFontForContentSizeCategory = true
        addressLabel.text = "1234 Diversey Ave, Chicago IL 60210"
        addSubview(addressLabel)
    }
    
    func updateViews(using detail: Detail) {
        let isOpen: Bool = detail.openingHours.openNow
        nameLabel.text = detail.name
        locationLabel.text = detail.components![1].longName
        addressLabel.text = detail.fAddress
        backgroundColor = isOpen ? Colors.mediumSeaweed:Colors.mediumFirebrick
        DispatchQueue.main.async {
            self.nameLabel.adjustsFontSizeToFitWidth = true
            self.nameLabel.bounds.size.height = 25.0
            self.locationLabel.adjustsFontSizeToFitWidth = true
            self.locationLabel.bounds.size.height = 25.0
            self.addressLabel.adjustsFontSizeToFitWidth = true
            self.addressLabel.bounds.size.height = 25.0
        }
    }
    
    /// method for toggle view label frames on detail view shrink/expansion
    func adjustLabelFrames(_ viewExpanded: Bool) {
        DispatchQueue.main.async {
            self.adjustNameLabelFrame(viewExpanded)
            self.adjustLocationLabelFrame(viewExpanded)
            self.adjustAddressLabelFrame(viewExpanded)
        }
    }
    
    private func adjustNameLabelFrame(_ viewExpanded: Bool) {
        nameLabel.center.x = center.x
        if viewExpanded {
        } else {
            
        }
    }
    
    private func adjustLocationLabelFrame(_ viewExpanded: Bool) {
        locationLabel.center.x = center.x
        if viewExpanded {
            
        } else {
            
        }
    }
    
    private func adjustAddressLabelFrame(_ viewExpanded: Bool) {
        addressLabel.center.x = center.x
        if viewExpanded {
            
        } else {
            
        }
    }
}


internal class TitleView: UIView {
    var neighborhoodLabel: UILabel?
    var storeNameLabel: UILabel?
    var addressLabel: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initLabels()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initLabels() {
        initNeighborhoodLabel()
        initStoreNameLabel()
        initAddressLabel()
    }
    
    private func initNeighborhoodLabel() {
        let midY: CGFloat = 0.25*self.frameH
        let w: CGFloat = 0.9*self.frameW
        let rect = CGRect(x: 0.0, y: 0.0, width: w, height: 20.0)
        neighborhoodLabel = UILabel(frame: rect)
        neighborhoodLabel!.text = "Coinflip Bitcoin ATM (Avondale)"
        neighborhoodLabel!.textColor = UIColor.white
        neighborhoodLabel!.center.x = self.center.x
        neighborhoodLabel!.center.y = midY
        neighborhoodLabel!.textAlignment = .center
        neighborhoodLabel!.font = UIFont(name: "System", size: 23.0)
        neighborhoodLabel!.bounds.size.height = neighborhoodLabel!.requiredHeight()
        self.addSubview(neighborhoodLabel!)
    }
    
    private func initStoreNameLabel() {
        let w: CGFloat = 0.9*self.frameW
        let midY: CGFloat = neighborhoodLabel!.by(withOffset: 0.175*self.frameH)
        let rect = CGRect(x: 0.0, y: 0.0, width: w, height: 20.0)
        storeNameLabel = UILabel(frame: rect)
        storeNameLabel!.text = "Worldwide Food & Liquors"
        storeNameLabel!.textColor = UIColor.white
        storeNameLabel!.center.x = self.center.x
        storeNameLabel!.center.y = midY
        storeNameLabel!.font = UIFont(name: "System", size: 20.0)
        storeNameLabel!.textAlignment = .center
        storeNameLabel!.bounds.size.height = storeNameLabel!.requiredHeight()
        self.addSubview(storeNameLabel!)
        
    }
    
    private func initAddressLabel() {
        let midY: CGFloat = storeNameLabel!.by(withOffset: 0.225*self.frameH)
        let rect = CGRect(x: 0.0, y: 0.0, width: frameW, height: 20.0)
        addressLabel = UILabel(frame: rect)
        addressLabel!.text = "1234 Diversey Ave, Chicago IL 60210"
        addressLabel!.textColor = UIColor.white
        addressLabel!.center.x = self.center.x
        addressLabel!.center.y = midY
        addressLabel!.font = UIFont(name: "System", size: 17.0)
        addressLabel!.adjustsFontSizeToFitWidth = true
        addressLabel!.textAlignment = .center
        addressLabel!.bounds.size.height = addressLabel!.requiredHeight()
        self.addSubview(addressLabel!)
        
    }
    
    func updateViews(using detail: Detail) {
        let neighborhoodText: String = detail.name
        let storeText: String = detail.components![1].longName
        let addressText: String = detail.fAddress
        let isOpen: Bool = detail.openingHours.openNow
        self.backgroundColor = isOpen ? Colors.mediumSeaweed:Colors.mediumFirebrick
        neighborhoodLabel!.text = neighborhoodText
        storeNameLabel!.text = storeText
        addressLabel!.text = addressText
    }
    
}


