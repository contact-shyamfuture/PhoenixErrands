//
//  UserRegister.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 28/08/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class UserRegister: Mappable {
    
    var userFirstName : String?
    var userLastName : String?
    var userEmail : String?
    var userpassword : String?
    var userPhone : String?
    var userFCMToken : String?
    var social_type : String?
    var fb_token : String?
    var google_token : String?
    var isPasswordOpen = false
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        userFirstName <- map["userFirstName"]
        userLastName <- map["userLastName"]
        userEmail <- map["userEmail"]
        userpassword <- map["userpassword"]
        userPhone <- map["userPhone"]
        userFCMToken <- map["userFCMToken"]
        
        social_type <- map["social_type"]
        fb_token <- map["fb_token"]
        google_token <- map["google_token"]
    }
}
class AddSkill: Mappable {
    
    var skillid : Int?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        skillid <- map["skillid"]
    }
}
class RemoveSkill: Mappable {
    
    var skill_id : Int?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        skill_id <- map["skill_id"]
    }
}

class AddSkillModel: Mappable {
 
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
