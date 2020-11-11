//
//  ProviderServcieModel.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 11/09/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class ProviderServcieModel: Mappable {

    var status : Int?
    var serviceListArr : [ProviderServcieList]?
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        serviceListArr <- map["serviceList"]
    }
}

class ProviderServcieList: Mappable {

    var providerListArr : [ProviderList]?
    var id : Int?
    var servie_id : Int?
    var category_id : Int?
    var subcategory_id : Int?
    var serviceName : String?
    var serviceDescription : String?
    var serviceAddress : String?
    var created_at : String?
    var updated_at : String?
        
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        servie_id <- map["id"]
        category_id <- map["category_id"]
        subcategory_id <- map["subcategory_id"]
        serviceName <- map["serviceName"]
        serviceDescription <- map["serviceDescription"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        serviceAddress <- map["serviceAddress"]
        providerListArr <- map["provider"]
    }
}

class ProviderList: Mappable {
    
    var contactID : Int?
    var contactName : String?
    var contactImage : String?
    var contactTotalRating : Int?
    var contactRating : String?
    var contactAddress : String?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        contactID <- map["contactID"]
        contactName <- map["contactName"]
        contactImage <- map["contactImage"]
        contactTotalRating <- map["contactTotalRating"]
        contactRating <- map["contactRating"]
        contactAddress <- map["contactAddress"]
    }
}
