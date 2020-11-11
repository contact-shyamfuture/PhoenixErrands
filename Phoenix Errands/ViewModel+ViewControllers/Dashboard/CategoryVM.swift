//
//  CategoryVM.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 29/08/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import Foundation
class CategoryVM {
    
    let apiService: CategoryServiceProtocol
    var refreshViewClosure: (() -> ())?
    var refreshLanguageViewClosure: (() -> ())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    var categoryDetails = CategoryModel()
    var language = languageModel()
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
    
    init( apiService: CategoryServiceProtocol = CategoryService()) {
        self.apiService = apiService
    }
    
    func getCategoryDetailsToAPIService(lang :String) {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        self.isLoading = true
        self.apiService.getCategoryDetails(lang :lang) { [weak self] (response) in
            self?.isLoading = false
            if response.responseStatus == .success {
                let responseData = response.data as? CategoryModel
                if let _ = responseData?.status, let getDetails = responseData {
                    self?.categoryDetails = getDetails
                    self?.refreshViewClosure?()
                } else {
                    self?.alertMessage = responseData?.message
                }
            } else {
                self?.alertMessage = response.message
            }
        }
    }
    
    func postLanguageToAPIService(params : LanguageParam) {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        let prm = params.toJSON()
        self.isLoading = true
        self.apiService.changeLanguageUpdate(params : prm) { [weak self] (response) in
            self?.isLoading = false
            if response.responseStatus == .success {
                let responseData = response.data as? languageModel
                if let _ = responseData?.status, let getDetails = responseData {
                    self?.language = getDetails
                    self?.refreshLanguageViewClosure?()
                } else {
                    self?.alertMessage = ""
                }
            } else {
                self?.alertMessage = response.message
            }
        }
    }
    
    
}
