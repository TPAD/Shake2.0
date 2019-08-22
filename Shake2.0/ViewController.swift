//
//  ViewController.swift
//  Shake2.0
//
//  Created by Antonio Padilla on 5/30/19.
//  Copyright © 2019 GenOrg. All rights reserved.
//

import UIKit
import CoreLocation

///
/// App launches to this view controller
///
// TODO: - add control flow and UI updates for when the user connects/disconnects from network.
//         add control flow and UI updates for when the user is not within range of any coinflip atms
//         maybe let the user know where the nearest coinflip atms are.
//         fix bug where the detail model or view model fail to retrieve every piece of info.
//         fix bug: shakeNum index out of range error
//         remove the bottom border fromm the detail view
class ViewController: UIViewController {
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var locationView: LocationView!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    var userCanceledMessageLabel: UILabel?

    var showHiddenHoursView = false
    var showHiddenReviewsView = false
    //var statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
    
    
    var viewModel: LocationViewModel = LocationViewModel()
    var detailModel: DetailViewModel = DetailViewModel()
    var indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .gray)
    var userCoord: CLLocationCoordinate2D?
    var initialLoad: Bool = true
    var detailView: DetailTableView = DetailTableView(frame: .zero, style: .plain)
    var initialDVFrame: CGRect = .zero
    var detailShouldDisplay: Bool = false
    
    // light status bar for dark background
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - Override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        iconImage.rotationAnimation()
        viewModel.delegate = self
        detailModel.delegate = self
        locationView.delegate = self
        DispatchQueue.main.async { self.locationView.view.roundView(borderWidth: 6) }
    }
    
    func initDetailView() {
        let w = view.frameW*0.9
        let h = view.frameH*0.825
        let y = view.frameH
        let rect = CGRect(x: 0.0, y: y, width: w, height: h)
        detailView = DetailTableView(frame: rect, style: .plain)
        detailView.center.x = view.center.x
        detailView.backgroundColor = UIColor.white
        detailView.delegate = self
        detailView.dataSource = self
        detailView.detailViewDelegate = self
        detailView.roundTableView()
        initialDVFrame =
            CGRect(x: detailView.frame.origin.x, y: detailView.frame.origin.y, width: w, height: h)
        view.addSubview(detailView)
    }
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        // requires that the view is loaded
        if (self.isViewLoaded == true && self.view.window != nil) {
            if let motion = event {
                if motion.subtype == .motionShake {
                    let max = viewModel.places.count - 1
                    shakeNum = (shakeNum < max && max != 0) ? (shakeNum + 1): 0
                    self.locationView.shakeAnimation()
                    self.runNextImageSearch()
                    self.runNextDetailSearch()
                    self.updateLocationUI()
                }
            }
        }
    }
    
    func activitySetup() {
        let x = iconImage.bx(withOffset: -iconImage.frameW)
        let y = iconImage.by(withOffset: -iconImage.frameH/4)
        let w = iconImage.frameW
        let h = iconImage.frameH
        indicator.color = Colors.CFOrange
        view.addSubview(self.indicator)
        indicator.frame = CGRect(x: x, y: y, width: w, height: h)
        indicator.hidesWhenStopped = true
    }
    
    func showDetailView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.detailView.frame.origin.y = self.view.frameH - self.detailView.frameH
            self.detailView.center.x = self.view.center.x
        })
    }
    
}


//MARK: - display messages for user flow in case of location services denied or failed
extension ViewController {
    
    private func initFailureLabel() -> UILabel {
        let label = UILabel(frame: .zero)
        // TODO: - will have to check if this font is nil
        let customFont: UIFont = UIFont(name: appFont, size: UIFont.labelFontSize)!
        label.textAlignment = .center
        label.font = UIFontMetrics.default.scaledFont(for: customFont)
        label.adjustsFontForContentSizeCategory = true
        return label
    }
    
    private func initUserCancelledLabel() {
        userCanceledMessageLabel = initFailureLabel()
        self.view.addSubview(userCanceledMessageLabel!)
        userCanceledMessageLabel!.translatesAutoresizingMaskIntoConstraints = false
        userCanceledMessageLabel!.numberOfLines = 0
        userCanceledMessageLabel!.lineBreakMode = .byWordWrapping
        userCanceledMessageLabel!.text = locationManagerFailureMessage
        userCanceledMessageLabel!.textColor = .white
        userCanceledMessageLabel!.adjustsFontSizeToFitWidth = false
        self.activateCancelLabelConstraints()
    }
    
    private func activateCancelLabelConstraints() {
        let wM: CGFloat = 0.9
        let wH: CGFloat = 0.4
        let l: UILabel = userCanceledMessageLabel!
        let wC: NSLayoutConstraint = l.equalWidthsConstraint(to: self.view, m: wM)
        let hC: NSLayoutConstraint = l.equalHeightsConstraint(to: self.view, m: wH)
        let cX: NSLayoutConstraint = l.centerXAnchorConstraint(to: self.view)
        let cY: NSLayoutConstraint = l.centerYAnchorConstraint(to: self.view)
        NSLayoutConstraint.activate([wC, hC, cX, cY])
    }
    
    private func hideDevaultViewInterface() {
        self.iconImage.alpha = 0
        self.locationView.alpha = 0
        self.locationNameLabel.alpha = 0
        self.distanceLabel.alpha = 0
        self.saveButton.alpha = 0
    }
    
    func animateUserCancelledLabel() {
        UIView.animate(withDuration: 0.25, animations: { self.hideDevaultViewInterface() })
        { (_) in
            UIView.animate(withDuration: 0.5, animations: { self.initUserCancelledLabel() })
        }
    }
    
}

