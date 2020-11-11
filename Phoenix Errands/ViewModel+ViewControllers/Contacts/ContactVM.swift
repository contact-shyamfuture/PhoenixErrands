//
//  ContactVM.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 02/09/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import Foundation
import Foundation
class ContactVM {
    
    let apiService: ContactServicesProtocol
    var refreshViewClosure: (() -> ())?
    var refreshViewContactClosure: (() -> ())?
    var refreshViewReviewClosure: (() -> ())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    var contactDetails = ContactModel()
    var contactDetailsObj = ContactDetailsModel()
    var reviewsDetails = ReviewListModel()
    
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
    
    init( apiService: ContactServicesProtocol = ContactServices()) {
        self.apiService = apiService
    }
    func getContactDetailsToAPIService() {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        self.isLoading = true
        self.apiService.getContactDetails() { [weak self] (response) in
            self?.isLoading = false
            if response.responseStatus == .success {
                let responseData = response.data as? ContactModel
                if let _ = responseData?.status, let getDetails = responseData {
                    self?.contactDetails = getDetails
                    self?.refreshViewClosure?()
                } else {
                    self?.alertMessage = responseData?.message
                }
            } else {
                self?.alertMessage = response.message
            }
        }
    }
    
    func getContactDetailsToAPIService(user: ContactParams) {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        
        if let params = self.validateUserInputs(user: user) {
            self.isLoading = true
            self.apiService.getContactDetail(param: params) { [weak self] (response) in
                self?.isLoading = false
                if response.responseStatus == .success {
                    let responseData = response.data as? ContactDetailsModel
                    if let _ = responseData?.status, let getUserDetails = responseData {
                        self?.contactDetailsObj = getUserDetails
                        self?.refreshViewContactClosure?()
                    } else {
                        self?.alertMessage = responseData?.message
                    }
                } else {
                    self?.alertMessage = response.message
                }
            }
        }
    }
    
    func getReviewListToAPIService(user: ReviewsParams) {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        if let params = self.validateUserInputs(user: user) {
            self.isLoading = true
            self.apiService.getReviewDetail(param: params) { [weak self] (response) in
                self?.isLoading = false
                if response.responseStatus == .success {
                    let responseData = response.data as? ReviewListModel
                    if let _ = responseData?.status, let getUserDetails = responseData {
                        self?.reviewsDetails = getUserDetails
                        self?.refreshViewReviewClosure?()
                    } else {
                        self?.alertMessage = ""
                    }
                } else {
                    self?.alertMessage = response.message
                }
            }
        }
    }
    
    func validateUserInputs(user: ContactParams) -> [String: Any]? {
        
        return user.toJSON()
    }
    
    func validateUserInputs(user: ReviewsParams) -> [String: Any]? {
        
        return user.toJSON()
    }
}
