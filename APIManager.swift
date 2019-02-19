//
//  APIManager.swift
//  Login-Demo-URLSession-&-AutoLayout
//
//  Created by drashti gangwar on 21/01/19.
//  Copyright © 2019 drashti gangwar. All rights reserved.
//

import Foundation
import SwiftyJSON

class APIManager {
    
    static let shared = APIManager()
    
    private init() {
        
        // Do nothing here...
    }
    
    // Completion Handler
    typealias webServiceResponse = (JSON?, Error?) -> Void
    
    // MARK: Get Service Function
    func getService (getUrl: String, completionHandler : @escaping (JSON?, Error?) -> ()) {
      
        // If Url is not valid 
        guard let url = URL(string: getUrl) else {
            print("Error: cannot create URL")
            return
        }
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else {
                print("this is the error \(String(describing: error))")
                return
            }
            
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            let json = JSON(responseData)
            completionHandler(json, error)
        }
        task.resume()
    }
    
    
    
    // MARK: Post service function
    func postService (postUrl: String, dict: [String:Any], completionHandler: @escaping webServiceResponse ) {
       
        let Url = String(format: postUrl)
        
        // Url Validate 
        guard let serviceUrl = URL(string: Url) else { return }
        
        var request = URLRequest(url: serviceUrl)
        
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: dict, options: []) else {
            return
        }
        
        request.httpBody = httpBody
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
                                         
            if let response = response {
                print("response is ",response)
            }
                                         
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    
                    // convert objects in json objects 
                    let jsonPayload = JSON(json)
                    // if you get the data, callback on the model call 
                    completionHandler(jsonPayload, nil)
                    print("JSON Serialization **** ",json)
                } catch {
                    print("error is *** ",error)
                    // If you get the error, callback with error in model class
                    completionHandler(nil, error)
                }
            }
            }.resume()
    }
}
