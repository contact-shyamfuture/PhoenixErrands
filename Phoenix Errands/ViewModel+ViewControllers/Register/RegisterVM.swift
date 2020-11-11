//
//  RegisterVM.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 28/08/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import Foundation
class RegisterVM {
    
    let apiService: RegiterServiceProtocol
    var refreshViewClosure: (() -> ())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    var userDetails = UserResponse()
    
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
    
    init( apiService: RegiterServiceProtocol = RegiterService()) {
        self.apiService = apiService
    }
    
    
    func sendRegisterCredentialsToAPIService(user: UserRegister) {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        
        if let params = self.validateUserInputs(user: user) {
            self.isLoading = true
            self.apiService.sendRegisterDetails(params: params) { [weak self] (response) in
                self?.isLoading = false
                if response.responseStatus == .success {
                    let responseData = response.data as? UserResponse
                    if let _ = responseData?.status, let getUserDetails = responseData {
                        self?.userDetails = getUserDetails
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
    
    func validateUserInputs(user: UserRegister) -> [String: Any]? {
        guard let FirstName = user.userFirstName, !FirstName.isEmpty else {
            self.alertMessage = shouldEnterTheFirstName
            return nil
        }
        guard let LastName = user.userLastName, !LastName.isEmpty else {
            self.alertMessage = shouldEnterTheLastName
            return nil
        }
        guard let userEmail = user.userEmail, !userEmail.isEmpty else {
            self.alertMessage = shouldEnterTheEmailName
            return nil
        }
        guard let userpassword = user.userpassword, !userpassword.isEmpty else {
            self.alertMessage = shouldEnterThePassword
            return nil
        }
        
        guard checkTextSufficientCapitalresult(text: user.userpassword!) else {
            self.alertMessage = shouldThePasswordCapitalLatter
            return nil
        }
        
        guard checkTextSufficientSpecialresult(text: user.userpassword!) else {
            self.alertMessage = shouldThePasswordNumber
            return nil
        }
        guard let _ = user.userpassword, user.userpassword!.count >= 8 else {
            self.alertMessage = shouldThePasswordEight
            return nil
        }
        return user.toJSON()
    }
    
    func checkTextSufficientSpecialresult(text : String) -> Bool{
        
        let specialCharacterRegEx  = ".*[!&^%$#@()/]+.*"
        let texttest2 = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
        let specialresult = texttest2.evaluate(with: text)
        print("\(specialresult)")
        
        let numberRegEx  = ".*[0-9]+.*"
        let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let numberresult = texttest1.evaluate(with: text)
        print("\(numberresult)")
        return specialresult || numberresult
    }
    
    func checkTextSufficientCapitalresult(text : String) -> Bool{
        
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        let capitalresult = texttest.evaluate(with: text)
        print("\(capitalresult)")
        
        return capitalresult
    }
}
