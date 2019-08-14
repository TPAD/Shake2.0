//
//  DetailScrollView.swift
//  Shake2.0
//
//  Created by Antonio Padilla on 7/23/19.
//  Copyright © 2019 GenOrg. All rights reserved.
//

import Foundation
import UIKit

class DatailScrollView: UIScrollView {
    
    var titleView: DVHeader?
    var imgsView: LocationImagesView?
    var contactView: ContactView?
    var localeView: LocaleView?
    var opnHrsView: OpeningHoursView?
    var reviewsView: ReviewsView?
    var details: Detail! {
        didSet {
            titleView!.updateViews(using: details)
            self.backgroundColor = details.openingHours.openNow ? Colors.seaweed:Colors.mediumFirebrick
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initSubviews() {
        initTitleView()
        initImgsView()
        initContactView()
        initLocaleView()
        initOpnHrsView()
        initReviewsView()
    }
    
    private func initTitleView() {
        let h = 0.225*(self.frameH)
        let rect = CGRect(x: 0.0, y: 0.0, width: frameW, height: h)
        titleView = DVHeader(frame: rect)
        self.addSubview(titleView!)
    }
    
    private func initImgsView() {
        let h: CGFloat = 0.225*(frameH)
        let y: CGFloat = titleView!.by(withOffset: 0.0)
        let rect = CGRect(x: 0.0, y: y, width: frameW, height: h)
        imgsView = LocationImagesView(frame: rect)
        self.addSubview(imgsView!)
    }
    
    private func initContactView() {
        let h: CGFloat = 0.1*(frameH)
        let y: CGFloat = imgsView!.by(withOffset: 0.0)
        let rect = CGRect(x: 0.0, y: y, width: frameW, height: h)
        contactView = ContactView(frame: rect)
        self.addSubview(contactView!)
    }
    
    private func initLocaleView() {
        let h: CGFloat = 0.1*(frameH)
        let y: CGFloat = contactView!.by(withOffset: 0.0)
        let rect = CGRect(x: 0.0, y: y, width: frameW, height: h)
        localeView = LocaleView(frame: rect)
        self.addSubview(localeView!)
        
    }
    
    private func initOpnHrsView() {
        let h: CGFloat = 0.1*(frameH)
        let y: CGFloat = localeView!.by(withOffset: 0.0)
        let rect = CGRect(x: 0.0, y: y, width: frameW, height: h)
        opnHrsView = OpeningHoursView(frame: rect)
        self.addSubview(opnHrsView!)
    }
    
    private func initReviewsView() {
        let h: CGFloat = 0.1*(frameH)
        let y: CGFloat = opnHrsView!.by(withOffset: 0.0)
        let rect = CGRect(x: 0.0, y: y, width: frameW, height: h)
        reviewsView = ReviewsView(frame: rect)
        self.addSubview(reviewsView!)
    }
    
    func expandSubviews() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, animations: {
                self.titleView!.frame.size.width = self.frameW
                self.titleView!.adjustLabelFrames(true)
                self.imgsView!.frame.size.width = self.frameW
                self.contactView!.frame.size.width = self.frameW
                self.localeView!.frame.size.width = self.frameW
                self.opnHrsView!.frame.size.width = self.frameW
                self.reviewsView!.frame.size.width = self.frameW
            })
        }
    }
    
}
