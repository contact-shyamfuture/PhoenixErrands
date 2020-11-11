//
//  AddressListModel.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 24/09/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class AddressListModel: Mappable {

    var status : Int?
    var AddressListArray : [AddressList]?
    var isSuccess : String?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        isSuccess <- map["isSuccess"]
        AddressListArray <- map["address"]
    }
}
class AddressList: Mappable {
    
    var id : Int?
    var user_id : String?
    var title : String?
    var latlong : String?
    var zipcode : String?
    var phone : String?
    var fulladress : String?
    var created_at : String?
    var updated_at : String?
    var isSelected : Bool?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        user_id <- map["user_id"]
        title <- map["title"]
        latlong <- map["latlong"]
        zipcode <- map["zipcode"]
        phone <- map["phone"]
        fulladress <- map["fulladress"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        isSelected = false
    }
}


class AddressPostModel: Mappable {
    
    var status : Int?
    var message : String?
    var isSuccess : String?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        isSuccess <- map["isSuccess"]
        message <- map["message"]
    }
}
