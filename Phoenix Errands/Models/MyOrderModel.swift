//
//  MyOrderModel.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 30/09/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//
import UIKit
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class MyOrderModel: Mappable {

    var status : Int?
    var myOrderArray : [MyOrderList]?
    
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        
        status <- map["status"]
        myOrderArray <- map["orders"]
    }
}

class MyOrderList: Mappable {
    
    var id : Int?
    var servicerequest_id : String?
    var user_id : String?
    var provider_id : Int?
    var cost : String?
    var payment_status : Int?
    var status : Int?
    var created_at : String?
    var updated_at : String?
    var type : String?
    
    var userFirstName : String?
    var userLastName : String?
    var email : String?
    var phone : String?
    var image : String?
    
    var serviceName : String?
    var serviceDescription : String?
    var serviceID : Int?
    
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        
        id <- map["id"]
        servicerequest_id <- map["servicerequest_id"]
        user_id <- map["user_id"]
        provider_id <- map["provider_id"]
        cost <- map["cost"]
        payment_status <- map["payment_status"]
        status <- map["status"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        type <- map["type"]
        
        
        userFirstName <- map["provider.userFirstName"]
        userLastName <- map["provider.userLastName"]
        email <- map["provider.email"]
        phone <- map["provider.phone"]
        image <- map["provider.image"]
    
        serviceName <- map["service_request.service.serviceName"]
        serviceDescription <- map["service_request.service.serviceDescription"]
        serviceID <- map["service_request.service.id"]
    
    }
}
