//
//  ServiceListModel.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 29/08/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class ServiceListModel: Mappable {

    var status : Int?
    var total : Int?
    var message : String?
    var perPage : Int?
    
    var serviceArray : [ServiceListArray]?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        total <- map["total"]
        message <- map["message"]
        perPage <- map["perPage"]
        serviceArray <- map["serviceList"]
        
    }
}
class ServiceListArray: Mappable {
   
    var id : Int?
    var category_id : String?
    var subcategory_id : String?
    var serviceName : String?
    var serviceDescription : String?
    var created_at : String?
    var updated_at : String?
    var questions : Int?

    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        category_id <- map["category_id"]
        subcategory_id <- map["subcategory_id"]
        serviceName <- map["serviceName"]
        serviceDescription <- map["serviceDescription"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        questions <- map["questions"]
    }
}


class ExitingProviderModel: Mappable {

    var status : Bool?
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
