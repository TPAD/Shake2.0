//
//  TitleView.swift
//  Shake2.0
//
//  Created by Antonio Padilla on 7/2/19.
//  Copyright © 2019 GenOrg. All rights reserved.
//

import UIKit

/// DVHeader - header (topmost) view on DetailSView
///
/// - contains three labels for location name, location store, and location address
///

// TODO: - make sure label text size apppropriately across devices; might have to set no. of lines to 0
//       - change label heights and y position constants according to device screen size
internal class DVHeader: UIView {
    
    /// Header View Labels
    var nameLabel: UILabel = UILabel(frame: .zero)
    var locationLabel: UILabel = UILabel(frame: .zero)
    var addressLabel: UILabel = UILabel(frame: .zero)
    
    // label width multiplier used relative to superview
    private let wM: CGFloat = 0.9
    // label y position constant relative to label centered in superview
    private let pC: CGFloat = 10.0
    // arbitrary label height
    private let h: CGFloat = 30.0
    
    // MARK: - initializer for DVHeader and its subviews
    override init(frame: CGRect) {
        super.init(frame: frame)
        for label in [nameLabel, locationLabel, addressLabel] {
            config(label)
            addSubview(label)
        }
        activateLocationLabelLayoutConstraints()
        activateNameLabelLayoutConstraints()
        activateAddressLabelLayoutConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - label configuration
    private func config(_ label: UILabel) {
        let customFont: UIFont = UIFont(name: appFont, size: UIFont.labelFontSize)!
        label.textAlignment = .center
        label.font = UIFontMetrics.default.scaledFont(for: customFont)
        label.textColor = .white
        label.textAlignment = .center
        label.adjustsFontForContentSizeCategory = true
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
    
    // MARK: - view updates
    
    // populates the labels with the respective location detail
    func updateView(using info: Detail) {
        let isOpen: Bool = info.openingHours.openNow
        let addressComponents = info.fAddress.components(separatedBy: ",")
        let max: Int = addressComponents.count
        var address: String = ""
        for i in 1...max-1 { address.append(addressComponents[i]) }
        nameLabel.text = info.name
        locationLabel.text = info.components![0].longName
        addressLabel.text = address
        backgroundColor = isOpen ? Colors.mediumSeaweed:Colors.mediumFirebrick
    }

}
