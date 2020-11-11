//
//  ProviderSkillVM.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 30/08/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import Foundation

class ProviderSkillVM {
    
    let apiService: ProviderListServiceProtocol
    var refreshViewClosure: (() -> ())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    var skillDetails = MySkillModel()
    
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
    
    init( apiService: ProviderListServiceProtocol = ProviderListService()) {
        self.apiService = apiService
    }
    
    func getSkillDetailsToAPIService(serviceID : String) {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        self.isLoading = true
        self.apiService.getProviderListDetails(serviceID : serviceID) { [weak self] (response) in
            self?.isLoading = false
            if response.responseStatus == .success {
                let responseData = response.data as? MySkillModel
                if let _ = responseData?.status, let getDetails = responseData {
                    self?.skillDetails = getDetails
                    self?.refreshViewClosure?()
                } else {
                    self?.alertMessage = responseData?.message
                }
            } else {
                self?.alertMessage = response.message
            }
        }
    }
}
