//
//  MySkillVM.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 01/10/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import Foundation
import Foundation
class MySkillVM {
    
    let apiService: MySkillsServiceProtocol
    var refreshViewClosure: (() -> ())?
    var showAlertClosure: (()->())?
    var showAlertAddSkillClosure: (()->())?
     var showAlertRemoveSkillClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    var MySkillDetails = MySkillModel()
    var SkillDetails = SkillListModel()
    var addSkillDetails = AddSkillModel()
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    init( apiService: MySkillsServiceProtocol = MySkillsService()) {
        self.apiService = apiService
    }
    
    func getSkillListToAPIService(lang : String ) {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        self.isLoading = true
        self.apiService.getMySkillsList(lang : lang) { [weak self] (response) in
            self?.isLoading = false
            if response.responseStatus == .success {
                let responseData = response.data as? MySkillModel
                if let _ = responseData?.status, let getUserDetails = responseData {
                    self?.MySkillDetails = getUserDetails
                    self?.refreshViewClosure?()
                } else {
                    self?.alertMessage = ""
                }
            } else {
                self?.alertMessage = response.message
            }
        }
    }
    
    func getAllSkillListToAPIService() {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        self.isLoading = true
        self.apiService.getSkillsList() { [weak self] (response) in
            self?.isLoading = false
            if response.responseStatus == .success {
                let responseData = response.data as? SkillListModel
                if let _ = responseData?.status, let getUserDetails = responseData {
                    self?.SkillDetails = getUserDetails
                    self?.refreshViewClosure?()
                } else {
                    self?.alertMessage = ""
                }
            } else {
                self?.alertMessage = response.message
            }
        }
    }
    
    func addSkillToAPIService(user: AddSkill) {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        
        if let params = self.validateUserInputs(user: user) {
            self.isLoading = true
            self.apiService.addSkills(param: params) { [weak self] (response) in
                self?.isLoading = false
                if response.responseStatus == .success {
                    let responseData = response.data as? AddSkillModel
                    if let _ = responseData?.status, let getUserDetails = responseData {
                        self?.addSkillDetails = getUserDetails
                        self?.showAlertAddSkillClosure?()
                    } else {
                        self?.alertMessage = responseData?.message
                    }
                } else {
                    self?.alertMessage = response.message
                }
            }
        }
    }
    
    func validateUserInputs(user: AddSkill) -> [String: Any]? {
        
        return user.toJSON()
    }
    
    
    func removekillToAPIService(user: RemoveSkill) {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        
        if let params = self.validateUserInputs(user: user) {
            self.isLoading = true
            self.apiService.removeSkills(param: params) { [weak self] (response) in
                self?.isLoading = false
                if response.responseStatus == .success {
                    let responseData = response.data as? AddSkillModel
                    if let _ = responseData?.status, let getUserDetails = responseData {
                        self?.addSkillDetails = getUserDetails
                        self?.showAlertRemoveSkillClosure?()
                    } else {
                        self?.alertMessage = responseData?.message
                    }
                } else {
                    self?.alertMessage = response.message
                }
            }
        }
    }
    
    func validateUserInputs(user: RemoveSkill) -> [String: Any]? {
        return user.toJSON()
    }
}
