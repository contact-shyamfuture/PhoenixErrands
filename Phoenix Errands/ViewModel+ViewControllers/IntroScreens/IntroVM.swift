//
//  IntroVM.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 02/09/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import Foundation
class IntroVM {
    
    let apiService: IntroServicesProtocol
    var refreshViewClosure: (() -> ())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    var introDetails = IntroModel()
    var faqModelDetails = FaqModel()
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
    
    init( apiService: IntroServicesProtocol = IntroServices()) {
        self.apiService = apiService
    }
    
    func getIntroDetailsToAPIService() {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        self.isLoading = true
        self.apiService.getIntroDetails() { [weak self] (response) in
            self?.isLoading = false
            if response.responseStatus == .success {
                let responseData = response.data as? IntroModel
                if let _ = responseData?.status, let getDetails = responseData {
                    self?.introDetails = getDetails
                    self?.refreshViewClosure?()
                } else {
                    self?.alertMessage = responseData?.message
                }
            } else {
                self?.alertMessage = response.message
            }
        }
    }
    func getFAQDetailsToAPIService() {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        self.isLoading = true
        self.apiService.getFAQDetails() { [weak self] (response) in
            self?.isLoading = false
            if response.responseStatus == .success {
                let responseData = response.data as? FaqModel
                if let _ = responseData?.status, let getDetails = responseData {
                    self?.faqModelDetails = getDetails
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
