//
//  CardSaveVM.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 10/12/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import Foundation
class CardSaveVM{
    
    let apiService: PaymentServiceProtocol
    var refreshViewClosure: (() -> ())?
    var refreshGETViewClosure: (() -> ())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    var cardSave = CardSaveModel()
    var cardGET =  CardGeteModel()
    
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
    func saveVendorDetailsToAPIService(user: IBANParams) {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        if let params = self.validateUserInputs(user: user) {
            self.isLoading = true
            self.apiService.saveVendorCardDetails(param: params) { [weak self] (response) in
                self?.isLoading = false
                if response.responseStatus == .success {
                    let responseData = response.data as? CardSaveModel
                    if let _ = responseData?.status, let getDetails = responseData {
                        self?.cardSave = getDetails
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
    
    func validateUserInputs(user: IBANParams) -> [String: Any]? {
        guard let name = user.account_holder_name, !name.isEmpty else {
            self.alertMessage = alterAccountName
            return nil
        }
        guard let bankName = user.bank_name, !bankName.isEmpty else {
            self.alertMessage = alterBankName
            return nil
        }
        guard let accountNumber = user.account_number, !accountNumber.isEmpty else {
            self.alertMessage = alterAccountNumber
            return nil
        }
        return user.toJSON()
    }
    
    //Get card Details
    func getVendorDetailsToAPIService(){
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        self.isLoading = true
        self.apiService.getVendorCardDetails(param: [:]) { [weak self] (response) in
            self?.isLoading = false
            if response.responseStatus == .success {
                let responseData = response.data as? CardGeteModel
                if let _ = responseData?.status, let getDetails = responseData {
                    self?.cardGET = getDetails
                    self?.refreshGETViewClosure?()
                } else {
                    self?.alertMessage = responseData?.message
                }
            } else {
                self?.alertMessage = response.message
            }
        }
               
    }
}
