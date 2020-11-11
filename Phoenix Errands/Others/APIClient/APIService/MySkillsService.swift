//
//  MySkillsService.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 01/10/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import Foundation
import Foundation
import Alamofire
import AlamofireObjectMapper
import Localize_Swift
protocol MySkillsServiceProtocol {
    func getMySkillsList(lang : String, completion: RequestCompletionHandler?)
    func getSkillsList( completion: RequestCompletionHandler?)
    func addSkills(param : [String : Any], completion: RequestCompletionHandler?)
    func removeSkills(param : [String : Any], completion: RequestCompletionHandler?)
}
class MySkillsService: MySkillsServiceProtocol {
    
    func getMySkillsList(lang : String, completion: RequestCompletionHandler?) {
        let acceptProposalApi = APIConstants.mySkillAPI()
        
        let header = ["Content-Type" : "application/json" , "Authorization" : "Bearer " + UserDefaults.standard.string(forKey: PreferencesKeys.userToken)!, "Accept" : "application/json" , "X-localization": lang]
        Alamofire.request(acceptProposalApi, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseObject {(response: DataResponse<MySkillModel>) in
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
    
    func getSkillsList(completion: RequestCompletionHandler?) {
        let acceptProposalApi = APIConstants.allSkillAPI()
        
        let header = ["Content-Type" : "application/json" , "Authorization" : "Bearer " + UserDefaults.standard.string(forKey: PreferencesKeys.userToken)!, "Accept" : "application/json" , "X-localization": Localize.currentLanguage()]
        Alamofire.request(acceptProposalApi, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseObject {(response: DataResponse<SkillListModel>) in
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
    
    func addSkills(param : [String : Any],completion: RequestCompletionHandler?) {
        let addSkillApi = APIConstants.addSkillAPI()
        
        let header = ["Content-Type" : "application/json" , "Authorization" : "Bearer " + UserDefaults.standard.string(forKey: PreferencesKeys.userToken)!, "Accept" : "application/json"]
        Alamofire.request(addSkillApi, method: .post, parameters: param, encoding: JSONEncoding.default, headers: header).responseObject {(response: DataResponse<AddSkillModel>) in
            print("loginApi==>\(addSkillApi)")
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
    
    func removeSkills(param : [String : Any],completion: RequestCompletionHandler?) {
        let addSkillApi = APIConstants.removeSkillAPI()
        
        let header = ["Content-Type" : "application/json" , "Authorization" : "Bearer " + UserDefaults.standard.string(forKey: PreferencesKeys.userToken)!, "Accept" : "application/json"]
        Alamofire.request(addSkillApi, method: .post, parameters: param, encoding: JSONEncoding.default, headers: header).responseObject {(response: DataResponse<AddSkillModel>) in
            print("loginApi==>\(addSkillApi)")
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
