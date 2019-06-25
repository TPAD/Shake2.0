//
//  CosmosSize.swift
//  Shake2.0
//
//  Created by Antonio Padilla on 6/25/19.
//  Copyright © 2019 GenOrg. All rights reserved.
//

import UIKit

/**
 
 Helper class for calculating size for the cosmos view.
 
 */
class CosmosSize {
    /**
     
     Calculates the size of the cosmos view. It goes through all the star and text layers and makes size the view size is large enough to show all of them.
     
     */
    class func calculateSizeToFitLayers(_ layers: [CALayer]) -> CGSize {
        var size = CGSize()
        
        for layer in layers {
            if layer.frame.maxX > size.width {
                size.width = layer.frame.maxX
            }
            
            if layer.frame.maxY > size.height {
                size.height = layer.frame.maxY
            }
        }
        
        return size
    }
}
