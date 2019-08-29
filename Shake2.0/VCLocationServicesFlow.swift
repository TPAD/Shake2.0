//
//  VCLocationServicesFlow.swift
//  Shake2.0
//
//  Created by Antonio Padilla on 8/22/19.
//  Copyright © 2019 GenOrg. All rights reserved.
//

import Foundation
import UIKit

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
