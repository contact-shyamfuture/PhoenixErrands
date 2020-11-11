//
//  ServicePost.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 05/09/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

protocol ServicePostServiceProtocol {
    func postServicePostDetails(params: [String: Any], completion: RequestCompletionHandler?)
}
class ServicePostService: ServicePostServiceProtocol {
    
    func postServicePostDetails(params: [String : Any], completion: RequestCompletionHandler?) {
        let servicePostApi = APIConstants.postServicepi()
        print("params==>\(params)")
        let jsonString : String?
        do{
            let jsonData = try! JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            
            if let jsonString1 = String(data: jsonData, encoding: .utf8) {
                print(jsonString1)
                jsonString = jsonString1
            }
        }
        catch{
            print("Error")
        }
        
        
        let header = ["Content-Type" :" application/json" , "Authorization" : "Bearer " + UserDefaults.standard.string(forKey: PreferencesKeys.userToken)!, "Accept" : "application/json"]
        Alamofire.request(servicePostApi, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header).responseObject {(response: DataResponse<CommonResponseModel>) in
            print("loginApi==>\(servicePostApi)")
            let loginApiResponse : Response!
            
            var responseStausCode: Int = 1
            var failureMessage: String = ""
            
            if let message = response.error?.localizedDescription {
                failureMessage = message
            }
            if let statusCode = response.response?.statusCode {
                responseStausCode = statusCode
            }
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
            switch(response.result) {
            case .success(let data):
                loginApiResponse = Response.init(code: .success, responseStatusCode: responseStausCode, message: failureMessage, data: data)
            case .failure( _):
                loginApiResponse = Response.init(code: .failure, responseStatusCode: responseStausCode, message: failureMessage, data: nil)
            }
            completion?(loginApiResponse)
        }
    }
}
