//
//  DVActionView.swift
//  Shake2.0
//
//  Created by Antonio Padilla on 8/15/19.
//  Copyright © 2019 GenOrg. All rights reserved.
//

import Foundation
import UIKit

/// DVActionView - Action View "cell" in DetailSView
///
/// - Contains an icon image and a descriptive label. It has three types and each type is only used
///   once.
///   - Phone number type to display location's phone number and allow user to call location
///   - Location type to display location's address and allow user to navigate using Google Maps
///   - Opening hour type to show today's hrs of operation and display opening hours of whole week
///   - reviews type to show amount of reviews and display reviews
///

// TODO: - auto layout and gesture for action,
//         redirect to maps
class DVActionView: UIView {
    
    weak var dADelegate: DVActionViewDelegate!

    var actionType: DVActionViewType = .location                    // just a placeholder
    var iconImageView: UIImageView = UIImageView(frame: .zero)
    var label: UILabel = UILabel(frame: .zero)
    var doAction: Bool = false
    
    var tap: UITapGestureRecognizer?
    
    let labelWidthMultiplier: CGFloat = 0.75             // relative to superview width
    let insetConstantMultiplier: CGFloat = 0.04          // relative to superview width
    let labelHeight: CGFloat = 30.0                      // arbitrary for now
    let iconImageHeightMultiplier: CGFloat = 0.70        // relative to superview height

    init(frame: CGRect, actionType: DVActionViewType) {
        super.init(frame: frame)
        self.actionType = actionType
        initIconImageView()
        initLabel()
        tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.addGestureRecognizer(tap!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        switch(actionType) {
        case .phoneNumber:
            print("tapped phone number")
            dADelegate.tryCall()
            break
        case .location:
            print("tapped location")
            dADelegate.tryGoToMaps()
            break
        case .openingHour:
            print("tapped opening hour")
            dADelegate.openingHours(shouldDisplay: !doAction)
            break
        case .reviews:
            print("tapped reviews")
            dADelegate.reviews(shouldDisplay: !doAction)
        }
        doAction = (doAction) ? false:true
    }
    
    // adds an icon image to view depending on action type. reviews type doesnt have an icon image
    private func initIconImageView() {
        var photoName: String = ""
        switch self.actionType {
        case .phoneNumber:
            photoName = "phone-icon"; break
        case .location:
            photoName = "map-marker-shake"; break
        case .openingHour:
            photoName = "clock-icon"; break
        case .reviews:
            return
        }
        iconImageView.image = UIImage(named: photoName)
        iconImageView.contentMode = .scaleAspectFill
        addSubview(iconImageView)
    }
    
    // places contraints on the image view. none if view is of type reviews
    private func activateIconImageConstraints() {
        if actionType == .reviews { return }
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        let x: CGFloat = insetConstantMultiplier * frameW
        iconImageView.heightAnchor.constraint(equalTo: self.heightAnchor,
                                              multiplier: iconImageHeightMultiplier).isActive = true
        iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor).isActive = true
        iconImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        iconImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                constant: x).isActive = true
    }
    
    private func initLabel() {
        let customFont: UIFont = UIFont(name: appFont, size: UIFont.labelFontSize)!
        label.font = UIFontMetrics.default.scaledFont(for: customFont)
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = true
        addSubview(label)
    }
    
    // places appropriate label offset depending on view type
    private func activateLabelConstraints() {
        label.translatesAutoresizingMaskIntoConstraints = false
        let tAnchor: NSLayoutAnchor =
            (actionType == .reviews) ? self.leadingAnchor:iconImageView.trailingAnchor
        let x: CGFloat = insetConstantMultiplier * frameW
        let w: CGFloat = labelWidthMultiplier * frameW
        label.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
        label.widthAnchor.constraint(equalToConstant: w).isActive = true
        label.leadingAnchor.constraint(equalTo: tAnchor, constant: x).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    // helper method that gets the address info if view is of type address
    private func getAddressComponents(from: Detail) -> String {
        let components = from.fAddress.components(separatedBy: ",")
        let max: Int = components.count
        var address: String = ""
        for i in 1...max-2 { address.append(components[i]) }
        return address
    }

    func updateView(using info: Detail) {
        switch (actionType) {
        case .phoneNumber:
            label.text = "(312) 288-4905"; break
        case .location:
            label.text = getAddressComponents(from: info); break
        case .openingHour:
            label.text = info.openingHours.text[0]; break // TODO: - today might not be 1st entry
        case .reviews:
            label.text = "\(info.reviews.count) Reviews"
            break
        }
        activateIconImageConstraints()
        activateLabelConstraints()
    }
    
}

enum DVActionViewType {
    case phoneNumber
    case location
    case openingHour
    case reviews
}
