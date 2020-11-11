//
//  MyOrderVM.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 30/09/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import Foundation
import Foundation
import Foundation
class MyOrderVM {
    
    let apiService: MyOrderServicceProtocol
    var refreshViewClosure: (() -> ())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    var myOrderDetails = MyOrderModel()
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
    
    init( apiService: MyOrderServicceProtocol = MyOrderServicce()) {
        self.apiService = apiService
    }
    
    func getMyOrderListToAPIService() {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        self.isLoading = true
        self.apiService.getMyOrderList() { [weak self] (response) in
            self?.isLoading = false
            if response.responseStatus == .success {
                let responseData = response.data as? MyOrderModel
                if let _ = responseData?.status, let getUserDetails = responseData {
                    self?.myOrderDetails = getUserDetails
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
