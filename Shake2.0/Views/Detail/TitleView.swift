//
//  TitleView.swift
//  Shake2.0
//
//  Created by Antonio Padilla on 7/2/19.
//  Copyright © 2019 GenOrg. All rights reserved.
//

import UIKit

// MARK: TitleView

///
/// TitleView
///
/// Composed of a red/green background (depending on whether the location is open),
///  a neighborhood label for a quick understanding of the location,
///  a store name label, and the address of the store
///
internal class TitleView: UIView {
    var neighborhoodLabel: UILabel?
    var storeNameLabel: UILabel?
    var addressLabel: UILabel?
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initLabels()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Initialize TitleView with a neighborhood label, store name label,
    // and address label
    private func initLabels() {
        initNeighborhoodLabel()
        initStoreNameLabel()
        initAddressLabel()
    }
    
    // Initialize the neighborhood label for the TitleView
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
        neighborhoodLabel!.font = Fonts.fontSystemLarge
        neighborhoodLabel!.bounds.size.height = neighborhoodLabel!.requiredHeight()
        self.addSubview(neighborhoodLabel!)
    }
    
    // Initialize the store name label for the TitleView
    private func initStoreNameLabel() {
        let w: CGFloat = 0.9*self.frameW
        let midY: CGFloat = neighborhoodLabel!.by(withOffset: 0.175*self.frameH)
        let rect = CGRect(x: 0.0, y: 0.0, width: w, height: 20.0)
        storeNameLabel = UILabel(frame: rect)
        storeNameLabel!.text = "Worldwide Food & Liquors"
        storeNameLabel!.textColor = UIColor.white
        storeNameLabel!.center.x = self.center.x
        storeNameLabel!.center.y = midY
        storeNameLabel!.font = Fonts.fontSystemMedium
        storeNameLabel!.textAlignment = .center
        storeNameLabel!.bounds.size.height = storeNameLabel!.requiredHeight()
        self.addSubview(storeNameLabel!)
        
    }
    
    // Initialize the address label for the TitleView
    private func initAddressLabel() {
        let midY: CGFloat = storeNameLabel!.by(withOffset: 0.225*self.frameH)
        let rect = CGRect(x: 0.0, y: 0.0, width: frameW, height: 20.0)
        addressLabel = UILabel(frame: rect)
        addressLabel!.text = "1234 Diversey Ave, Chicago IL 60210"
        addressLabel!.textColor = UIColor.white
        addressLabel!.center.x = self.center.x
        addressLabel!.center.y = midY
        addressLabel!.font = Fonts.fontSystemSmall
        addressLabel!.adjustsFontSizeToFitWidth = true
        addressLabel!.textAlignment = .center
        addressLabel!.bounds.size.height = addressLabel!.requiredHeight()
        self.addSubview(addressLabel!)
        
    }
    
    // Fill the corresponding views using a Detail object
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
