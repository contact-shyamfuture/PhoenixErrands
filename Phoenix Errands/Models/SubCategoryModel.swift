//
//  SubCategoryModel.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 29/08/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class SubCategoryModel: Mappable {
    
    var status : Int?
    var total : Int?
    var message : String?
    var perPage : Int?
    
    var subCategoryArray : [SubCategoryList]?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        total <- map["total"]
        message <- map["message"]
        perPage <- map["perPage"]
        subCategoryArray <- map["subcategoryList"]
        
    }
}

class SubCategoryList: Mappable {
    
    var id : Int?
    var category_id : String?
    var subcategoryName : String?
    var subcategoryDescription : String?
    var subcategoryIcon : String?
    var subcategorylocation : String?
    var created_at : String?
    var updated_at : String?
    
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        category_id <- map["category_id"]
        subcategoryName <- map["subcategoryName"]
        subcategoryDescription <- map["subcategoryDescription"]
        subcategoryIcon <- map["subcategoryIcon"]
        subcategorylocation <- map["subcategorylocation"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
    }
}



class CreateOwnCategoryModel: Mappable {
 
    
    var status : Int?
    var notificationUpdate : Bool?
    var message : String?
    
    var subCategoryArray : [SubCategoryList]?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        notificationUpdate <- map["notificationUpdate"]
        message <- map["message"]
    }
}


class languageModel: Mappable {

    var status : Int?
    var isSuccess : Bool?
        
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        isSuccess <- map["isSuccess"]
    }
}
