//
//  ActivityServices.swift
//  Phoenix Errands
//
//  Created by Raghav Beriwala on 06/09/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//
import Foundation
import Alamofire
import AlamofireObjectMapper
import Localize_Swift

protocol ActivityServicesProtocol {
    func getInprogressDetails(completion: RequestCompletionHandler?)
    func getProposalListDetails(serviceRequestId : String , completion: RequestCompletionHandler?)
    func getOnGoingServiceList(completion: RequestCompletionHandler?)
    func getServiceRequestCancelListDetails(serviceRequestId : String , completion: RequestCompletionHandler?)
}
class ActivityServices: ActivityServicesProtocol {
    
    func getInprogressDetails(completion: RequestCompletionHandler?) {
        let introURL = APIConstants.mypostedserviceApi()
        let header = ["Content-Type" : "application/json" , "Authorization" : "Bearer " + UserDefaults.standard.string(forKey: PreferencesKeys.userToken)!,"X-localization": Localize.currentLanguage()]
        Alamofire.request(introURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseObject {(response: DataResponse<AcitivityModel>) in
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
    
    
    func getProposalListDetails(serviceRequestId : String , completion: RequestCompletionHandler?) {
        let introURL = APIConstants.mypostedserviceProposalListApi() + serviceRequestId
        let header = ["Content-Type" : "application/json" , "Authorization" : "Bearer " + UserDefaults.standard.string(forKey: PreferencesKeys.userToken)!, "Accept" : "application/json","X-localization": Localize.currentLanguage()]
        Alamofire.request(introURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseObject {(response: DataResponse<ProposalListModel>) in
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
    
    func getOnGoingServiceList(completion: RequestCompletionHandler?) {
        let introURL = APIConstants.ProviderOngoingServiceAPI()
        let header = ["Content-Type" : "application/json" , "Authorization" : "Bearer " + UserDefaults.standard.string(forKey: PreferencesKeys.userToken)! , "X-localization": Localize.currentLanguage()]
        Alamofire.request(introURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseObject {(response: DataResponse<ProviderOngoingModel>) in
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
    
    
    
    func getServiceRequestCancelListDetails(serviceRequestId : String , completion: RequestCompletionHandler?) {
        let introURL = APIConstants.mypostedserviceCancelApi() + serviceRequestId
        let header = ["Content-Type" : "application/json" , "Authorization" : "Bearer " + UserDefaults.standard.string(forKey: PreferencesKeys.userToken)!]
        Alamofire.request(introURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseObject {(response: DataResponse<CancelRequestResponse>) in
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

