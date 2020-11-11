//
//  NearestServiceModel.swift
//  Phoenix Errands
//
//  Created by Raghav Beriwala on 10/09/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class NearestServiceModel: Mappable {
    
    var status  : Int?
    var total   : Int?
    var message : String?
    var perPage : Int?
    var serviceNearMeList : [ServiceNearMeList]?
    
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        total <- map["total"]
        perPage <- map["perPage"]
        serviceNearMeList <- map["serviceList"]
    }
}

class ServiceNearMeList: Mappable
{
    var id: String?
    var category_id: String?
    var subcategory_id: String?
    var serviceName: String?
    var serviceDescription: String?
    var created_at: String?
    var updated_at: String?
    var serviceAddress: String?
    var isbid: String?
    var requestid: Int?
    var bidamount : String?
    var type : String?
    
    init() {}
    required init?(map: Map)
    {
        mapping(map: map)
    }
    func mapping(map: Map)
    {
        id <- map["id"]
        category_id <- map["category_id"]
        subcategory_id <- map["subcategory_id"]
        serviceName <- map["serviceName"]
        serviceDescription <- map["serviceDescription"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        serviceAddress <- map["serviceAddress"]
        isbid <- map["isbid"]
        requestid <- map["requestid"]
        bidamount <- map["bidamount"]
        type <- map["type"]
    }
}
