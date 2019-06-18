//
//  DetailView.swift
//  Shake2.0
//
//  Created by Antonio Padilla on 5/30/19.
//  Copyright © 2019 GenOrg. All rights reserved.
//
//  DetailView contains details on the location such as reviews, hours of operation, contact info etc.
//

import Foundation
import UIKit

class DetailView: UIView {
    
    var view: UIView!
    
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
//        return UINib(nibName: "DetailView", bundle: nil)
//            .instantiate(withOwner: self, options: nil)[0] as! UIView
//    }
    
}
