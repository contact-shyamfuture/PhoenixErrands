//
//  ProviderDetailsVM.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 25/09/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import Foundation
import UIKit
class ProviderDetailsVM {
    
    let apiService: ProviderListServiceProtocol
    var refreshViewClosure: (() -> ())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    var providerDetails = ProviderDetailsModel()
    
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
    
    func getProviderDetailsToAPIService(serviceID : String, providerID : String) {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        self.isLoading = true
        self.apiService.getProviderDetails(serviceID: serviceID, providerID: providerID) { [weak self] (response) in
            self?.isLoading = false
            if response.responseStatus == .success {
                let responseData = response.data as? ProviderDetailsModel
                if let _ = responseData?.status, let getDetails = responseData {
                    self?.providerDetails = getDetails
                    self?.refreshViewClosure?()
                } else {
                    self?.alertMessage = ""
                }
            } else {
                self?.alertMessage = response.message
            }
        }
    }
}
