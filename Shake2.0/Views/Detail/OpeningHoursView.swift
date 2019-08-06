//
//  OpeningHoursView.swift
//  Shake2.0
//
//  Created by Antonio Padilla on 7/2/19.
//  Copyright © 2019 GenOrg. All rights reserved.
//

import UIKit

// MARK: OpeningHoursView

///
/// OpeningHoursView
///
/// Composed of a clock icon, the location's hours of operation, and is 'tappable' in
/// order to allow the user to view the rest of the week's hours.
///
class OpeningHoursView: UIView {
    
    weak var label: UILabel?
    weak var iconImg: UIImageView?
    var tap: UITapGestureRecognizer?
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        initSubviews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        // no implementation needed but function in required
        fatalError("init(coder:) has not been implemented")
    }
    
    // Initialize the OpeningHoursView with an icon, a label (for today's hours),
    //  and the functionality to expand the label post-tap
    private func initSubviews() {
        initIconImg()
        initLabel()
        initTap()
    }
    
    // Initialize the label for OpeningHoursView
    private func initLabel() {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
        let leadingConstant: CGFloat = self.frameW*0.085
        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(equalToConstant: 0.65*frameW),
            label.heightAnchor.constraint(equalToConstant: 0.5*(frameH)),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: self.iconImg!.trailingAnchor, constant: leadingConstant)
            ])
        label.text = "Tuesday: 9:00am - 9:00pm"
        label.font = Fonts.fontSystemMedium
        label.adjustsFontSizeToFitWidth = true
        self.label = label
    }
    
    // Initialize the clock icon for OpeningHoursView
    private func initIconImg() {
        let img = UIImageView(frame: .zero)
        img.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(img)
        let leadingConstant: CGFloat = self.frameW*0.05
        NSLayoutConstraint.activate([
            img.widthAnchor.constraint(equalToConstant: 0.65*(frameH)),
            img.widthAnchor.constraint(equalTo: img.heightAnchor),
            img.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            img.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: leadingConstant)
            ])
        img.image = UIImage(named: "clock-icon")
        self.iconImg = img
    }
    
    // Give the OpeningHoursView the functionality to expand and contract
    //  upon tapping on the label (to see hours for entire week)
    private func initTap() {
        
    }
    
}
