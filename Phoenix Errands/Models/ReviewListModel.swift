//
//  ReviewListModel.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 01/11/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class ReviewListModel: Mappable {

    var reviewList : [ReviewList]?
    var status : Int?
    var isSuccess : Bool?
    var error : String?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    func mapping(map: Map) {
        
        status <- map["status"]
        isSuccess <- map["isSuccess"]
        reviewList <- map["reviewlist"]
        error <- map["error"]
    }
}
class ReviewList: Mappable {
    
    var  status : Int?
    var  isSuccess : Bool?
    var  id : Int?
    var  rating_to : String?
    var  rating_by : Int?
    var  rating : Int?
    var  created_at : String?
    var  updated_at : String?
    var  order_id : Int?
    var  review : String?
    var  name : String?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        
        status <- map["status"]
        isSuccess <- map["isSuccess"]
        id <- map["id"]
        rating_to <- map["rating_to"]
        rating_by <- map["rating_by"]
        rating <- map["rating"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        order_id <- map["order_id"]
        review <- map["review"]
        name <- map["name"]
    }
}
