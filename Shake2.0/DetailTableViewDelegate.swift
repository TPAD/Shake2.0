//
//  DetailTableViewDelegate.swift
//  Shake2.0
//
//  Created by Antonio Padilla on 8/21/19.
//  Copyright © 2019 GenOrg. All rights reserved.
//

import Foundation
import UIKit

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let headerHeightMultiplier: CGFloat = 0.225
        let actionHeightMultiplier: CGFloat = 0.1
        let opnHrsHeightMultiplier: CGFloat = 0.25
        let reviewHeightMultiplier: CGFloat = 0.15
        let i: Int = indexPath.row
        // header and image collection
        if (i == 0 || i == 1) {
            return tableView.frameH * headerHeightMultiplier
        } else if (i == 2 || i == 3 || i == 4 || ((i == 5) && !detailView.showOpnHrs)) {
            return tableView.frameH * actionHeightMultiplier
        } else if (detailView.showOpnHrs && i == 5) {
            return tableView.frameH * opnHrsHeightMultiplier
        } else if (i == 6) {
            return tableView.frameH * reviewHeightMultiplier
        }
        // index path row cases are exhaustive
        return tableView.frameH * actionHeightMultiplier
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let i: Int = indexPath.row
        if (i == 2) { // row used for calling location
            print("tapped 2")
        } else if (i == 3) { // row potentially used to transfer navigation to map
            print("tapped 3")
        } else if (i == 4) { // row used for displaying opening hours
            print("tapped 4")
        } else if ((!detailView.showOpnHrs && i == 5) || (detailView.showOpnHrs && i == 6)) {
            // show reviews
        }
    }
    
}
