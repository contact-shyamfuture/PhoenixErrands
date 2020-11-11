//
//  ContactModel.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 02/09/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class ContactModel: Mappable {

    var status : Int?
    var message : String?
    var contactArr : [ContactList]?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        contactArr <- map["contactList"]
    }
}

class ContactList: Mappable {
    
    var contactID : Int?
    var contactName : String?
    var contactImage : String?
    var contactTotalRating : Int?
    var contactRating : String?
    var contactNumber : Int?
    var service_id : Int?
    
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
        contactNumber <- map["contactPhone"]
        service_id <- map["service_id"]
    }
}

class ContactDetailsModel: Mappable {
    var contactID : Int?
    var contactName : String?
    var contactImage : String?
    var contactTotalRating : Int?
    var contactRating : String?
    var status : Int?
    var message : String?
    var contactNumber : Int?
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        contactID <- map["contactList.contactID"]
        contactName <- map["contactList.contactName"]
        contactImage <- map["contactList.contactImage"]
        contactTotalRating <- map["contactList.contactTotalRating"]
        contactRating <- map["contactList.contactRating"]
        contactNumber <- map["contactList.contactPhone"]
    }
}
