//
//  Helper.swift
//  Shake2.0
//
//  Created by Antonio Padilla on 5/30/19.
//  Copyright © 2019 GenOrg. All rights reserved.
//
//  Helper functions and extensions live here
//

import UIKit
import CoreLocation

// index for the current onscreen location
internal var shakeNum: Int = 0
// upper bound: number of locations 
internal var numOfLocations: Int = 0

// MARK: Helper functions and extensions

public extension UIViewController {
    func topMostViewController() -> UIViewController {
        if let presented = self.presentedViewController {
            return presented.topMostViewController()
        }
        return self
    }
}


public extension UIApplication {
    func topMostViewController() -> UIViewController? {
        return self.keyWindow?.rootViewController?.topMostViewController()
    }
}


public extension UIView {
    
    // shortcut for getting frame height of a view
    var frameH: CGFloat { return self.frame.height }
    // shortcut for getting frame width of a view
    var frameW: CGFloat { return self.frame.width }
    
    func shakeAnimation() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.1
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 15,
                                                       y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 15,
                                                     y: self.center.y))
        layer.add(animation, forKey: "position")
        
    }
    
    // simple rotation animation
    func rotationAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = CGFloat(.pi*(-0.05))
        animation.toValue = CGFloat(.pi*(0.05))
        animation.autoreverses = true
        animation.repeatCount = 7
        animation.duration = 0.075
        
        self.layer.add(animation, forKey: nil)
    }
    
    // makes a view round with a border of width "borderWidth"
    func roundView(borderWidth: CGFloat) {
        let white: UIColor =
            UIColor(red:255/255.0, green:255/255.0, blue:255/255.0, alpha:0.7)
        layer.cornerRadius = self.frame.width/2
        layer.borderWidth = borderWidth
        layer.masksToBounds = false
        layer.borderColor = white.cgColor
        clipsToBounds = true
    }
    
    // get y at the base of a view frame with an offset
    func by(withOffset: CGFloat) -> CGFloat {
        let originy = self.frame.origin.y
        let height = self.frame.height
        return originy + height + withOffset
    }
    
    // get x at the base of a view frame with an offset
    func bx(withOffset: CGFloat) -> CGFloat {
        let originx = self.frame.origin.x
        let width = self.frame.width
        return originx + width + withOffset
    }
    
    // check if a view is beneath another
    func frameIsBelow(view: UIView) -> Bool {
        return self.frame.origin.y >= view.by(withOffset: 0) &&
            view != self
    }
}


protocol DoubleConvertible {
    init(_ double: Double)
    var double: Double { get }
}
extension Double : DoubleConvertible { var double: Double { return self         } }
extension Float  : DoubleConvertible { var double: Double { return Double(self) } }
extension CGFloat: DoubleConvertible { var double: Double { return Double(self) } }

extension DoubleConvertible {
    var degreesToRadians: DoubleConvertible {
        return Self(double * .pi / 180)
    }
    var radiansToDegrees: DoubleConvertible {
        return Self(double * 180 / .pi)
    }
}

public extension CLLocation {
    // converts distance from meters to miles
    func distanceInMilesFromLocation(_ location: CLLocation) -> Double {
        let distanceMeters = self.distance(from: location)
        return distanceMeters*0.00062137
    }
}

public extension CLLocationCoordinate2D {
    // calculates angle between self and other location (bearing)
    func angleTo(destination: CLLocationCoordinate2D) -> Double {
        var x: Double = 0; var y: Double = 0
        var deg: Double = 0; var delta_long: Double
        // using the equation for bearing calculation
        delta_long = destination.longitude - self.longitude
        y = sin(delta_long) * cos(destination.latitude)
        x = cos(self.latitude) * sin(destination.latitude) -
            sin(self.latitude) * cos(destination.latitude)*cos(delta_long)
        // need result in radians
        deg = atan2(y, x).radiansToDegrees as! Double
        // necessary adjustments for negative angles
        return (deg < 0) ? -deg: 360-deg
    }
}


public extension UILabel {
    // adjusts height
    func requiredHeight() -> CGFloat {
        let frame: CGRect = CGRect(x: 0, y: 0, width: self.frame.width,
                                   height: CGFloat.greatestFiniteMagnitude)
        let new: UILabel = UILabel(frame: frame)
        new.numberOfLines = 0
        new.lineBreakMode = .byWordWrapping
        new.font = self.font
        new.text = self.text
        new.sizeToFit()
        
        return new.frame.height
    }
}
