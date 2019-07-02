//
//  LocaleView.swift
//  Shake2.0
//
//  Created by Antonio Padilla on 7/2/19.
//  Copyright © 2019 GenOrg. All rights reserved.
//

import UIKit

class LocaleView: UIView {
    
    var label: UILabel?
    var imgIcon: UIImageView?
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
        initImgIcon()
        initTap()
    }
    
    func initLabel() {
        
    }
    
    func initImgIcon() {
        
    }
    
    func initTap() {
        
    }
    
    
}
