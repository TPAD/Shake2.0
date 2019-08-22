//
//  DetailVIewDelegate.swift
//  Shake2.0
//
//  Created by Antonio Padilla on 8/22/19.
//  Copyright © 2019 GenOrg. All rights reserved.
//

import Foundation
import UIKit

protocol DetailViewDelegate: class {
    func loadDetailView(with info: Detail)
    func expandDetailView()
    func hideDetailView()
}

extension ViewController: DetailViewDelegate {
    
    func loadDetailView(with info: Detail) {
        self.detailView.detail = info
    }
    
    func expandDetailView() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, animations: {
                self.detailView.frame = self.view.frame
                self.detailView.layoutIfNeeded()
                self.detailView.roundTableView()
            })
        }
    }
    
    func hideDetailView() {
        detailShouldDisplay = false
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, animations: {
                self.detailView.frame.origin.y = self.view.frame.height
                self.detailView.roundTableView()
            }) { _ in
                self.detailView.frame = self.initialDVFrame
                self.detailView.roundTableView()
            }
        }
    }
    
}
