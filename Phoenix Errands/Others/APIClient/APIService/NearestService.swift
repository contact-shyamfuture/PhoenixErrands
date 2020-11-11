//
//  NearestService.swift
//  Phoenix Errands
//
//  Created by Raghav Beriwala on 10/09/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import Localize_Swift

protocol ProfileNearestServicesProtocol {
    func getNearestServices(completion: RequestCompletionHandler?)
}
//import Localize_Swift
class NearestService: ProfileNearestServicesProtocol {
    
    func getNearestServices( completion: RequestCompletionHandler?) {
        let introURL = APIConstants.searvicenearmeApi()
        let header = ["Content-Type" : "application/json" , "Authorization" : "Bearer " + UserDefaults.standard.string(forKey: PreferencesKeys.userToken)!, "Accept" : "application/json" , "X-localization": Localize.currentLanguage()]
        Alamofire.request(introURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseObject {(response: DataResponse<NearestServiceModel>) in
            print("loginApi==>\(introURL)")
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

