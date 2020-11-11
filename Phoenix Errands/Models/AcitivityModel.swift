//
//  AcitivityModel.swift
//  Phoenix Errands
//
//  Created by Raghav Beriwala on 06/09/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//
import UIKit
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class AcitivityModel: Mappable {
    
    var status  : Int?
    var total   : Int?
    var message : String?
    var perPage : Int?
    var serviceList : [ServiceList]?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        total <- map["total"]
        perPage <- map["perPage"]
        serviceList <- map["serviceList"]
    }
}

class ServiceList: Mappable
{
    var id                 :String?
    var serviceName        :String?
    var serviceDescription :String?
    var serviceAddress     :String?
    var created_at         :String?
    var updated_at         :String?
    var requestid : Int?
    var is_active : String?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map)
    {
        id <- map["id"]
        serviceName <- map["serviceName"]
        serviceDescription <- map["serviceDescription"]
        serviceAddress <- map["serviceAddress"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        requestid <- map["requestid"]
        is_active <- map["is_active"]
    }
}
