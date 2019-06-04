//
//  ViewController.swift
//  Shake2.0
//
//  Created by Antonio Padilla on 5/30/19.
//  Copyright © 2019 GenOrg. All rights reserved.
//

import UIKit
import CoreLocation

/// App launches to this view controller
///
class ViewController: UIViewController {
    
    @IBOutlet weak var iconImage: UIImageView!
    
    // light status bar for dark background
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - Override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.iconImage.transform = CGAffineTransform(scaleX: 2.5, y: 2.5)
            self.iconImage.rotationAnimation()
        }, completion: {(_ finished: Bool) -> Void in
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {() -> Void in
                self.iconImage.alpha = 0
            })
        })
    }
    
}

