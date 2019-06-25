//
//  RightToLeft.swift
//  Shake2.0
//
//  Created by Antonio Padilla on 6/25/19.
//  Copyright © 2019 GenOrg. All rights reserved.
//

import UIKit

/**
 
 Helper functions for dealing with right-to-left languages.
 
 */
struct RightToLeft {
    static func isRightToLeft(_ view: UIView) -> Bool {
        if #available(iOS 9.0, *) {
            return UIView.userInterfaceLayoutDirection(
                for: view.semanticContentAttribute) == .rightToLeft
        } else {
            return false
        }
    }
}

