//
//  MyOrderServicce.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 30/09/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//€1,009.45

import Foundation
import Foundation
import Alamofire
import AlamofireObjectMapper
import Localize_Swift

protocol MyOrderServicceProtocol {
    func getMyOrderList( completion: RequestCompletionHandler?)
}

class MyOrderServicce: MyOrderServicceProtocol {

    func getMyOrderList(completion: RequestCompletionHandler?) {
        let acceptProposalApi = APIConstants.myOrderAPI()
        
        let header = ["Content-Type" : "application/json" , "Authorization" : "Bearer " + UserDefaults.standard.string(forKey: PreferencesKeys.userToken)!, "Accept" : "application/json","X-localization": Localize.currentLanguage()]
        Alamofire.request(acceptProposalApi, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseObject {(response: DataResponse<MyOrderModel>) in
            print("loginApi==>\(acceptProposalApi)")
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
