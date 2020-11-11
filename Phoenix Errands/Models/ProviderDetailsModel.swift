//
//  ProviderDetailsModel.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 25/09/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class ProviderDetailsModel: Mappable {

    var status : Int?
    var questionsetListArray : [ProviderQuestionSetModel]?
    var contactID : Int?
    var contactName : String?
    var contactImage : String?
    var contactAddress : String?
    var contactTotalRating : String?
    var contactRating : String?
    var latlong : String?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        contactID <- map["providerdetails.contactID"]
        contactName <- map["providerdetails.contactName"]
        contactImage <- map["providerdetails.contactImage"]
        contactAddress <- map["providerdetails.contactAddress"]
        contactTotalRating <- map["providerdetails.contactTotalRating"]
        contactRating <- map["providerdetails.contactRating"]
        questionsetListArray <- map["questionset"]
        latlong <- map["providerdetails.latlong"]
    }
}

class ProviderQuestionSetModel: Mappable {
    
    var id : Int?
    var servicerequest_id : String?
    var question_id : String?
    var answer : String?
    var created_at : String?
    var updated_at : String?
    var question : String?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        servicerequest_id <- map["servicerequest_id"]
        question_id <- map["question_id"]
        answer <- map["answer"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        question <- map["question"]
    }
}
