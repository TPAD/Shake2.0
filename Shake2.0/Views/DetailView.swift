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


//
//  structure containing the information for the detail view
//
struct DetailInfo {
//
//    var name: String?
//    var price: Int?
//    var isOpen: Bool?
//    var image: UIImage?
//    var coordinates: (Double, Double)
//    var phone: String?
//    var formatAddress: String?
//    var reviews: NSArray?
//    var weeklyHours: Array<String>?
//    var openPeriods: Array<[String:AnyObject]>?
//    var types: Array<String>?
//    var mainType: String?
//    var website: String?
//
//    init(data: [String: AnyObject?]) {
//        isOpen = false
//        name = getName(data)
//        price = getPrice(data)
//        image = getImage(data)
//    }
//

}
