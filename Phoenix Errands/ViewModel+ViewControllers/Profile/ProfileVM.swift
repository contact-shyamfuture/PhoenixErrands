//
//  ProfileVM.swift
//  Phoenix Errands
//
//  Created by Raghav Beriwala on 07/09/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//
import Foundation
class ProfileVM
{
    
    let apiService: ProfileServicesProtocol
    var refreshViewClosure: (() -> ())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    var profileDetails = ProfileModel()
    
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
    
    init( apiService: ProfileServicesProtocol = ProfileServices()) {
        self.apiService = apiService
    }
    func getProfileDetailsToAPIService() {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        self.isLoading = true
        self.apiService.getProfileDetails() { [weak self] (response) in
            self?.isLoading = false
            if response.responseStatus == .success {
                let responseData = response.data as? ProfileModel
                if let _ = responseData?.status, let getDetails = responseData {
                    self?.profileDetails = getDetails
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
