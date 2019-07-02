//
//  TitleView.swift
//  Shake2.0
//
//  Created by Antonio Padilla on 7/2/19.
//  Copyright © 2019 GenOrg. All rights reserved.
//

import UIKit

class TitleView: UIView {
    var neighborhoodLabel: UILabel?
    var storeNameLabel: UILabel?
    var addressLabel: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initNeighborhoodLabel()
        initStoreNameLabel()
        initAddressLabel()
    }
    
     // no implementation needed but function in required
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initNeighborhoodLabel() {
        let x = 0
        let y = 0
        let w = 0
        let h = 0
        let rect = CGRect(x: x, y: y, width: w, height: h)
        neighborhoodLabel = UILabel(frame: rect)
        neighborhoodLabel!.text = "Coinflip Bitcoin ATM (Avondale)"
        self.addSubview(neighborhoodLabel!)
    }
    
    func initStoreNameLabel() {
        let x = 0
        let y = 0
        let w = 0
        let h = 0
        let rect = CGRect(x: x, y: y, width: w, height: h)
        storeNameLabel = UILabel(frame: rect)
        storeNameLabel!.text = "Worldwide Food & Liquors"
        self.addSubview(storeNameLabel!)
        
    }
    
    func initAddressLabel() {
        let x = 0
        let y = 0
        let w = 0
        let h = 0
        let rect = CGRect(x: x, y: y, width: w, height: h)
        addressLabel = UILabel(frame: rect)
        addressLabel!.text = "1234 Diversey Ave, Chicago IL 60210"
        self.addSubview(addressLabel!)
        
    }
    
    func updateViews(using detail: Detail) {
        
    }
    
}
