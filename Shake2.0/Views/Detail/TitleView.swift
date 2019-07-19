//
//  TitleView.swift
//  Shake2.0
//
//  Created by Antonio Padilla on 7/2/19.
//  Copyright © 2019 GenOrg. All rights reserved.
//

import UIKit


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
