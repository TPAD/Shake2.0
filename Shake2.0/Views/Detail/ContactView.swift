//
//  ContactView.swift
//  Shake2.0
//
//  Created by Antonio Padilla on 7/2/19.
//  Copyright © 2019 GenOrg. All rights reserved.
//

import UIKit

// MARK: ContactView

///
/// ContactView
///
/// Composed of a phone icon, the phone number, and is 'tappable' in order to
///  allow the user to instantly call the store
///
internal class ContactView: UIView {
    
    weak var label: UILabel?
    weak var imgIcon: UIImageView?
    var tap: UITapGestureRecognizer?
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        initSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        // no implementation needed but function is required
        fatalError("init(coder:) has not been implemented")
    }
    
    // Initialize a ContactView with a label (for phone #), a phone icon,
    //  and functionality for calling the # post-tap
    private func initSubviews() {
        initImgIcon()
        initLabel()
        addTap()
    }
    
    // Initialize the ContactView's phone # label
    private func initLabel() {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
        let leadingConstant: CGFloat = self.frameW*0.085
        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(equalToConstant: 0.5*frameW),
            label.heightAnchor.constraint(equalToConstant: 0.5*(frameH)),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: self.imgIcon!.trailingAnchor, constant: leadingConstant)
        ])
        label.text = "(312) 288-4905"
        label.font = Fonts.fontSystemMedium
        label.adjustsFontSizeToFitWidth = true
        self.label = label
    }
    
    // Initialize the ContactView's icon image
    private func initImgIcon() {
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
        img.image = UIImage(named: "phone-icon")
        self.imgIcon = img
    }
    
    // Give the ContactView an IBAction for calling upon 'tapping'
    private func addTap() {
        
    }
    
}
