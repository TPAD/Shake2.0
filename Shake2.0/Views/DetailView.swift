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

class DetailSView: UIScrollView {
    
    weak var dVDelegate: DetailViewDelegate!
    var headerView: DVHeader = DVHeader(frame: .zero)
    var imageCollection: DVImageCollection =
        DVImageCollection(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    var phoneNumberView: DVActionView = DVActionView(frame: .zero, actionType: .phoneNumber)
    var details: Detail! {
        didSet {
            headerView.updateViews(using: details)
            backgroundColor = details.openingHours.openNow ? Colors.seaweed:Colors.mediumFirebrick
        }
    }
    
    var upSwipe: UISwipeGestureRecognizer?
    var downSwipe: UISwipeGestureRecognizer?
    
    let headerHeightMultiplier: CGFloat = 0.225             // relative to superview height
    let actionHeightMultiplier: CGFloat = 0.1               // relative to superview height
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initSubViews() {
        initDetailHeader()
        initImageCollection()
        initPhoneNumberView()
        upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        upSwipe!.direction = .up
        downSwipe!.direction = .down
        self.addGestureRecognizer(upSwipe!)
        self.addGestureRecognizer(downSwipe!)
    }
    
    @objc func handleSwipe(_ sender: UISwipeGestureRecognizer) {
        if (sender.direction == .down) { dVDelegate.removeDetailView() }
        else if (sender.direction == .up) { dVDelegate.expandDetailView() }
    }
    
    private func initDetailHeader() {
        adjustHeaderRect()
        headerView.activateLayoutConstraint()
        self.addSubview(headerView)
    }
    
    private func adjustHeaderRect() {
        let h = headerHeightMultiplier * frameH
        let rect = CGRect(x: 0.0, y: 0.0, width: frameW, height: h)
        self.headerView.frame = rect
    }
    
    private func initImageCollection() {
        adjustCollectionRect()
        imageCollection.backgroundColor = .lightText
        self.addSubview(imageCollection)
    }
    
    private func adjustCollectionRect() {
        let h = headerHeightMultiplier * frameH
        let rect = CGRect(x: 0.0, y: h, width: frameW, height: h)
        self.imageCollection.frame = rect
    }
    
    private func initPhoneNumberView() {
        adjustPhoneNumberRect()
        phoneNumberView.activateLayoutConstraints()
        phoneNumberView.backgroundColor = .white
        self.addSubview(phoneNumberView)
    }
    
    private func adjustPhoneNumberRect() {
        let h = actionHeightMultiplier * frameH
        let y = headerHeightMultiplier * frameH * 2
        let rect = CGRect(x: 0.0, y: y, width: frameW, height: h)
        self.phoneNumberView.frame = rect
    }
    
    
    func adjustSubviews() {
        adjustHeaderRect()
        adjustCollectionRect()
        adjustPhoneNumberRect()
    }
    
}
