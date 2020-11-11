//
//  UserModel.swift
//  Phoenix Errands
//
//  Created by Raghav Beriwala on 27/08/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class UserModel: Mappable {

    var userName : String?
    var userPassword : String?
    var userFCMToken : String?
    var isPasswordOpen = false
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        userName <- map["userEmail"]
        userPassword <- map["userpassword"]
        userFCMToken <- map["userFCMToken"]
    }
}
class BidParams: Mappable {
    
    var servicerequestid : Int?
    var proposalamount: Double?
    var type : Int?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        servicerequestid <- map["servicerequestid"]
        proposalamount <- map["proposalamount"]
        type <- map["type"]
        
    }
}

class ContactParams: Mappable {
    
    var contactID : Int?
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    func mapping(map: Map) {
        contactID <- map["contactID"]
    }
}

class ReviewsParams: Mappable {
    
    var vendor_id : String?
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    func mapping(map: Map) {
        vendor_id <- map["vendor_id"]
    }
}

class SubCatagorySearchParams: Mappable
{
    var searchText : String?
    var subCategoryID : Int?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        searchText <- map["searchText"]
        subCategoryID <- map["subCategoryID"]
    }
}

class ReviewParam: Mappable
{
    var order_id : Int?
    var review : String?
    var rating : Int?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        order_id <- map["order_id"]
        review <- map["review"]
        rating <- map["rating"]
    }
}

class CompletedOrderParam: Mappable
{
    var provider_id : Int?
    var contact_id : Int?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        provider_id <- map["provider_id"]
        contact_id <- map["contact_id"]
    }
}

class UserProfile: Mappable {
    
    var userFirstName : String?
    var userLastName : String?
    var userEmail : String?
    var phone : String?
    var is_changed : Int?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        userFirstName <- map["userFirstName"]
        userLastName <- map["userLastName"]
        userEmail <- map["userEmail"]
        phone <- map["phone"]
        is_changed <- map["is_changed"]
    }
}

class CreateOwnParams: Mappable {
    
    var subcategory : String?
    var user_id : String?
    var serviceDetails : String?
    var serviceType : String?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        subcategory <- map["subcategory"]
        user_id <- map["user_id"]
        serviceDetails <- map["serviceDetails"]
        serviceType <- map["serviceType"]
    }
}
class IBANParams: Mappable {
 
    var bank_name : String?
    var account_holder_name : String?
    var account_number : String?
    var provider_id  : String?
    var otp  : Int?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    func mapping(map: Map) {
        bank_name <- map["bank_name"]
        account_holder_name <- map["account_holder_name"]
        account_number <- map["account_number"]
        provider_id <- map["provider_id"]
        otp <- map["otp"]
    }
}


class ExistingProviderParam: Mappable {
    
    var service_id : Int?
    var user_id : Int?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        service_id <- map["service_id"]
        user_id <- map["user_id"]
    }
}

class LanguageParam: Mappable {
    
    var lang : String?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        lang <- map["lang"]
    }
}
