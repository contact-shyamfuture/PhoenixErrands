//
//  APIConstants.swift
//  LastingVideoMemories
//
//  Created by on 05/10/18.
//  Copyright © 2018 iOS Dev. All rights reserved.
//

import Foundation
class APIConstants: NSObject {
    
    
//    static let baseURL = "http://phoenix.smtechnoservice.com/api/"
    static let baseURL = "http://phoenixerrands.com/public/api/"
    
//    static let baseImageURL = "http://phoenix.smtechnoservice.com/"
    static let baseImageURL = "http://phoenixerrands.com/public/"
    
    static let introURL = "introduction"
    static let loginURL = "userlogin"
    static let registerURL = "userregister"
    static let categoryURL = "category"
    static let subCategoryURL = "subcategory/"
    static let serviceURl = "servicebysubcategory/"
    static let skillURl = "skill/"
    static let allSkillURl = "skill"
    static let contactURl = "contact"
    static let questionAnswerURl = "questionsets/"
    static let postServiceURl = "searching"
    static let forgotPasswordURl = "forgetpassword"
    static let mypostedserviceURl = "mypostedservice"
    static let mypostedserviceProposalListURl = "getproposal/"
    static let mypostedserviceProposalCancelURl = "rejectmypostedservice/"
    
    static let searvicenearmeURl = "searvicenearme"
    static let bidURl = "makeproposal"
    static let profileServicesURl = "myprofile"
    static let myServiceURl = "myservice"
    static let servicesDetailsURl = "mypostedservice"
    static let addressListURl = "addresslist"
    static let addressPostURl = "addaddress"
    static let providerDetails = "providerdatail/"
    static let acceptProposal = "acceptproposal"
    static let paymentURL = "payment"
    static let notificationlistURL = "notificationlist"
    static let myOrderURL = "myorder"
    
    static let mySkillURL = "myskill"
    static let addskillURL = "addskill"
    static let contactdetailsURL = "contactdetails"
    static let subcategorysearchURL = "subcategorysearch"
    static let servicesearchURL = "servicesearch"
    static let addreviewURL = "addreview"
    static let providerOngoingURL = "providermyorder"
    static let notificationUpdateURL = "updatenotificationstatus/"
    static let reviewURL = "vendorreview"
    static let ownCategoryURL = "subcategorynotification"
    static let bankDetailsURL = "providerbankdetails"
    static let serviceCompletedURL = "completeorder"
    static let removeSkillURL = "removeskill"
    static let checkExitingProviderURL = "checkservice"
    static let languagechangeURL = "languagechange"
    static let bankDetailsGETURL = "bankdetails"
    static let faqURL = "faqlist"
    static let deleteCardURL = "deletestripecard"
    static let notificationAllStatusUpdate = "updatebulknotificationstatus"
    static let stripeCharge = "stripe-charge"
    
    static func introApi() -> String {
        return baseURL + introURL
    }
    static func faqApi() -> String {
        return baseURL + faqURL
    }
    static func logInApi() -> String {
        return baseURL + loginURL
    }
    static func registerApi() -> String {
        return baseURL + registerURL
    }
    static func categoryApi() -> String {
        return baseURL + categoryURL
    }
    static func subCategoryApi() -> String {
        return baseURL + subCategoryURL
    }
    static func serviceApi() -> String {
        return baseURL + serviceURl
    }
    static func skillListApi() -> String {
        return baseURL + skillURl
    }
    static func contactListApi() -> String {
        return baseURL + contactURl
    }
    static func questionAnsweApi() -> String {
        return baseURL + questionAnswerURl
    }
    static func postServicepi() -> String {
        return baseURL + postServiceURl
    }
    static func forgotPasswordApi() -> String {
        return baseURL + forgotPasswordURl
    }
    static func mypostedserviceApi() -> String {
        return baseURL + mypostedserviceURl
    }
    static func mypostedserviceProposalListApi() -> String {
        return baseURL + mypostedserviceProposalListURl
    }
    static func mypostedserviceCancelApi() -> String {
        return baseURL + mypostedserviceProposalCancelURl
    }
    static func searvicenearmeApi() -> String {
        return baseURL + searvicenearmeURl
    }
    static func bidApi() -> String {
        return baseURL + bidURl
    }
    static func profileServicesApi() -> String {
        return baseURL + profileServicesURl
    }
    static func myServiceApi() -> String {
        return baseURL + myServiceURl
    }
    static func servicesDetailsApi() -> String {
        return baseURL + servicesDetailsURl
    }
    static func addressListAPI() -> String {
        return baseURL + addressListURl
    }
    static func addressPostAPI() -> String {
        return baseURL + addressPostURl
    }
    static func providerDetailsAPI() -> String {
        return baseURL + providerDetails
    }
    static func acceptProposalAPI() -> String {
        return baseURL + acceptProposal
    }
    static func paymentAPI() -> String {
        return baseURL + paymentURL
    }
    static func notificationAPI() -> String {
        return baseURL + notificationlistURL
    }
    static func myOrderAPI() -> String {
        return baseURL + myOrderURL
    }
    static func mySkillAPI() -> String {
        return baseURL + mySkillURL
    }
    static func allSkillAPI() -> String {
        return baseURL + allSkillURl
    }
    static func addSkillAPI() -> String {
        return baseURL + addskillURL
    }
    static func contactdetailsAPI() -> String {
        return baseURL + contactdetailsURL
    }
    static func subcategorysearchAPI() -> String {
        return baseURL + subcategorysearchURL
    }
    static func servicesearchAPI() -> String {
        return baseURL + servicesearchURL
    }
    
    static func checkExistingProviderAPI() -> String {
        return baseURL + checkExitingProviderURL
    }
    static func AddreviewAPI() -> String {
        return baseURL + addreviewURL
    }
    static func ProviderOngoingServiceAPI() -> String {
        return baseURL + providerOngoingURL
    }
    static func NotificationUpdateAPI() -> String {
        return baseURL + notificationUpdateURL
    }
    static func NotificationAllUpdateAPI() -> String {
        return baseURL + notificationAllStatusUpdate
    }
    static func reviewsListAPI() -> String {
        return baseURL + reviewURL
    }
    static func createOwnCategoryAPI() -> String {
        return baseURL + ownCategoryURL
    }
    static func saveVendorBankAPI() -> String {
        return baseURL + bankDetailsURL
    }
    static func serviceCompletdAPI() -> String {
        return baseURL + serviceCompletedURL
    }
    static func removeSkillAPI() -> String {
        return baseURL + removeSkillURL
    }
    static func languageUpdateAPI() -> String {
        return baseURL + languagechangeURL
    }
    static func bankDetailsGETAPI() -> String {
        return baseURL + bankDetailsGETURL
    }
    
    static func deleteCardAPI() -> String {
        return baseURL + deleteCardURL
    }
    static func confirmPaymentAPI() -> String {
        return baseURL + stripeCharge
    }
    
}


