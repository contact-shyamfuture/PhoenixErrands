//
//  NotificationServices.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 30/09/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import Localize_Swift

protocol NotificationServicesProtocol {
    func getNotificationList( completion: RequestCompletionHandler?)
    func getNotificationStatusUpdate(id : String, completion: RequestCompletionHandler?)
    func getNotificationAllStatusUpdate(completion: RequestCompletionHandler?)
}
class NotificationServices: NotificationServicesProtocol {
    
    func getNotificationList(completion: RequestCompletionHandler?) {
        let acceptProposalApi = APIConstants.notificationAPI()
        let header = ["Content-Type" : "application/json" , "Authorization" : "Bearer " + UserDefaults.standard.string(forKey: PreferencesKeys.userToken)!, "Accept" : "application/json","X-localization": Localize.currentLanguage()]
        print("Header==>",header)
        Alamofire.request(acceptProposalApi, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseObject {(response: DataResponse<NotificationListModel>) in
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
    
    
    func getNotificationStatusUpdate(id : String, completion: RequestCompletionHandler?) {
        let notificationUpdateApi = APIConstants.NotificationUpdateAPI() + id
        let header = ["Content-Type" : "application/json" , "Authorization" : "Bearer " + UserDefaults.standard.string(forKey: PreferencesKeys.userToken)!, "Accept" : "application/json","X-localization": Localize.currentLanguage()]
        Alamofire.request(notificationUpdateApi, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseObject {(response: DataResponse<NotificationUpdateModel>) in
            print("loginApi==>\(notificationUpdateApi)")
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
    
    func getNotificationAllStatusUpdate(completion: RequestCompletionHandler?) {
        let notificationUpdateApi = APIConstants.NotificationAllUpdateAPI()
        let header = ["Content-Type" : "application/json" , "Authorization" : "Bearer " + UserDefaults.standard.string(forKey: PreferencesKeys.userToken)!, "Accept" : "application/json","X-localization": Localize.currentLanguage()]
        Alamofire.request(notificationUpdateApi, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseObject {(response: DataResponse<NotificationUpdateModel>) in
            print("loginApi==>\(notificationUpdateApi)")
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
