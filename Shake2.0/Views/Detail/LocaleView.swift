//
//  LocaleView.swift
//  Shake2.0
//
//  Created by Antonio Padilla on 7/2/19.
//  Copyright © 2019 GenOrg. All rights reserved.
//

import UIKit

// MARK: LocaleView

///
/// LocaleView
///
/// Composed of a map icon, the location's address, and is 'tappable' in order to
///  allow the user to instantly map directions to the store.
///
class LocaleView: UIView {
    
    var label: UILabel?
    weak var imgIcon: UIImageView?
    var tap: UITapGestureRecognizer?
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        initSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Initialize a LocaleView with a label (for loc. address), a map icon,
    //  and functionality for mapping directions post-tap
    private func initSubviews() {
        initImgIcon()
        initLabel()
        initTap()
    }
    
    // Initialize a label for the address of the location for LocaleView
    private func initLabel() {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
        let leadingConstant: CGFloat = self.frameW*0.085
        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(equalToConstant: 0.65*frameW),
            label.heightAnchor.constraint(equalToConstant: 0.5*(frameH)),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: self.imgIcon!.trailingAnchor, constant: leadingConstant)
            ])
        label.text = "1234 Diversey Ave, Chicago IL 60210"
        label.font = Fonts.fontSystemMedium
        label.adjustsFontSizeToFitWidth = true
        self.label = label
    }
    
    // Initialize a map icon for the Localeview
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
        img.image = UIImage(named: "map-marker-shake")
        self.imgIcon = img
    }
    
    // Give the LocaleView the functionality to map directions post-tap
    private func initTap() {
        
    }
    
    
}
