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
    
    var detail: Detail! {
        didSet {
            print("detail set")
        }
    }
    var showOpnHrs: Bool = false
    var showReviews: Bool = false
    
    var upSwipe: UISwipeGestureRecognizer?
    var downSwipe: UISwipeGestureRecognizer?
    
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
        addGestures()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func addGestures() {
        upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        upSwipe!.direction = .up
        downSwipe!.direction = .down
        self.addGestureRecognizer(upSwipe!)
        self.addGestureRecognizer(downSwipe!)
    }
    
    // expands the detail view in the case the user swipes up, and minimizes if swipe down
    @objc func handleSwipe(_ sender: UISwipeGestureRecognizer) {
        if (sender.direction == .down) { detailViewDelegate.hideDetailView() }
        else if (sender.direction == .up) { detailViewDelegate.expandDetailView() }
    }
    
    func roundTableView() {
        let corners: UIRectCorner = [.topLeft, .topRight]
        let radius: CGFloat = 15.0
        let radii: CGSize = CGSize(width: radius, height: radius)
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: radii)
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
        layer.borderWidth = 3.0
        layer.masksToBounds = false
        layer.borderColor = Colors.mediumSeaweed.cgColor
        clipsToBounds = true
    }
    
}
