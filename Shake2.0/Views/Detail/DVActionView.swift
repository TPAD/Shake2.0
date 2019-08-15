//
//  DVActionView.swift
//  Shake2.0
//
//  Created by Antonio Padilla on 8/15/19.
//  Copyright © 2019 GenOrg. All rights reserved.
//

import Foundation
import UIKit

class DVActionView: UIView {

    var actionType: DVActionViewType = .location                    // just a placeholder
    var iconImageView: UIImageView = UIImageView(frame: .zero)
    var label: UILabel = UILabel(frame: .zero)
    
    let labelWidthMultiplier: CGFloat = 0.65             // relative to superview width
    let insetConstantMultiplier: CGFloat = 0.055         // relative to superview width
    let labelHeight: CGFloat = 25.0                      // arbitrary for now
    let iconImageHeightMultiplier: CGFloat = 0.75        // relative to superview height
    
    init(frame: CGRect, actionType: DVActionViewType) {
        super.init(frame: frame)
        self.actionType = actionType
        initIconImageView()
        initLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initIconImageView() {
        var photoName: String = ""
        switch self.actionType {
        case .phoneNumber:
            photoName = "phone-icon"; break
        case .location:
            photoName = "map-marker-shake"; break
        case .openingHour:
            photoName = "clock-icon"; break
        }
        iconImageView.image = UIImage(named: photoName)
        iconImageView.contentMode = .center
        addSubview(iconImageView)
    }
    
    private func activateIconImageConstraints() {
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
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.text = "PLACEHOLDER"
        addSubview(label)
    }
    
    private func activateLabelConstraints() {
        label.translatesAutoresizingMaskIntoConstraints = false
        let x: CGFloat = insetConstantMultiplier * frameW
        let w: CGFloat = labelWidthMultiplier * frameW
        label.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
        label.widthAnchor.constraint(equalToConstant: w)
        label.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor,
                                       constant: x).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    func activateLayoutConstraints() {
        activateIconImageConstraints()
        activateLabelConstraints()
    }
    
}

enum DVActionViewType {
    case phoneNumber
    case location
    case openingHour
}
