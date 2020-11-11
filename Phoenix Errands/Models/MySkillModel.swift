//
//  MySkillModel.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 01/10/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class MySkillModel: Mappable {

    var mySkillArray : [MySkillList]?
    var status : Int?
    var total : Int?
    var message : String?
    var perPage : Int?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        
        status <- map["status"]
        total <- map["total"]
        message <- map["message"]
        perPage <- map["perPage"]
        mySkillArray <- map["skill"]
    }
}
class MySkillList: Mappable {
    
    var id : Int?
    var user_id : String?
    var skill_id : Int?
    var created_at : String?
    var updated_at : String?
    
    var service_id : Int?
    var skillName : String?
    var skillDescription : String?
    var skillIcon : String?
    var isSelected : Bool?
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        
        id <- map["id"]
        user_id <- map["user_id"]
        skill_id <- map["skill_id"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        
        service_id <- map["skill.service_id"]
        skillName <- map["skill.skillName"]
        skillDescription <- map["skill.skillDescription"]
        skillIcon <- map["skill.skillIcon"]
        isSelected = false
    }
}
