//
//  CardSaveModel.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 10/12/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class CardSaveModel: Mappable {

    var status : Int?
    var isSuccess : Bool?
    var message : String?
    var country : String?
    var currency : String?
    var provider_id : String?
    var bank_name : String?
    var account_holder_name : String?
    var account_holder_type : String?
    var account_number : String?
    var updated_at : String?
    var created_at : String?
    var id : Int?
    var otp : Int?
   
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    func mapping(map: Map) {
        
        status <- map["status"]
        isSuccess <- map["isSuccess"]
        otp <- map["otp"]
        message <- map["message"]
        country <- map["address.country"]
        currency <- map["address.currency"]
        provider_id <- map["address.provider_id"]
        bank_name <- map["address.bank_name"]
        account_holder_name <- map["address.account_holder_name"]
        account_holder_type <- map["address.account_holder_type"]
        account_number <- map["address.account_number"]
        updated_at <- map["address.updated_at"]
        created_at <- map["address.created_at"]
        id <- map["address.id"]
    }
}
class CardGeteModel: Mappable {

    var status : Int?
    var message : String?
    
    var id : Int?
    var provider_id : Int?
    var country : String?
    var currency : String?
    var bank_name : String?
    var account_holder_name : String?
    var account_holder_type : String?
    var account_number : String?
    var created_at : String?
    var updated_at : String?
   
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    func mapping(map: Map) {
        
        status <- map["status"]
        message <- map["message"]
        id <- map["details.id"]
        provider_id <- map["details.provider_id"]
        country <- map["details.country"]
        currency <- map["details.currency"]
        bank_name <- map["details.bank_name"]
        account_holder_name <- map["details.account_holder_name"]
        account_holder_type <- map["details.account_holder_type"]
        account_number <- map["details.account_number"]
        created_at <- map["details.created_at"]
        updated_at <- map["details.updated_at"]
        
    }
}
