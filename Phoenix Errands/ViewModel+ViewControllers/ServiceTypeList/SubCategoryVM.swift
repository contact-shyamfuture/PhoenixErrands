//
//  SubCategoryVM.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 29/08/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import Foundation
import Foundation
class SubCategoryVM {
    
    let apiService: CategoryServiceProtocol
    var refreshViewClosure: (() -> ())?
    var refreshViewSearchClosure: (() -> ())?//refreshViewSearchClosure
    var refreshViewSearchNotFoundClosure: (() -> ())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    var subCategoryDetails = SubCategoryModel()
    var createOwnDetails = CreateOwnCategoryModel()
    
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
    func getSubCategoryDetailsToAPIService(categoryID : String , lang :String) {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        self.isLoading = true
        self.apiService.getSubCategoryDetails(lang :lang, categoryID: categoryID) { [weak self] (response) in
            self?.isLoading = false
            if response.responseStatus == .success {
                let responseData = response.data as? SubCategoryModel
                if let _ = responseData?.status, let getDetails = responseData {
                    self?.subCategoryDetails = getDetails
                    self?.refreshViewClosure?()
                } else {
                    self?.alertMessage = responseData?.message
                }
            } else {
                self?.alertMessage = response.message
            }
        }
    }
    
    func getSubCategorySearchDetailsToAPIService(user: SubCatagorySearchParams) {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        let params = user.toJSON()
        self.isLoading = true
        self.apiService.getSubCategorySearchDetails(params: params) { [weak self] (response) in
            self?.isLoading = false
            if response.responseStatus == .success {
                let responseData = response.data as? SubCategoryModel
                if let _ = responseData?.status, let getDetails = responseData {
                    self?.subCategoryDetails = getDetails
                    self?.refreshViewSearchClosure?()
                } else {
                    self?.alertMessage = responseData?.message
                }
            } else {
                self?.alertMessage = response.message
            }
        }
    }
    
    func postCreateOwnCategoryToAPIService(user: CreateOwnParams , lang :String) {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        let params = user.toJSON()
        self.isLoading = true
        self.apiService.postCreateOwnCategory(lang :lang, params: params ) { [weak self] (response) in
            self?.isLoading = false
            if response.responseStatus == .success {
                let responseData = response.data as? CreateOwnCategoryModel
                if let _ = responseData?.status, let getDetails = responseData {
                    self?.createOwnDetails = getDetails
                    self?.refreshViewSearchNotFoundClosure?()
                } else {
                    self?.alertMessage = responseData?.message
                }
            } else {
                self?.alertMessage = response.message
            }
        }
    }
}



