//
//  DTVActionCell.swift
//  Shake2.0
//
//  Created by Antonio Padilla on 8/21/19.
//  Copyright © 2019 GenOrg. All rights reserved.
//

import Foundation
import UIKit

enum ActionType {
    case phoneNumber
    case location
    case openingHour
    case reviews
}

// TODO: - evaluate the necessity of the enum identifier
class DTVActionCell: UITableViewCell {
    
    var actionType: ActionType!
    var iconImageView: UIImageView = UIImageView(frame: .zero)
    var label: UILabel = UILabel(frame: .zero)
    
    let labelWidthMultiplier: CGFloat = 0.85             // relative to superview width
    let insetConstantMultiplier: CGFloat = 0.04          // relative to superview width
    let labelHeight: CGFloat = 30.0                      // arbitrary for now
    let iconImageHeightMultiplier: CGFloat = 0.60        // relative to superview height
    
    // MARK: - Override methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        if let id = reuseIdentifier {
            if id == "phone" { actionType = .phoneNumber }
            else if  id == "place" { actionType = .location }
            else if id == "time" { actionType = .openingHour }
            else if id == "reviews" { actionType = .reviews }
        }
        configIconImageView()
        configLabel()
        activateIconImageConstraints()
        activateLabelConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // adds an icon image to view depending on action type. reviews type doesnt have an icon image
    private func configIconImageView() {
        var photoName: String = ""
        switch self.actionType {
        case .phoneNumber?:
            photoName = "phone-icon"; break
        case .location?:
            photoName = "map-marker-shake"; break
        case .openingHour?:
            photoName = "clock-icon"; break
        case .reviews?, nil:
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
    
    private func configLabel() {
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
        label.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
        label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant:x/2).isActive = true
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
        case .phoneNumber?:
            label.text = "(312) 288-4905"; break
        case .location?:
            label.text = getAddressComponents(from: info); break
        case .openingHour?:
            label.text = info.openingHours.text[0]; break // TODO: - today might not be 1st entry
        case .reviews?:
            var count: Int = 0
            if let reviews: [Detail.Reviews] = info.reviews { count = reviews.count }
            label.text = "\(count) Reviews"
            break
        case nil:
            return
        }
    }

    
}
