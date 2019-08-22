//
//  DetailTableViewDataSource.swift
//  Shake2.0
//
//  Created by Antonio Padilla on 8/21/19.
//  Copyright © 2019 GenOrg. All rights reserved.
//

import Foundation
import UIKit

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sH: Bool = detailView.showOpnHrs
        let sR: Bool = detailView.showReviews
        let rN: Int = (detailView.detail != nil) ? detailView.detail.reviews.count:0
        if !sH && !sR { return 6 }
        else if (sH && !sR) { return 7 }
        else if (!sH && sR) { return 6 + rN }
        else if (sH && sR) { return 7 + rN }
        // cases are exhaustive, control should not reach here
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let detailTableView: DetailTableView = tableView as! DetailTableView
        let sH: Bool = detailTableView.showOpnHrs
        //let sR: Bool = detailTableView.showReviews
        let i: Int = indexPath.row
        if i == 0 { return getHeaderCell(to: detailTableView) }
        else if i == 1 { return getImagesCell(to: detailTableView) }
        else if i == 2 { return getActionCell(to: detailTableView, type: "phone") }
        else if i == 3 { return getActionCell(to: detailTableView, type: "place") }
        else if i == 4 { return getActionCell(to: detailTableView, type: "time") }
        else if i == 5 && (!sH) { return getActionCell(to: detailTableView, type: "reviews")}
        else if i == 5 && sH { print("show opening hours") }
        return UITableViewCell()
    }
    
    private func getHeaderCell(to tableView: DetailTableView) -> UITableViewCell {
        if let headerViewCell = tableView.dequeueReusableCell(withIdentifier: "header") {
            let header = headerViewCell as! DVTHeaderCell
            header.updateView(using: tableView.detail)
            return headerViewCell
        }
        else { return UITableViewCell() }
    }
    
    // TODO: - network request for images
    private func getImagesCell(to tableView: DetailTableView) -> UITableViewCell {
        if let imagesViewCell = tableView.dequeueReusableCell(withIdentifier: "images") {
            let imagesCell = imagesViewCell as! DTVImagesCell
            imagesCell.updateView(with: tableView.detail)
            return imagesViewCell
        }
        else { return UITableViewCell() }
    }
    
    private func getActionCell(to tableView: DetailTableView, type: String) -> UITableViewCell {
        if let actionViewCell = tableView.dequeueReusableCell(withIdentifier: type) {
            let aCell = actionViewCell as! DTVActionCell
            aCell.updateView(using: tableView.detail)
            return aCell
        }
        else { return UITableViewCell() }
    }
    
    
}
