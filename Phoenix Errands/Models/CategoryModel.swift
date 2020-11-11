//
//  CategoryModel.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 29/08/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class CategoryModel: Mappable {

    var status : Int?
    var total : Int?
    var message : String?
    var perPage : Int?
    var notificationCount : Int?
    var categoryArray : [CategoryList]?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        total <- map["total"]
        message <- map["message"]
        perPage <- map["perPage"]
        categoryArray <- map["categoryList"]
        notificationCount <- map["notification"]
        
    }
}

class CategoryList: Mappable {
    
    var id : Int?
    var categoryName : String?
    var categoryDescription : String?
    var categoryIcon : String?
    var categorylocation : String?
    var created_at : String?
    var updated_at : String?
    
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        categoryName <- map["categoryName"]
        categoryDescription <- map["categoryDescription"]
        categoryIcon <- map["categoryIcon"]
        categorylocation <- map["categorylocation"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
    }
}
