//
//  ReviewsView.swift
//  Shake2.0
//
//  Created by Antonio Padilla on 7/2/19.
//  Copyright © 2019 GenOrg. All rights reserved.
//

import UIKit

// MARK: ReviewsView

///
/// ReviewsView
///
/// Composed of a label 'Reviews', and is 'tappable' in order to allow the user to
///  view the available Google reviews for this ATM
///
class ReviewsView: UIView {
    
    var label: UILabel = UILabel()
    var tap: UITapGestureRecognizer?
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        initViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        // no implementation needed but function in required
        fatalError("init(coder:) has not been implemented")
    }
    
    // Initialize a ReviewsView with a label and the functionality to expand post-tap
    private func initViews() {
        initLabel()
        initTap()
    }
    
    // Initialize the label for ReviewView
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
        label.font = Fonts.fontSystemMedium
        label.adjustsFontSizeToFitWidth = true
        self.label = label
    }
    
    // Give the ReviewsView the functionality to expand and show available reviews
    //  after the user taps 'Reviews'
    private func initTap() {
        
    }
    
    
}
