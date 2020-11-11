//
//  ProviderOngoingModel.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 19/10/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class ProviderOngoingModel: Mappable {

    
    var status : Int?
    var OngoingList : [ProviderOngoingList]?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        
        status <- map["status"]
        OngoingList <- map["orders"]
    }
}

class ProviderOngoingList: Mappable {
    
    
    var id : Int?
    var servicerequest_id : String?
    var user_id : String?
    var provider_id : String?
    var cost : String?
    var payment_status : Int?
    var status : String?
    var created_at : String?
    var updated_at : String?
    var type : String?
    
    var userid : Int?
    var useruserFirstName : String?
    var useruserLastName : String?
    var useremail : String?
    var userphone : String?
    var useruserFCMToken : String?
    var usercreated_at : String?
    var userupdated_at : String?
    var userimage : String?
    var useris_active : String?
    var useris_delete : String?
    
    var providerid : Int?
    var provideruserFirstName : String?
    var provideruserLastName : String?
    var provideremail : String?
    var providerphone : String?
    var provideruserFCMToken : String?
    var providercreated_at : String?
    var providerupdated_at : String?
    var providerimage : String?
    var provideris_active : String?
    var provideris_delete : String?
    
    var serviceid : String?
    var servicecategory_id : String?
    var servicesubcategory_id : String?
    var serviceserviceName : String?
    var serviceserviceDescription : String?
    var servicecreated_at : String?
    var serviceupdated_at : String?
    var serviceserviceAddress : String?
    
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
        
        userid <- map["user.id"]
        useruserFirstName <- map["user.userFirstName"]
        useruserLastName <- map["user.userLastName"]
        useremail <- map["user.email"]
        userphone <- map["user.phone"]
        useruserFCMToken <- map["user.userFCMToken"]
        usercreated_at <- map["user.created_at"]
        userupdated_at <- map["user.updated_at"]
        userimage <- map["user.image"]
        useris_active <- map["user.is_active"]
        useris_delete <- map["user.is_delete"]
        
        providerid <- map["provider.id"]
        provideruserFirstName <- map["provider.userFirstName"]
        provideruserLastName <- map["provider.userLastName"]
        provideremail <- map["provider.email"]
        providerphone <- map["provider.phone"]
        provideruserFCMToken <- map["provider.userFCMToken"]
        providercreated_at <- map["provider.created_at"]
        providerupdated_at <- map["provider.updated_at"]
        providerimage <- map["provider.image"]
        provideris_active <- map["provider.is_active"]
        provideris_delete <- map["provider.is_delete"]
        
        serviceid <- map["service_request.service.id"]
        servicecategory_id <- map["service_request.servicec.ategory_id"]
        servicesubcategory_id <- map["service_request.service.subcategory_id"]
        serviceserviceName <- map["service_request.service.serviceName"]
        serviceserviceDescription <- map["service_request.service.serviceDescription"]
        servicecreated_at <- map["service_request.service.created_at"]
        serviceupdated_at <- map["service_request.service.updated_at"]
        serviceserviceAddress <- map["service_request.service.serviceAddress"]
    }
}
