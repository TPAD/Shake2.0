//
//  Constants.swift
//  Shake2.0
//
//  Created by Antonio Padilla on 6/7/19.
//  Copyright © 2019 GenOrg. All rights reserved.
//

import Foundation
import UIKit

internal let appFont: String = "TitilliumWeb-SemiBold"
internal let locationManagerFailureMessage: String =
    """
    Shake App requires location services to be enabled for use. To enable location services
    go to Settings > Shake > Location and enable location services
    """

// MARK: AppDelegate at fingertips

internal var appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate

// MARK: Constants (Strings, Colors, etc.)

func getApiKey() -> String {
    return "AIzaSyCBckYCeXQ6j_voOmOq7UHuWqWjHUYEz7E"
}

/// Colors:
/// - mediumSeaweed = rgba(0.235, 0.702, 0.443, 0.8)
/// - seaweed = rgba(0.235, 0.702, 0.443, 1.0)
/// - mediumFirebrick = rgba(0.804, 0.137, 0.137, 0.8)
/// - jblue = rgba(0, 0.376, 0.753, 1.0)
/// - tblue = rgba(0.306, 0.576, 0.871, 1.0)
/// - phoneGreen = rgba(0.275, 0.702, 0.678, 1.0)
/// - pearlBlack = rgba(0.047, 0.071, 0.075, 1.0)
/// - CFOrange = rgba(0.976, 0.694, 0.384, 1.0) #FAB162
enum Colors {
    // CoinFlip colors
    static let pearlBlack = #colorLiteral(red:0.047, green:0.071, blue:0.075, alpha:1.0)
    static let CFOrange = #colorLiteral(red:0.976, green:0.694, blue:0.384, alpha:1.0)
    // Green for open location (used with white background bar in Location)
    static let seaweed = #colorLiteral(red:0.235, green:0.702, blue:0.443, alpha: 1.0)
    static let mediumSeaweed = #colorLiteral(red:0.235, green:0.702, blue:0.443, alpha:0.8)
    // Red for closed location (used with white background bar in Location)
    static let mediumFirebrick = #colorLiteral(red:0.804, green:0.137, blue:0.137, alpha:1.0)
    // Jack's blue
    static let jblue = #colorLiteral(red:0, green:0.376, blue:0.753, alpha:1.0)
    // Tony's blue (used in DualSwitchView)
    static let tblue = #colorLiteral(red:0.306, green:0.576, blue:0.871, alpha:1.0)
    // Green used for phone button in DualSwitchview
    static let phoneGreen = #colorLiteral(red:0.275, green:0.702, blue:0.678, alpha:1.0)
}

enum Fonts {
    // System
    static let fontSystemSmall = UIFont(name: "System", size: 17.0)
    static let fontSystemMedium = UIFont(name: "System", size: 20.0)
    static let fontSystemLarge = UIFont(name: "System", size: 23.0)
}
