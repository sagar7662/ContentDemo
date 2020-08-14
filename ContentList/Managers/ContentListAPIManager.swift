//
//  ContentListAPIManager.swift
//  ContentList
//
//  Created by Sagar Kumar on 12/08/20.
//  Copyright © 2020 Sagar Kumar. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

typealias SuccessBlock = (Any) -> Void
typealias ErrorBlock = (Error?) -> Void

struct ContentListAPIManager {
    
    enum EndPoint: String {
        case challenge = "challenge.json"
        
        var url: String {
            return "\(AppConfiguration.baseUrl)\(self.rawValue)"
        }
    }
}

extension ContentListAPIManager {
    
    static func contents(success: @escaping (Any) -> Void, failure: @escaping (Error?) -> Void) {
        get(endPoint: EndPoint.challenge.url, success: success, failure: failure)
    }
}

extension ContentListAPIManager {
    
    private static func get(endPoint: String,
                             success: @escaping (Any) -> Void,
                             failure: @escaping (Error?) -> Void) {
        request(URLString: endPoint, httpMethod: .get, success: success, failure: failure)
    }
    
    private static func request(URLString: String,
                                httpMethod: HTTPMethod,
                                success: @escaping (Any) -> Void,
                                failure: @escaping (Error?) -> Void) {
        AF.request(URLString, method: httpMethod).response { response in
            if let data = response.data {
                switch response.request?.url?.absoluteString {
                case EndPoint.challenge.url:
                    decodeContentData(data, success: success, failure: failure)
                default: // Handle other URLs
                    break
                }
            } else {
                failure(response.error)
            }
        }
    }
    
    private static func decodeContentData(_ data: Data, success: @escaping (Any) -> Void, failure: @escaping (Error?) -> Void) {
        do {
            let contents = try JSONDecoder().decode([Content].self, from: data)
            success(contents)
        } catch let error {
            failure(error)
        }
    }
}
