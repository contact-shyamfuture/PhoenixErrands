//
//  PaymentVM.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 26/09/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
class PaymentVM {
    
    let apiService: PaymentServiceProtocol
    var refreshViewClosure: (() -> ())?
    var refreshPaymentViewClosure: (() -> ())?
    var refreshConfirmPaymentViewClosure: (() -> ())?
    var refreshDeleteViewClosure: (() -> ())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    var PaymentDetails = PaymentModel()
    var deleteCardModel = CardGeteModel()
    var confirmPayment = PaymentConfirmModel()
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
    
    init( apiService: PaymentServiceProtocol = PaymentService()) {
        self.apiService = apiService
    }
    
    func sendAcceptProposalToAPIService(user: AcceptProposalParam) {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        
        if let params = self.validateUserInputs(user: user) {
            self.isLoading = true
            self.apiService.postAcceptProposalDetails(param: params) { [weak self] (response) in
                self?.isLoading = false
                if response.responseStatus == .success {
                    let responseData = response.data as? PaymentModel
                    if let _ = responseData?.status, let getUserDetails = responseData {
                        self?.PaymentDetails = getUserDetails
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
    
    func sendPaymentDetailsToAPIService(user: AcceptProposalParam) {
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        if let params = self.validateUserInputs(user: user) {
            self.isLoading = true
            self.apiService.postPaymentDetails(param: params) { [weak self] (response) in
                self?.isLoading = false
                if response.responseStatus == .success {
                    let responseData = response.data as? PaymentModel
                    if let _ = responseData?.status, let getUserDetails = responseData {
                        self?.PaymentDetails = getUserDetails
                        self?.refreshPaymentViewClosure?()
                    } else {
                        self?.alertMessage = responseData?.message
                    }
                } else {
                    self?.alertMessage = response.message
                }
            }
        }
    }
    
    func validateUserInputs(user: AcceptProposalParam) -> [String: Any]? {
        return user.toJSON()
    }
    
    
    
    func deleteCardDetailsToAPIService(user: DeleteCardParam) {
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        if let params = self.validateUserInputs(user: user) {
            self.isLoading = true
            self.apiService.deleteExistingCardDetails(param: params) { [weak self] (response) in
                self?.isLoading = false
                if response.responseStatus == .success {
                    let responseData = response.data as? CardGeteModel
                    if let _ = responseData?.status, let getUserDetails = responseData {
                        self?.deleteCardModel = getUserDetails
                        self?.refreshDeleteViewClosure?()
                    } else {
                        self?.alertMessage = responseData?.message
                    }
                } else {
                    self?.alertMessage = response.message
                }
            }
        }
    }
    
    func validateUserInputs(user: DeleteCardParam) -> [String: Any]? {
        return user.toJSON()
    }
    
    
    
    func confirmPaymentToAPIService(user: ConfirmPaymentParam) {
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        if let params = self.validateUserInputs(user: user) {
            self.isLoading = true
            self.apiService.confirmPaymentDetails(param: params) { [weak self] (response) in
                self?.isLoading = false
                if response.responseStatus == .success {
                    let responseData = response.data as? PaymentConfirmModel
                    if let _ = responseData?.status, let getUserDetails = responseData {
                        self?.confirmPayment = getUserDetails
                        self?.refreshConfirmPaymentViewClosure?()
                    } else {
                        self?.alertMessage = responseData?.message
                    }
                } else {
                    self?.alertMessage = response.message
                }
            }
        }
    }
    
    func validateUserInputs(user: ConfirmPaymentParam) -> [String: Any]? {
        return user.toJSON()
    }
}

