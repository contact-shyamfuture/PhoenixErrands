//
//  NotificationVM.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 30/09/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import Foundation
import Foundation
class NotificationVM {
    
    let apiService: NotificationServicesProtocol
    var refreshViewClosure: (() -> ())?
    var refreshViewUpdateClosure: (() -> ())?
    var refreshViewAllUpdateClosure: (() -> ())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    var NotificationDetails = NotificationListModel()
    var NotificationUpdate = NotificationUpdateModel()
    
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
    
    init( apiService: NotificationServicesProtocol = NotificationServices()) {
        self.apiService = apiService
    }
    
    func getNotificationListToAPIService() {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        self.isLoading = true
        self.apiService.getNotificationList() { [weak self] (response) in
            self?.isLoading = false
            if response.responseStatus == .success {
                let responseData = response.data as? NotificationListModel
                if let _ = responseData?.status, let getUserDetails = responseData {
                    self?.NotificationDetails = getUserDetails
                    self?.refreshViewClosure?()
                } else {
                    self?.alertMessage = ""
                }
            } else {
                self?.alertMessage = response.message
            }
        }
    }
    
    func getNotificationUpdateToAPIService(id : String) {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        self.isLoading = true
        self.apiService.getNotificationStatusUpdate(id : id) { [weak self] (response) in
            self?.isLoading = false
            if response.responseStatus == .success {
                let responseData = response.data as? NotificationUpdateModel
                if let _ = responseData?.status, let getUserDetails = responseData {
                    self?.NotificationUpdate = getUserDetails
                    self?.refreshViewUpdateClosure?()
                } else {
                    self?.alertMessage = ""
                }
            } else {
                self?.alertMessage = response.message
            }
        }
    }
    
    func getNotificationAllStatusUpdateToAPIService() {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        self.isLoading = true
        self.apiService.getNotificationAllStatusUpdate() { [weak self] (response) in
            self?.isLoading = false
            if response.responseStatus == .success {
                let responseData = response.data as? NotificationUpdateModel
                if let _ = responseData?.status, let getUserDetails = responseData {
                    self?.NotificationUpdate = getUserDetails
                    self?.refreshViewAllUpdateClosure?()
                } else {
                    self?.alertMessage = ""
                }
            } else {
                self?.alertMessage = response.message
            }
        }
    }
}

