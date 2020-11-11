//
//  PaymentService.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 26/09/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import Localize_Swift

protocol PaymentServiceProtocol {
    func postAcceptProposalDetails(param : [String : Any] , completion: RequestCompletionHandler?)
    func postPaymentDetails(param : [String : Any] , completion: RequestCompletionHandler?)
    func saveVendorCardDetails(param : [String : Any] , completion: RequestCompletionHandler?)
    func getVendorCardDetails(param : [String : Any] , completion: RequestCompletionHandler?)
    func deleteExistingCardDetails(param : [String : Any] , completion: RequestCompletionHandler?)
    func confirmPaymentDetails(param : [String : Any] , completion: RequestCompletionHandler?)
}

class PaymentService: PaymentServiceProtocol {
    
    func postAcceptProposalDetails(param : [String : Any] ,completion: RequestCompletionHandler?) {
        let acceptProposalApi = APIConstants.acceptProposalAPI()
        
        let header = ["Content-Type" : "application/json" , "Authorization" : "Bearer " + UserDefaults.standard.string(forKey: PreferencesKeys.userToken)!, "Accept" : "application/json","X-localization": Localize.currentLanguage()]
        Alamofire.request(acceptProposalApi, method: .post, parameters: param, encoding: JSONEncoding.default, headers: header).responseObject {(response: DataResponse<PaymentModel>) in
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
    
    func postPaymentDetails(param : [String : Any] ,completion: RequestCompletionHandler?) {
        let acceptProposalApi = APIConstants.paymentAPI()
        
        let header = ["Content-Type" : "application/json" , "Authorization" : "Bearer " + UserDefaults.standard.string(forKey: PreferencesKeys.userToken)!, "Accept" : "application/json"]
        Alamofire.request(acceptProposalApi, method: .post, parameters: param, encoding: JSONEncoding.default, headers: header).responseObject {(response: DataResponse<PaymentModel>) in
            print("loginApi==>\(acceptProposalApi)")
            print("param==>\(param)")
            print("header==>\(header)")
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
    
    
    func saveVendorCardDetails(param : [String : Any] ,completion: RequestCompletionHandler?) {
        let acceptProposalApi = APIConstants.saveVendorBankAPI()
        
        let header = ["Content-Type" : "application/json" , "Authorization" : "Bearer " + UserDefaults.standard.string(forKey: PreferencesKeys.userToken)!, "Accept" : "application/json"]
        Alamofire.request(acceptProposalApi, method: .post, parameters: param, encoding: JSONEncoding.default, headers: header).responseObject {(response: DataResponse<CardSaveModel>) in
            print("loginApi==>\(acceptProposalApi)")
            print("param==>\(param)")
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
    func getVendorCardDetails(param : [String : Any] , completion: RequestCompletionHandler?){
        let acceptProposalApi = APIConstants.bankDetailsGETAPI()
        
        let header = ["Content-Type" : "application/json" , "Authorization" : "Bearer " + UserDefaults.standard.string(forKey: PreferencesKeys.userToken)!, "Accept" : "application/json"]
        Alamofire.request(acceptProposalApi, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseObject {(response: DataResponse<CardGeteModel>) in
            print("Api==>\(acceptProposalApi)")
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
    
    
    func deleteExistingCardDetails(param : [String : Any] , completion: RequestCompletionHandler?){
        let acceptProposalApi = APIConstants.deleteCardAPI()
        
        let header = ["Content-Type" : "application/json" , "Authorization" : "Bearer " + UserDefaults.standard.string(forKey: PreferencesKeys.userToken)!, "Accept" : "application/json"]
        Alamofire.request(acceptProposalApi, method: .post, parameters: param, encoding: JSONEncoding.default, headers: header).responseObject {(response: DataResponse<CardGeteModel>) in
            print("Api==>\(acceptProposalApi)")
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
    
    func confirmPaymentDetails(param : [String : Any] , completion: RequestCompletionHandler?){
        let acceptProposalApi = APIConstants.confirmPaymentAPI()
        
        let header = ["Content-Type" : "application/json" , "Authorization" : "Bearer " + UserDefaults.standard.string(forKey: PreferencesKeys.userToken)!, "Accept" : "application/json"]
        Alamofire.request(acceptProposalApi, method: .post, parameters: param, encoding: JSONEncoding.default, headers: header).responseObject {(response: DataResponse<PaymentConfirmModel>) in
            print("Api==>\(acceptProposalApi)")
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
