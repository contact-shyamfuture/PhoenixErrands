//
//  AddressVM.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 24/09/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import Foundation
class AddressVM {
    
    let apiService: AddressServicesProtocol
    var refreshViewClosure: (() -> ())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    var addressResponse = AddressListModel()
    var addressPostResponse = AddressPostModel()
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
    
    init( apiService: AddressServicesProtocol = AddressServices()) {
        self.apiService = apiService
    }
    
    func getAddressListToAPIService() {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        self.isLoading = true
        self.apiService.getAddressListDetails() { [weak self] (response) in
            self?.isLoading = false
            if response.responseStatus == .success {
                let responseData = response.data as? AddressListModel
                if let _ = responseData?.status, let getUserDetails = responseData {
                    self?.addressResponse = getUserDetails
                    self?.refreshViewClosure?()
                } else {
                    self?.alertMessage = ""
                }
            } else {
                self?.alertMessage = response.message
            }
        }
    }
    
    func sendAddAddressToAPIService(user: AddressParamModel) {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        
        if let params = self.validateUserInputs(user: user) {
            self.isLoading = true
            self.apiService.postAddressListDetails(param: params) { [weak self] (response) in
                self?.isLoading = false
                if response.responseStatus == .success {
                    let responseData = response.data as? AddressPostModel
                    if let _ = responseData?.status, let getUserDetails = responseData {
                        self?.addressPostResponse = getUserDetails
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
    
    func validateUserInputs(user: AddressParamModel) -> [String: Any]? {
        guard let title = user.title, !title.isEmpty else {
            self.alertMessage = alterTitleMsg
            return nil
        }
        guard let fullAddress = user.fulladress, !fullAddress.isEmpty else {
            self.alertMessage = alterAddressMsg
            return nil
        }
        
        guard let phone = user.phone, !phone.isEmpty else {
            self.alertMessage = alterPhoneMsg
            return nil
        }
        
        return user.toJSON()
    }
}
