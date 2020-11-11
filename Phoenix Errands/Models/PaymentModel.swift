//
//  PaymentModel.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 26/09/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class PaymentModel: Mappable {
    
    var status : Int?
    var isSuccess : String?
    var message : String?
    var servicerequest_id : String?
    var user_id : String?
    var provider_id : String?
    var cost : String?
    var updated_at : String?
    var created_at : String?
    var id : Int?
    var error : String?
    var client_secret : String?
    var PaymentID : String?
    
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        
        status <- map["status"]
        isSuccess <- map["isSuccess"]
        message <- map["message"]
        servicerequest_id <- map["contact.servicerequest_id"]
        user_id <- map["contact.user_id"]
        provider_id <- map["contact.provider_id"]
        cost <- map["contact.cost"]
        updated_at <- map["contact.updated_at"]
        created_at <- map["contact.created_at"]
        id <- map["contact.id"]
        error <- map["error"]
        client_secret <- map["source.client_secret"]
        PaymentID <- map["source.id"]
        
    }
}
class PaymentConfirmModel: Mappable {
    
    var status : Int?
    var message : String?
    
    
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        
        status <- map["status"]
        message <- map["message"]
        
        
    }
}
