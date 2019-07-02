//
//  OpeningHoursView.swift
//  Shake2.0
//
//  Created by Antonio Padilla on 7/2/19.
//  Copyright © 2019 GenOrg. All rights reserved.
//

import UIKit

class OpeningHoursView: UIView {
    
    var label: UILabel?
    var iconImg: UIImageView?
    var tap: UITapGestureRecognizer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
        
    }
    
     // no implementation needed but function in required
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubviews() {
        initLabel()
        initIconImg()
        initTap()
    }
    
    
    func initLabel() {
        
    }
    
    func initIconImg() {
        
    }
    
    func initTap() {
        
    }
    
}
