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
    var detailView: DetailSView = DetailSView.init(frame: .zero)
    var initialDVFrame: CGRect = .zero
    var detailShouldDisplay: Bool = false {
        didSet {
            DispatchQueue.main.async {
                if self.detailShouldDisplay {
                    UIView.animate(withDuration: 0.5, animations:{
                        self.detailView.frame.origin.y = self.view.frameH - self.detailView.frameH
                        self.detailView.center.x = self.view.center.x
                    })
                } else {
                    UIView.animate(withDuration: 0.5, animations: {
                        self.removeDetailView()
                    })
                }
            }
        }
    }
    
    
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
        DispatchQueue.main.async { self.locationView.view.roundView(borderWidth: 6) }
        let tap = UITapGestureRecognizer(target: self, action: #selector(toggleDetail(_:)))
        view.addGestureRecognizer(tap)
        initDetailView()
    }
    
    func initDetailView() {
        let w = view.frameW*0.9
        let h = view.frameH*0.825
        let y = view.frameH
        let rect = CGRect(x: 0.0, y: y, width: w, height: h)
        detailView = DetailSView(frame: rect)
        detailView.center.x = view.center.x
        detailView.backgroundColor = UIColor.white
        detailView.dVDelegate = self
        initialDVFrame = CGRect(x: detailView.frame.origin.x,
                                y: detailView.frame.origin.y, width: w, height: h)
        view.addSubview(detailView)
    }
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        // requires that the view is loaded
        if (self.isViewLoaded == true && self.view.window != nil) {
            if let motion = event {
                if motion.subtype == .motionShake {
                    let max = viewModel.places.count
                    shakeNum = (shakeNum < max && max != 0) ? (shakeNum + 1): 0
                    DispatchQueue.main.async {
                        self.locationView.shakeAnimation()
                        self.runNextImageSearch()
                        self.runNextDetailSearch()
                        self.updateLocationUI()
                    }
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
    
    @objc func toggleDetail(_ sender: UITapGestureRecognizer) {
        if viewModel.places == nil { return }
        if viewModel.places.count == 0 {
            // TODO: - detail should not be displayed if there are no locations in range
            return
        }
        if detailShouldDisplay == false {
            let bounds: CGRect = locationView!.frame
            let pointTapped: CGPoint = sender.location(in: view)
            if bounds.contains(pointTapped) {
                detailShouldDisplay = !detailShouldDisplay
            }
        }
    }
}




// MARK: - delegate funtions
protocol ViewModelDelegate: class {
    func willLoadData()
    func runNextDetailSearch()
    func runNextImageSearch()
    func setLocationImage(to image: UIImage)
    func updateLocationUI()
}

protocol DetailViewModelDelegate: class {
    func detailSearchSucceded()
    func hideDV()
    func expandDV()
}

protocol DetailViewDelegate: class {
    func removeDetailView()
    func expandDetailView()
    func loadDetailView(with info: Detail)
}

extension ViewController: ViewModelDelegate {
    
    func willLoadData() {
        if initialLoad {
            activitySetup()
            indicator.startAnimating()
        }
    }
    
    func runNextDetailSearch() {
        let places = viewModel.places!
        // check if valid indices
        if places.count > 0 {
            detailModel.getDetail(from: places, at: shakeNum)
        }
    }
    
    func runNextImageSearch() {
        if let info = viewModel.places[shakeNum].photos {
            if info.count != 0 {
                let photoRef = info[0].photoReference
                let width = Float(locationView!.frameW)
                viewModel.getImage(from: photoRef, with: width)
            } else {    // TODO: - change deafult image in case where location has no images
                if let warrington = UIImage(named: "warrington") {
                    setLocationImage(to: warrington)
                }
                self.locationView.locationImage.backgroundColor = Colors.pearlBlack
            }
        } else {
            print("no photos")
            if let warrington = UIImage(named: "warrington") {
                setLocationImage(to: warrington)
            }
            self.locationView.locationImage.backgroundColor = Colors.pearlBlack
        }
    }
    
    // called by viewModel in getImage response handler
    func setLocationImage(to image: UIImage) {
        DispatchQueue.main.async {
            self.locationView!.locationImage.image = image
            self.indicator.stopAnimating()
            if self.initialLoad {
                UIView.animate(withDuration: 0.5, animations: {
                    self.locationView.alpha = 1
                }) { (_) in
                    self.initialLoad = false
                }
            }
        }
    }
    
    func updateLocationUI() {
        let location = viewModel.places[shakeNum]
        let manager = appDelegate.locationManager
        UIView.animate(withDuration: 0.5, animations: { self.saveButton.alpha = 1.0 })
        viewModel.configureLocationName(locationNameLabel, using: location)
        viewModel.configureDistance(distanceLabel, using: location, manager)
        viewModel.configure(locationBubble: locationView, using: location)
    }
    
}

extension ViewController: DetailViewModelDelegate {
    
    // TODO: - animation for when view model is waiting for detail query response
    func detailSearchSucceded() {
        // TODO: - send view updates!
        let detail = detailModel.placeDetails[shakeNum]
        self.detailView.dVDelegate.loadDetailView(with: detail)
        DispatchQueue.main.async { self.updateLocationUI() }
    }
    
    func hideDV() {
        self.detailShouldDisplay = false
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, animations: {
                self.detailView.frame = self.initialDVFrame
                self.detailView.adjustSubviews()
            })
        }
    }
    
    func expandDV() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, animations: {
                self.detailView.frame = self.view.frame
                self.detailView.adjustSubviews()
            })
        }
    }
    
}

extension ViewController: DetailViewDelegate {
    
    func removeDetailView() {
        self.detailModel.hideDetailView()
    }
    
    // expands the detail view to fit screen
    func expandDetailView() {
        self.detailModel.expandDetailView()
    }
    
    func loadDetailView(with info: Detail) {
        self.detailView.details = info
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
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.25, animations: { self.hideDevaultViewInterface() })
            { (_) in
                UIView.animate(withDuration: 0.5, animations: { self.initUserCancelledLabel() })
            }
        }
    }
    
}
