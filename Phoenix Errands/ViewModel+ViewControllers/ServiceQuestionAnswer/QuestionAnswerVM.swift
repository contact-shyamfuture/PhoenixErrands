//
//  QuestionAnswerModel.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 03/09/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import Foundation
class QuestionAnswerVM {
    
    let apiService: QuestionAnswerSetServiceProtocol
    var refreshViewClosure: (() -> ())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    var questionSetDetails = QuestionAnswerModel()
    
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
    
    init( apiService: QuestionAnswerSetServiceProtocol = QuestionAnswerSetService()) {
        self.apiService = apiService
    }
    
    func getQuestionSetDetailsToAPIService(serviceID : String , lang : String) {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        self.isLoading = true
        self.apiService.getQuestionAnswerDetails(lang: lang, serviceID: serviceID) { [weak self] (response) in
            self?.isLoading = false
            if response.responseStatus == .success {
                let responseData = response.data as? QuestionAnswerModel
                if let _ = responseData?.status, let getDetails = responseData {
                    self?.questionSetDetails = getDetails
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
