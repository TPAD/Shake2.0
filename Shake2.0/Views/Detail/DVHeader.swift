//
//  TitleView.swift
//  Shake2.0
//
//  Created by Antonio Padilla on 7/2/19.
//  Copyright © 2019 GenOrg. All rights reserved.
//

import UIKit

internal class DVHeader: UIView {
    
    /// Header View Labels
    var nameLabel: UILabel = UILabel(frame: .zero)
    var locationLabel: UILabel = UILabel(frame: .zero)
    var addressLabel: UILabel = UILabel(frame: .zero)
    
    /// constants
    let labelWidthMultiplier: CGFloat = 0.9             // relative to superview
    let nameLabelMidYMultiplier: CGFloat = 0.25         // relative to superview
    let locationLabelMidYMultiplier: CGFloat = 0.175    // relative to nameLabel base y coord
    let addressLabelMidYMultiplier: CGFloat = 0.225     // relative to locationLabel base y coord
    let labelHeight: CGFloat = 25.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        headerLabelsInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func headerLabelsInit() {
        locationLabelInit()
        nameLabelInit()
        addressLabelInit()
    }
    
    private func nameLabelInit() {
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        nameLabel.adjustsFontForContentSizeCategory = true
        addSubview(nameLabel)
    }
    
    private func locationLabelInit() {
        locationLabel.textAlignment = .center
        locationLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        locationLabel.adjustsFontForContentSizeCategory = true
        addSubview(locationLabel)
    }
    
    private func addressLabelInit() {
        addressLabel.textAlignment = .center
        addressLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        addressLabel.adjustsFontForContentSizeCategory = true
        addSubview(addressLabel)
    }
    
    private func activateNameLabelLayoutConstraints() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        let w: CGFloat = frameW * labelWidthMultiplier
        let cXAnchor: NSLayoutAnchor = self.centerXAnchor
        let yAnchor: NSLayoutAnchor = self.locationLabel.topAnchor
        let wConstraint: NSLayoutConstraint = nameLabel.widthAnchor.constraint(equalToConstant: w)
        let hConstraint: NSLayoutConstraint =
            nameLabel.heightAnchor.constraint(equalToConstant: labelHeight)
        let cXConstraint: NSLayoutConstraint = nameLabel.centerXAnchor.constraint(equalTo: cXAnchor)
        let yConstraint: NSLayoutConstraint =
            nameLabel.bottomAnchor.constraint(equalTo: yAnchor, constant: -10.0)
        NSLayoutConstraint.activate([wConstraint, hConstraint, cXConstraint, yConstraint])
    }
    
    private func activateLocationLabelLayoutConstraints() {
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        let w: CGFloat = frameW * labelWidthMultiplier
        let cXAnchor: NSLayoutAnchor = self.centerXAnchor
        let cYAnchor: NSLayoutAnchor = self.centerYAnchor
        let wConstraint: NSLayoutConstraint = locationLabel.widthAnchor.constraint(equalToConstant: w)
        let hConstraint: NSLayoutConstraint =
            locationLabel.heightAnchor.constraint(equalToConstant: labelHeight)
        let cXConstraint: NSLayoutConstraint = locationLabel.centerXAnchor.constraint(equalTo: cXAnchor)
        let cYConstraint: NSLayoutConstraint = locationLabel.centerYAnchor.constraint(equalTo: cYAnchor)
        NSLayoutConstraint.activate([wConstraint, hConstraint, cXConstraint, cYConstraint])
    }
    
    private func activateAddressLabelLayoutConstraints() {
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        let w: CGFloat = frameW
        let cXAnchor: NSLayoutAnchor = self.centerXAnchor
        let yAnchor: NSLayoutAnchor = self.locationLabel.bottomAnchor
        let wConstraint: NSLayoutConstraint = addressLabel.widthAnchor.constraint(equalToConstant: w)
        let hConstraint: NSLayoutConstraint =
            addressLabel.heightAnchor.constraint(equalToConstant: labelHeight)
        let cXConstraint: NSLayoutConstraint = addressLabel.centerXAnchor.constraint(equalTo: cXAnchor)
        let yConstraint: NSLayoutConstraint =
            addressLabel.topAnchor.constraint(equalTo: yAnchor, constant: 10.0)
        NSLayoutConstraint.activate([wConstraint, hConstraint, cXConstraint, yConstraint])
    }
    
    func updateViews(using detail: Detail) {
        let isOpen: Bool = detail.openingHours.openNow
        let addressComponents = detail.fAddress.components(separatedBy: ",")
        let max: Int = addressComponents.count
        var address: String = ""
        for i in 1...max-1 { address.append(addressComponents[i]) }
        nameLabel.text = detail.name
        locationLabel.text = detail.components![0].longName
        addressLabel.text = address
        backgroundColor = isOpen ? Colors.mediumSeaweed:Colors.mediumFirebrick
        DispatchQueue.main.async {
            self.nameLabel.adjustsFontSizeToFitWidth = true
            self.locationLabel.adjustsFontSizeToFitWidth = true
            self.addressLabel.adjustsFontSizeToFitWidth = true
        }
    }
    
    func activateLayoutConstraint() {
        activateLocationLabelLayoutConstraints()
        activateNameLabelLayoutConstraints()
        activateAddressLabelLayoutConstraints()
    }
    
}
