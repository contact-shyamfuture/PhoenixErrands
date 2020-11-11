//
//  UserResponse.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 28/08/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class UserResponse: Mappable {
    
    var status : Int?
    var isSuccess : String?
    var message : String?
    
    var errorMsg : [String]?
    
    var id : Int?
    var userFirstName : String?
    var userLastName : String?
    var email : String?
    var phone : String?
    var userFCMToken : String?
    var address : String?
    var created_at : String?
    var updated_at : String?
    var authorizationToke : String?
    var image : String?
    var stripe_cust_id : String?
    var userCardList : [UserCardList]?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        isSuccess <- map["isSuccess"]
        message <- map["message"]
        
        id <- map["userdetail.id"]
        userFirstName <- map["userdetail.userFirstName"]
        userLastName <- map["userdetail.userLastName"]
        email <- map["userdetail.email"]
        phone <- map["userdetail.phone"]
        userFCMToken <- map["userdetail.userFCMToken"]
        address <- map["userdetail.address"]
        created_at <- map["userdetail.created_at"]
        updated_at <- map["userdetail.updated_at"]
        authorizationToke <- map["userdetail.authorizationToke"]
        image <- map["userdetail.image"]
        stripe_cust_id <- map["userdetail.stripe_cust_id"]
        userCardList <- map["cards.data"]
        errorMsg <- map["error.userEmail"]
    }
}

class UserCardList: Mappable {
    
    var id : String?
    var object : String?
    var address_city : String?
    var address_country : String?
    var address_line1 : String?
    var address_line1_check : String?
    var address_line2 : String?
    var address_state : String?
    var address_zip : String?
    var address_zip_check : String?
    var brand : String?
    var country : String?
    var customer : String?
    var cvc_check : String?
    var dynamic_last4 : String?
    var exp_month : Int?
    var exp_year : Int?
    var fingerprint : String?
    var funding : String?
    var last4 : String?
    var metadata : String?
    var name : String?
    var tokenization_method : String?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        object <- map["object"]
        address_city <- map["address_country"]
        address_country <- map["userdetail.id"]
        address_line1 <- map["address_line1"]
        address_line1_check <- map["address_line1_check"]
        address_line2 <- map["address_line2"]
        address_state <- map["address_state"]
        address_zip <- map["address_zip"]
        address_zip_check <- map["address_zip_check"]
        brand <- map["brand"]
        country <- map["country"]
        customer <- map["customer"]
        cvc_check <- map["cvc_check"]
        dynamic_last4 <- map["dynamic_last4"]
        
        exp_month <- map["exp_month"]
        exp_year <- map["exp_year"]
        fingerprint <- map["fingerprint"]
        funding <- map["funding"]
        last4 <- map["last4"]
        metadata <- map["metadata"]
        name <- map["name"]
        tokenization_method <- map["tokenization_method"]
    }
}
