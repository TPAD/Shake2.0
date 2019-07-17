//
//  ContactView.swift
//  Shake2.0
//
//  Created by Antonio Padilla on 7/2/19.
//  Copyright © 2019 GenOrg. All rights reserved.
//

import UIKit

internal class ContactView: UIView {
    
    weak var label: UILabel?
    weak var imgIcon: UIImageView?
    var tap: UITapGestureRecognizer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        initSubviews()
    }
    
    // no implementation needed but function in required
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initSubviews() {
        initImgIcon()
        initLabel()
        addTap()
    }
    
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
        label.font = UIFont(name: "System", size: 20.0)
        label.adjustsFontSizeToFitWidth = true
        self.label = label
    }
    
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
    
    private func addTap() {
        
    }
    
}
