//
//  DVOpeningHoursView.swift
//  Shake2.0
//
//  Created by Antonio Padilla on 8/19/19.
//  Copyright © 2019 GenOrg. All rights reserved.
//

import Foundation
import UIKit

/// DVOpeningHoursView - View that displays a location's weekly opening hours
///
/// - contains a label which contains the locations opening hours
///

class DVOpeningHoursView: UIView {
    
    var label: UILabel = UILabel(frame: .zero)
    
    let labelWMultiplier: CGFloat = 0.75
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        config(label)
        activateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func config(_ label: UILabel) {
        let customFont: UIFont = UIFont(name: appFont, size: UIFont.labelFontSize)!
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFontMetrics.default.scaledFont(for: customFont)
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = true
        self.addSubview(label)
    }
    
    private func activateConstraints() {
        label.translatesAutoresizingMaskIntoConstraints = false
        let m = labelWMultiplier
        let wC: NSLayoutConstraint = label.equalWidthsConstraint(to: self, m: m)
        let hC: NSLayoutConstraint = label.equalHeightsConstraint(to: self, m: 1.0)
        let xC: NSLayoutConstraint = label.centerXAnchorConstraint(to: self)
        let yC: NSLayoutConstraint = label.centerYAnchorConstraint(to: self)
        NSLayoutConstraint.activate([wC, hC, xC, yC])
    }
    
    func updateView(using info: Detail) {
        var text: String = ""
        for hrs in info.openingHours.text {
            text.append(hrs)
            if hrs != info.openingHours.text.last { text.append("\n") }
        }
        label.text = text
    }
    
}
