//
//  AddressServices.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 24/09/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import Localize_Swift

protocol AddressServicesProtocol {
    func getAddressListDetails(completion: RequestCompletionHandler?)
    func postAddressListDetails(param : [String : Any] , completion: RequestCompletionHandler?)
}
class AddressServices: AddressServicesProtocol {
    
    func getAddressListDetails(completion: RequestCompletionHandler?) {
        let servicePostApi = APIConstants.addressListAPI()
        
        let header = ["Content-Type" : "application/json" , "Authorization" : "Bearer " + UserDefaults.standard.string(forKey: PreferencesKeys.userToken)!, "Accept" : "application/json","X-localization": Localize.currentLanguage()]
        Alamofire.request(servicePostApi, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseObject {(response: DataResponse<AddressListModel>) in
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
    
    func postAddressListDetails(param : [String : Any] ,completion: RequestCompletionHandler?) {
        let addressPostApi = APIConstants.addressPostAPI()
        
        let header = ["Content-Type" : "application/json" , "Authorization" : "Bearer " + UserDefaults.standard.string(forKey: PreferencesKeys.userToken)!, "Accept" : "application/json"]
        Alamofire.request(addressPostApi, method: .post, parameters: param, encoding: JSONEncoding.default, headers: header).responseObject {(response: DataResponse<AddressPostModel>) in
            print("loginApi==>\(addressPostApi)")
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
