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
    
    var scrollView: DatailScrollView!
    weak var delegate: DetailViewDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initScrollView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initScrollView()
    }
    
    func initScrollView() {
        let scrollView: DatailScrollView = DatailScrollView(frame: self.bounds)
        let dHeight: CGFloat = self.frameH*1.01
        scrollView.contentSize = CGSize(width: self.frameW, height: dHeight)
        self.scrollView = scrollView
        self.addSubview(scrollView)
        self.scrollView.delegate = self
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
    }
    
    func expandScrollView() {
        scrollView!.frame.origin.y = self.frame.origin.y
        scrollView!.frame.size.width = self.frameW
        scrollView!.frame.size.height = self.frameH
        scrollView!.frame.origin.x = self.frame.origin.x
        let dHeight: CGFloat = self.frameH*1.01
        scrollView!.contentSize = CGSize(width: self.frameW, height: dHeight)
        scrollView!.expandSubviews()
    }
    
    //MARK: - scrollview delgate functions
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // user will have to scroll down about a third of the view height to dismiss detail view
        let downScrollThreshold: CGFloat = -(0.3)*frame.height
        if scrollView.contentOffset.y < downScrollThreshold {
            delegate.removeDetailView()
        // user scrolls upward and the detail view will expand
        } else if scrollView.contentOffset.y > 0 {
            delegate.expandDetailView()
        }
    }
    
}
