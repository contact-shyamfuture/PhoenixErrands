//
//  BidVM.swift
//  Phoenix Errands
//
//  Created by Raghav Beriwala on 10/09/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//


import Foundation

class BidVM
{
    
    let apiService: BidServiceProtocol
    var refreshViewClosure: (() -> ())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    var bidService = BidModel()
    
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
    
    init( apiService: BidServiceProtocol = BidServices()) {
        self.apiService = apiService
    }
    func getBidServicesToAPIService(user: BidParams) {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        let params = user.toJSON()
        self.isLoading = true
        self.apiService.sendBidDetails(params: params) { [weak self] (response) in
            self?.isLoading = false
            if response.responseStatus == .success {
                let responseData = response.data as? BidModel
                if let _ = responseData?.status, let getDetails = responseData {
                    self?.bidService = getDetails
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


