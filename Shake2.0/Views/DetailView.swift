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

class DetailView: UIView, UIScrollViewDelegate {
    
    var titleView: TitleView?
    var imgsView: LocationImagesView?
    var contactView: ContactView?
    var localeView: LocaleView?
    var opnHrsView: OpeningHoursView?
    var reviewsView: ReviewsView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initSubviews() {
        initTitleView()
        initImgsView()
        initContactView()
        initLocaleView()
        initOpnHrsView()
        initReviewsView()
    }
    
    func initTitleView() {
        
    }
    
    func initImgsView() {
        
    }
    
    func initContactView() {
        
    }
    
    func initLocaleView() {
        
    }
    
    func initOpnHrsView() {
        
    }
    
    func initReviewsView() {
        
    }
    
}
