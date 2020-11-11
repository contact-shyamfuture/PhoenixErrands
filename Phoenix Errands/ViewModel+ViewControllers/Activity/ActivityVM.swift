//
//  ActivityVM.swift
//  Phoenix Errands
//
//  Created by Raghav Beriwala on 06/09/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
class ActivityVM
{
    let apiService: ActivityServicesProtocol
    var refreshViewClosure: (() -> ())?
    var refreshViewOngoingClosure: (() -> ())?
    var refreshViewRequestCancelClosure: (() -> ())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    var inProgressDetails = AcitivityModel()
    var prposalDetails = ProposalListModel()
    var onGongProvider = ProviderOngoingModel()
    var cancelRequest = CancelRequestResponse()
    
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
    
    init( apiService: ActivityServicesProtocol = ActivityServices()) {
        self.apiService = apiService
    }
    
    func getInProgressDetailsToAPIService() {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        self.isLoading = true
        self.apiService.getInprogressDetails() { [weak self] (response) in
            self?.isLoading = false
            if response.responseStatus == .success {
                let responseData = response.data as? AcitivityModel
                if let _ = responseData?.status, let getDetails = responseData {
                    self?.inProgressDetails = getDetails
                    self?.refreshViewClosure?()
                } else {
                    self?.alertMessage = responseData?.message
                }
            } else {
                self?.alertMessage = response.message
            }
        }
    }
    
    
    func getProposalDetailsToAPIService(servicerequestID : String) {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        self.isLoading = true
        self.apiService.getProposalListDetails(serviceRequestId: servicerequestID) { [weak self] (response) in
            self?.isLoading = false
            if response.responseStatus == .success {
                let responseData = response.data as? ProposalListModel
                if let _ = responseData?.status, let getDetails = responseData {
                    self?.prposalDetails = getDetails
                    self?.refreshViewClosure?()
                } else {
                    self?.alertMessage = responseData?.message
                }
            } else {
                self?.alertMessage = response.message
            }
        }
    }
    
    func cancelRequestToAPIService(servicerequestID : String) {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        self.isLoading = true
        self.apiService.getServiceRequestCancelListDetails(serviceRequestId: servicerequestID) { [weak self] (response) in
            self?.isLoading = false
            if response.responseStatus == .success {
                let responseData = response.data as? CancelRequestResponse
                if let _ = responseData?.status, let getDetails = responseData {
                    self?.cancelRequest = getDetails
                    self?.refreshViewRequestCancelClosure?()
                } else {
                    self?.alertMessage = responseData?.message
                }
            } else {
                self?.alertMessage = response.message
            }
        }
    }
    
    
    
    func getOngoingServiceToAPIService() {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        self.isLoading = true
        self.apiService.getOnGoingServiceList() { [weak self] (response) in
            self?.isLoading = false
            if response.responseStatus == .success {
                let responseData = response.data as? ProviderOngoingModel
                if let _ = responseData?.status, let getDetails = responseData {
                    self?.onGongProvider = getDetails
                    self?.refreshViewOngoingClosure?()
                } else {
                    self?.alertMessage = ""
                }
            } else {
                self?.alertMessage = response.message
            }
        }
    }
}
