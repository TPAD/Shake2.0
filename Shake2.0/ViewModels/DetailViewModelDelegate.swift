//
//  DetailViewModelDelegate.swift
//  Shake2.0
//
//  Created by Antonio Padilla on 8/22/19.
//  Copyright © 2019 GenOrg. All rights reserved.
//

import Foundation
import UIKit

protocol DetailViewModelDelegate: class {
    func detailSearchSucceded()
}

extension ViewController: DetailViewModelDelegate {
    
    // TODO: - animation for when view model is waiting for detail query response
    func detailSearchSucceded() {
        // TODO: - send view updates!
        DispatchQueue.main.async {
            if self.initialLoad { self.initDetailView() }
            let detail = self.detailModel.placeDetails[shakeNum]
            self.detailView.detailViewDelegate.loadDetailView(with: detail)
            self.updateLocationUI()
        }
    }
    
}
