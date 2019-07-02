//
//  \.swift
//  Shake2.0
//
//  Created by Antonio Padilla on 6/18/19.
//  Copyright © 2019 GenOrg. All rights reserved.
//

import Foundation

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
        delegate.willLoadDetail()
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
                    //print(json)
                    if status != nil && status! == "OK" {
                        do {
                            let resp = try JSONDecoder().decode(GoogleDetailResponse.self, from: data!)
                            print(resp)
                        } catch {
                            // TODO: - handle json decoding error robustly
                            print("error: \(error)")
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
    
}
