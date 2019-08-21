//
//  DTVImagesCell.swift
//  Shake2.0
//
//  Created by Antonio Padilla on 8/21/19.
//  Copyright © 2019 GenOrg. All rights reserved.
//

import Foundation
import UIKit

class DTVImagesCell: UITableViewCell {
    
    var view: UICollectionView!
    
    // MARK: - Override methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let layout: UICollectionViewLayout = UICollectionViewFlowLayout()
        view = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        view.backgroundColor = .lightText
        addSubview(view)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        view.frame = bounds
    }
    
    func updateView(with info: Detail) {
        backgroundColor = (info.openingHours.openNow) ? Colors.mediumSeaweed:Colors.mediumFirebrick
    }
    
}
