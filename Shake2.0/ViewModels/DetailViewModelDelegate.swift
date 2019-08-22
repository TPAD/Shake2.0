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
        if initialLoad { initDetailView() }
        let detail = detailModel.placeDetails[shakeNum]
        detailView.detailViewDelegate.loadDetailView(with: detail)
        DispatchQueue.main.async { self.updateLocationUI() }
    }
    
}
