//
//  AddressParamModel.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 24/09/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class AddressParamModel: Mappable {
    
    var title : String?
    var latlong : String?
    var zipcode : String?
    var phone : String?
    var fulladress : String?
    var name : String?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        title <- map["title"]
        latlong <- map["latlong"]
        zipcode <- map["zipcode"]
        phone <- map["phone"]
        fulladress <- map["fulladress"]
        name <- map["name"]
    }
}
