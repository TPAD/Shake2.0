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


/// DetailSView - Detail View for Location details as a scroll view
///
/// - contains a header, a collection of images, and "cells" for phone number, address, open hours,
///   and reviews. "Action" cells will reveal cells with additional information or redirect the user
///   out of app in the case the user wants to call the store location or navigate using Google Maps
///

// TODO: - add gestures for the action cells
//       - auto layout constaints so manual placement of cells becomes unnecessary, but
//         FOR NOW redrawing the dimenstions of each cell might help smooth the animation
class DetailSView: UIScrollView, DVActionViewDelegate {
    
    weak var dVDelegate: DetailViewDelegate!
    
    var headerView: DVHeader = DVHeader(frame: .zero)
    var imageCollection: DVImageCollection =
        DVImageCollection(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    var phoneNumberView: DVActionView = DVActionView(frame: .zero, actionType: .phoneNumber)
    var addressView: DVActionView = DVActionView(frame: .zero, actionType: .location)
    var openHrsView: DVActionView = DVActionView(frame: .zero, actionType: .openingHour)
    var reviewsView: DVActionView = DVActionView(frame: .zero, actionType: .reviews)
    var moreHrsView: DVOpeningHoursView = DVOpeningHoursView(frame: .zero)
    
    var showOpnHrs: Bool = false
    var showReviews: Bool  = false

    var details: Detail! {      // set in view controller right after this view is initialized
        didSet {
            headerView.updateView(using: details)
            phoneNumberView.updateView(using: details)
            addressView.updateView(using: details)
            openHrsView.updateView(using: details)
            reviewsView.updateView(using: details)
            moreHrsView.updateView(using: details)
            backgroundColor = details.openingHours.openNow ? Colors.seaweed:Colors.mediumFirebrick
        }
    }
    
    var upSwipe: UISwipeGestureRecognizer?
    var downSwipe: UISwipeGestureRecognizer?
    
    let headerHeightMultiplier: CGFloat = 0.225             // relative to superview height
    let actionHeightMultiplier: CGFloat = 0.1               // relative to superview height
    let opnHrsHeightMultiplier: CGFloat = 0.25               // relative to superview height
    
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
        initAddressView()
        initOpnHrsView()
        initReviewsView()
        initMoreHrsView()
        self.contentSize.height = getContentHeight()
        upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        upSwipe!.direction = .up
        downSwipe!.direction = .down
        self.addGestureRecognizer(upSwipe!)
        self.addGestureRecognizer(downSwipe!)
    }
    
    // expands the detail view in the case the user swipes up, and minimizes if swipe down
    @objc func handleSwipe(_ sender: UISwipeGestureRecognizer) {
        if (sender.direction == .down) { dVDelegate.removeDetailView() }
        else if (sender.direction == .up) { dVDelegate.expandDetailView() }
    }
    
    private func initDetailHeader() {
        adjustHeaderRect()
        self.addSubview(headerView)
    }
    
    // places the header view at the top of the view. delegate handles readjusting the frame rect
    private func adjustHeaderRect() {
        let h: CGFloat = headerHeightMultiplier * frameH
        let rect = CGRect(x: 0.0, y: 0.0, width: frameW, height: h)
        self.headerView.frame = rect
    }
    
    private func initImageCollection() {
        adjustCollectionRect()
        imageCollection.backgroundColor = .lightText
        self.addSubview(imageCollection)
    }
    
    // places the image collection underneath the header. delegate handles readjusting the frame rect
    private func adjustCollectionRect() {
        let h: CGFloat = headerHeightMultiplier * frameH
        let rect = CGRect(x: 0.0, y: h, width: frameW, height: h)
        self.imageCollection.frame = rect
    }
    
    private func initPhoneNumberView() {
        adjustPhoneNumberRect()
        phoneNumberView.dADelegate = self
        self.addSubview(phoneNumberView)
        phoneNumberView.backgroundColor = .white
    }
    
    // places the phone num view underneath the image collection. delegate method handles readjusting the frame rect
    private func adjustPhoneNumberRect() {
        let h: CGFloat = actionHeightMultiplier * frameH
        let y: CGFloat = headerHeightMultiplier * frameH * 2
        let rect: CGRect = CGRect(x: 0.0, y: y, width: frameW, height: h)
        self.phoneNumberView.frame = rect
    }
    
    private func initAddressView() {
        adjustAddressRect()
        addressView.dADelegate = self
        self.addSubview(addressView)
        addressView.backgroundColor = .white
    }
    
    // places the address view underneath the phone num view. delegate method handles readjusting the frame rect
    private func adjustAddressRect() {
        let h: CGFloat = actionHeightMultiplier * frameH
        let y: CGFloat = (headerHeightMultiplier * frameH * 2) + h
        let rect: CGRect = CGRect(x: 0.0, y: y, width: frameW, height: h)
        self.addressView.frame = rect
    }
    
    private func initOpnHrsView() {
        adjustOpnHrsRect()
        openHrsView.dADelegate = self
        self.addSubview(openHrsView)
        openHrsView.backgroundColor = .white
    }
    
    // places the opening hrs view underneath the address view. delegate method handles readjusting the frame rect
    private func adjustOpnHrsRect() {
        let h: CGFloat = actionHeightMultiplier * frameH
        let y: CGFloat = (headerHeightMultiplier * frameH * 2) + (2 * h)
        let rect: CGRect = CGRect(x: 0.0, y: y, width: frameW, height: h)
        self.openHrsView.frame = rect
    }
    
    private func initMoreHrsView() {
        adjustMoreHrsRect()
        moreHrsView.backgroundColor = .lightText
        self.addSubview(moreHrsView)
    }
    
    private func adjustMoreHrsRect() {
        let h: CGFloat = (showOpnHrs) ? (opnHrsHeightMultiplier * frameH):0.0
        let y: CGFloat = frameH * ((2 * headerHeightMultiplier) + (3 * actionHeightMultiplier))
        let rect: CGRect = CGRect(x: 0.0, y: y, width: frameW, height: h)
        moreHrsView.frame = rect
        moreHrsView.alpha = (showOpnHrs) ? 1.0:0.0
    }
    
    
    private func initReviewsView() {
        adjustReviewsRect()
        reviewsView.dADelegate = self
        self.addSubview(reviewsView)
        reviewsView.backgroundColor = .white
    }
    
    // places the reviews view underneath the opn hrs view. delegate method handles readjusting the frame rect
    private func adjustReviewsRect() {
        let h: CGFloat = actionHeightMultiplier * frameH
        let y: CGFloat = (!showOpnHrs) ? (headerHeightMultiplier * frameH * 2) + (3 * h):
        (headerHeightMultiplier * frameH * 2) + (3 * h) + (opnHrsHeightMultiplier*frameH)
        let rect: CGRect = CGRect(x: 0.0, y: y, width: frameW, height: h)
        self.reviewsView.frame = rect
    }
    
    func getContentHeight() -> CGFloat{
        var result: CGFloat = 0.0
        for sv in self.subviews {
            if (sv.isKind(of: DVHeader.self) || sv.isKind(of: DVImageCollection.self) ||
                sv.isKind(of: DVActionView.self) || sv.isKind(of: DVOpeningHoursView.self)) {
                result += sv.frameH
            }
        }
        return result
    }
    
    // MARK: - delegate methods
    
    // adjusts subviews initial frame rect and handles resizing from the delegate method
    func adjustSubviews() {
        adjustHeaderRect()
        adjustCollectionRect()
        adjustPhoneNumberRect()
        adjustAddressRect()
        adjustOpnHrsRect()
        adjustReviewsRect()
        adjustMoreHrsRect()
    }
    
    // allows user to call the location store's phone number
    func tryCall() {
        if let vc = UIApplication.shared.topMostViewController() as? ViewController {
            showTryCallRedirectController(from: vc, num: details.fPNumber, name: details.name)
        } else {
            print("invalid topmost vc")
        }
    }
    
    // allows the user to navigate google or apple maps
    func tryGoToMaps() {
        if let vc = UIApplication.shared.topMostViewController() as? ViewController {
            showTryGoogleMapsController(from: vc, name: details.name)
        }
    }
    
    func openingHours(shouldDisplay: Bool) {
        showOpnHrs = (shouldDisplay) ? true:false
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, animations: {
                self.adjustMoreHrsRect()
                self.adjustReviewsRect()
            }) { _ in
                self.contentSize.height = self.getContentHeight()
            }
        }
    }
    
    func reviews(shouldDisplay: Bool) {
        
    }
    
}

protocol DVActionViewDelegate: class {
    
    func tryCall()
    func tryGoToMaps()
    func openingHours(shouldDisplay: Bool)
    func reviews(shouldDisplay: Bool)
    
}
