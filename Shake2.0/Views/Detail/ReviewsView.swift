//
//  ReviewsView.swift
//  Shake2.0
//
//  Created by Antonio Padilla on 7/2/19.
//  Copyright © 2019 GenOrg. All rights reserved.
//

import UIKit

class ReviewsView: UIView {
    
    var label: UILabel = UILabel()
    var tap: UITapGestureRecognizer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        initViews()
    }
    
     // no implementation needed but function in required
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initViews() {
        initLabel()
        initTap()
    }
    
    private func initLabel() {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
        let leadingConstant: CGFloat = self.frameW*0.085
        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(equalToConstant: 0.65*frameW),
            label.heightAnchor.constraint(equalToConstant: 0.5*(frameH)),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: leadingConstant)
            ])
        label.text = "Reviews"
        label.font = UIFont(name: "System", size: 20.0)
        label.adjustsFontSizeToFitWidth = true
        self.label = label
    }
    
    private func initTap() {
        
    }
    
    
}
