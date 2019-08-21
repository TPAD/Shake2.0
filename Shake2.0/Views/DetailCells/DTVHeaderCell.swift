//
//  DTVHeader.swift
//  Shake2.0
//
//  Created by Antonio Padilla on 8/21/19.
//  Copyright © 2019 GenOrg. All rights reserved.
//

import Foundation
import UIKit

class DVTHeaderCell: UITableViewCell {
    
    var nameLabel: UILabel = UILabel(frame: .zero)
    var locationLabel: UILabel = UILabel(frame: .zero)
    var addressLabel: UILabel = UILabel(frame: .zero)
    
    // label width multiplier used relative to superview
    private let wM: CGFloat = 0.9
    // label y position constant relative to label centered in superview
    private let pC: CGFloat = 10.0
    // arbitrary label height
    private let h: CGFloat = 30.0
    
    // MARK: - Override methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        for label in [nameLabel, locationLabel, addressLabel] {
            config(label)
            addSubview(label)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        activateLocationLabelLayoutConstraints()
        activateNameLabelLayoutConstraints()
        activateAddressLabelLayoutConstraints()
    }
    
    private func config(_ label: UILabel) {
        let customFont: UIFont = UIFont(name: appFont, size: UIFont.labelFontSize)!
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFontMetrics.default.scaledFont(for: customFont)
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = true
    }
    
    // MARK: - label auto layout constraints
    
    // centers nameLabel along view x-axis & pins bottomAnchor to locationLabel topAnchor w/ offset
    private func activateNameLabelLayoutConstraints() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        let yAnchor: NSLayoutAnchor = self.locationLabel.topAnchor
        let wC: NSLayoutConstraint = nameLabel.equalWidthsConstraint(to: self, m: wM)
        let hC: NSLayoutConstraint = nameLabel.heightAnchor.constraint(equalToConstant: h)
        let xC: NSLayoutConstraint = nameLabel.centerXAnchorConstraint(to: self)
        let yC: NSLayoutConstraint = nameLabel.bottomAnchor.constraint(equalTo: yAnchor, constant: -pC)
        NSLayoutConstraint.activate([wC, hC, xC, yC])
    }
    
    // centers location label along view x-axis & y-axis
    private func activateLocationLabelLayoutConstraints() {
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        let wC: NSLayoutConstraint = locationLabel.equalWidthsConstraint(to: self, m: wM)
        let hC: NSLayoutConstraint = locationLabel.heightAnchor.constraint(equalToConstant: h)
        let xC: NSLayoutConstraint = locationLabel.centerXAnchorConstraint(to: self)
        let yC: NSLayoutConstraint = locationLabel.centerYAnchorConstraint(to: self)
        NSLayoutConstraint.activate([wC, hC, xC, yC])
    }
    
    // centers addressLabel along view x-axis & pins topAnchor to locationLabel bottomAnchor w/ offset
    private func activateAddressLabelLayoutConstraints() {
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        let yAnchor: NSLayoutAnchor = self.locationLabel.bottomAnchor
        let wC: NSLayoutConstraint = addressLabel.equalWidthsConstraint(to: self, m: 1.0)
        let hC: NSLayoutConstraint = addressLabel.heightAnchor.constraint(equalToConstant: h)
        let xC: NSLayoutConstraint = addressLabel.centerXAnchorConstraint(to: self)
        let yC: NSLayoutConstraint = addressLabel.topAnchor.constraint(equalTo: yAnchor, constant: pC)
        NSLayoutConstraint.activate([wC, hC, xC, yC])
    }
    
    func updateView(using info: Detail) {
        let isOpen: Bool = info.openingHours.openNow
        let addressComponents = info.fAddress.components(separatedBy: ",")
        let max: Int = addressComponents.count
        var address: String = ""
        for i in 1...max-1 { address.append(addressComponents[i]) }
        nameLabel.text = info.name
        locationLabel.text = info.components![0].longName //TODO: - not always correct
        addressLabel.text = address
        backgroundColor = isOpen ? Colors.mediumSeaweed:Colors.mediumFirebrick
    }
}
