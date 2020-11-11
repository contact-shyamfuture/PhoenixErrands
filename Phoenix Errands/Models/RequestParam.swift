//
//  RequestParam.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 05/09/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class RequestParam: Mappable {

    var serviceid : Int?
    var zipcode : String?
    var address : String?
    var latlong : String?
    var delivery_date : String?
    var image : String?
    var QuestionAnswer = [QuestionAnswerParam]()
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        serviceid <- map["serviceid"]
        zipcode <- map["zipcode"]
        address <- map["address"]
        latlong <- map["latlong"]
        delivery_date <- map["delivery_date"]
        QuestionAnswer <- map["questionSet"]
        image <- map["image"]
    }
}

class QuestionAnswerParam: Mappable {
    
    
    var questionid : String?
    var answerList : String?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        questionid <- map["questionid"]
        answerList <- map["answerList"]
    }
}
