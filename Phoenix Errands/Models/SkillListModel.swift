//
//  SkillListModel.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 30/08/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class SkillListModel: Mappable {

    var status : Int?
    var total : Int?
    var message : String?
    var perPage : Int?
    var skillListArray : [SkillListListModel]?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        total <- map["total"]
        message <- map["message"]
        perPage <- map["perPage"]
        skillListArray <- map["skill"]
    }
}

class SkillListListModel: Mappable {

    var id : Int?
    var user_id : String?
    var skillName : String?
    var skillDescription : String?
    var skillIcon : String?
    var skilllocation : String?
    var created_at : String?
    var updated_at : String?
    var isSelected : Bool?
    
    var fr_skillName : String?
    var fr_skillDescription : String?
    
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        user_id <- map["user_id"]
        skillName <- map["skillName"]
        skillDescription <- map["skillDescription"]
        skillIcon <- map["skillIcon"]
        skilllocation <- map["skilllocation"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        
        fr_skillName <- map["fr_skillName"]
        fr_skillDescription <- map["fr_skillDescription"]
        
        isSelected = false
    }
}
