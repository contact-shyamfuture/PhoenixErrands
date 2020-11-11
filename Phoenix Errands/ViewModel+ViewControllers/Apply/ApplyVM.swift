//
//  ApplyVM.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 11/09/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import Foundation
import Foundation
class ApplyVM {
    
    let apiService: ProvoderServicesProtocol
    var refreshViewClosure: (() -> ())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    var providerDetails = ProviderServcieModel()
    
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
    
    init( apiService: ProvoderServicesProtocol = ProvoderServices()) {
        self.apiService = apiService
    }
    func getServiceProviderDetailsToAPIService() {
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        self.isLoading = true
        self.apiService.getProviderServiceListDetails() { [weak self] (response) in
            self?.isLoading = false
            if response.responseStatus == .success {
                let responseData = response.data as? ProviderServcieModel
                if let _ = responseData?.status, let getDetails = responseData {
                    self?.providerDetails = getDetails
                    self?.refreshViewClosure?()
                } else {
                    self?.alertMessage = "" //responseData?.message
                }
            } else {
                self?.alertMessage = "" //response.message
            }
        }
    }
}
