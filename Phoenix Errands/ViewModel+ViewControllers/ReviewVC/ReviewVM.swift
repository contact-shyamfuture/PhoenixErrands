//
//  ReviewVM.swift
//  Phoenix Errands
//
//  Created by Raghav Beriwala on 04/10/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import Foundation

class ReviewVM
{
    let apiService: ReviewServicesProtocol
    var refreshViewClosure: (() -> ())?
    var refreshViewCompletedClosure: (() -> ())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    var bidService = BidModel()
    
    var orderCompleted = CompletedModel()
    
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
    
    init( apiService: ReviewServicesProtocol = ReviewServices()) {
        self.apiService = apiService
    }
    
    func getReviewDetailsToAPIService(user: ReviewParam) {
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        let params = user.toJSON()
        self.isLoading = true
        self.apiService.sendReviewDetails(param: params) { [weak self] (response) in
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
    
    
    func completedOrderToAPIService(user: CompletedOrderParam) {
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        let params = user.toJSON()
        self.isLoading = true
        self.apiService.sendMarkAsCompletedDetails(param: params) { [weak self] (response) in
            self?.isLoading = false
            if response.responseStatus == .success {
                let responseData = response.data as? CompletedModel
                if let _ = responseData?.status, let getDetails = responseData {
                    self?.orderCompleted = getDetails
                    self?.refreshViewCompletedClosure?()
                } else {
                    self?.alertMessage = responseData?.message
                }
            } else {
                self?.alertMessage = response.message
            }
        }
    }
}

