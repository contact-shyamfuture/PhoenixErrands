//
//  ServiceDetailsVM.swift
//  Phoenix Errands
//
//  Created by Raghav Beriwala on 12/09/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import Foundation

class ServiceDetailsVM {
    
    let apiService: ServiceDetailsServicesProtocol
    var refreshViewClosure: (() -> ())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    var serviceDetails = ServiceDetailsModel()
    
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
    
    init( apiService: ServiceDetailsServicesProtocol = ServiceDetailsServices()) {
        self.apiService = apiService
    }
    
    func getServiceDetailsToAPIService(requestID : Int) {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        self.isLoading = true
        self.apiService.getServiceDetailsDetails(requestID: requestID) { [weak self] (response) in
            self?.isLoading = false
            if response.responseStatus == .success {
                let responseData = response.data as? ServiceDetailsModel
                if let _ = responseData?.status, let getDetails = responseData {
                    self?.serviceDetails = getDetails
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

