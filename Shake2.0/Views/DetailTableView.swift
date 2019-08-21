//
//  DetailTableView.swift
//  Shake2.0
//
//  Created by Antonio Padilla on 8/21/19.
//  Copyright © 2019 GenOrg. All rights reserved.
//

import Foundation
import UIKit

class DetailTableView: UITableView {
    
    weak var detailViewDelegate: DetailViewDelegate!
    
    var detail: Detail!
    var showOpnHrs: Bool = false
    var showReviews: Bool = false
    
    private let cellTypes =
        [DVTHeaderCell.self, DTVImagesCell.self, DTVActionCell.self, DTVActionCell.self,
         DTVActionCell.self, DTVActionCell.self]
    private let cellNames: [String] = ["header", "images", "phone", "place", "time", "reviews"]
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        tableHeaderView = UIView(frame: .zero)
        tableFooterView = UIView(frame: .zero)
        isScrollEnabled = false
        alwaysBounceVertical = false
        for (index, cell) in cellTypes.enumerated() {
            register(cell, forCellReuseIdentifier: cellNames[index])
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
