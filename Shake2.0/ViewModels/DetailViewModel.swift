//
//  \.swift
//  Shake2.0
//
//  Created by Antonio Padilla on 6/18/19.
//  Copyright © 2019 GenOrg. All rights reserved.
//

import Foundation
import UIKit

///
/// 
///
///
class DetailViewModel: NSObject {
    
    var placeDetails: [Detail] = [Detail]()
    weak var delegate: DetailViewModelDelegate!
    
    override init() {
        super.init()
    }
    
    func getDetail(from place: [Place], at index: Int) {
        let id = place[index].pID
        let params: Parameters = ["placeid": "\(id)",
            "key": "\(getApiKey())"]
        let session = URLSession.shared
        var search = GoogleSearch(type: .DETAIL, parameters: params)
        search.makeRequest(session, handler: detailCompletion)
    }
    
    func detailCompletion(data: Data?) {
        if data != nil {
            DispatchQueue.main.sync {
                do {
                    let json = try
                        JSONSerialization.jsonObject(with: data!,
                                                     options: .mutableContainers)
                        as! NSDictionary
                    let status: String? = json["status"] as? String
                    if status != nil && status! == "OK" {
                        do {
                            let resp = try JSONDecoder().decode(GoogleDetailResponse.self, from: data!)
                            placeDetails.append(resp.result)
                            //print(json)
                            delegate!.detailSearchSucceded()
                        } catch {
                            // TODO: - handle json decoding error robustly
                            print("Detail Completion Error: \(error)")
                        }
                    }
                } catch {
                    //TODO: - handle invalid json conversion error
                }
            }
        } else {
            //TODO: - handle invalid response
        }
    }
    
    func hideDetailView() {
        delegate!.hideDV()
    }
    
    func expandDetailView() {
        delegate!.expandDV()
    }
    
}
