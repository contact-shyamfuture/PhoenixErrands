//
//  SearchingServiceVM.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 05/09/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import Foundation
class SearchingServiceVM {
    
    let apiService: ServicePostServiceProtocol
    var refreshViewClosure: (() -> ())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    var CommonResponse = CommonResponseModel()
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
    
    init( apiService: ServicePostServiceProtocol = ServicePostService()) {
        self.apiService = apiService
    }
    
    func sendServicePostToAPIService(user: RequestParam) {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        
        if let params = self.validateUserInputs(user: user) {
            self.isLoading = true
            self.apiService.postServicePostDetails(params: params) { [weak self] (response) in
                self?.isLoading = false
                if response.responseStatus == .success {
                    let responseData = response.data as? CommonResponseModel
                    if let _ = responseData?.status, let getUserDetails = responseData {
                        self?.CommonResponse = getUserDetails
                        self?.refreshViewClosure?()
                    }else {
                        self?.alertMessage = responseData?.message
                    }
                } else {
                    self?.alertMessage = response.message
                }
            }
        }
    }
    
    func validateUserInputs(user: RequestParam) -> [String: Any]? {
        return user.toJSON()
    }
}
