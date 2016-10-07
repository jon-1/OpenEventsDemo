//
//  APIManager.swift
//  OpenEventsDemo
//
//  Created by Jon on 10/6/16.
//  Copyright © 2016 jm. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

typealias Callback = (success: (JSON?) -> Void, failure: (Any?) -> Void)

class APIManager {
    
    static let sharedInstance : APIManager = APIManager()
    private let authParams : [String : String] = ["sign" : "true", "key" :  "52553f2774e1647523321e1918694"]
    
    private init(){}
    
    func getNearbyEvents(params: [String: String], callback: Callback) {
        var parameters = params
        for k in authParams.keys {
            parameters[k] = authParams[k]
        }
        do {
            let url = try "http://api.meetup.com/2/open_events".asURL()
            
            Alamofire.request(url, method: .get, parameters: parameters, headers: nil).responseJSON {
                response in
                switch response.result {
                case .success(let data):
                    callback.success(JSON(data))
                case .failure(let error):
                    callback.failure(error)
                }
            }
        } catch {
            callback.failure(nil)
        }
        
    }

}
