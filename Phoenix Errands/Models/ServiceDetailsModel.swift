//
//  ServiceDetailsModel.swift
//  Phoenix Errands
//
//  Created by Raghav Beriwala on 11/09/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//


import UIKit
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class ServiceDetailsModel: Mappable {
    
    var status : Int?
    var message : String?
    var total : Int?
    var perPage : Int?
    var image : String?
    var latlong : String?
    var created_at : String?
    var service : Service?
    var Questionset : [Questionset]?
    //var proposalListArr : [ProposalList]?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        total <- map["total"]
        message <- map["message"]
        perPage <- map["perPage"]
        service <- map["service"]
        Questionset <- map["questionset"]
        image <- map["image"]
        latlong <- map["latlong"]
        created_at <- map["created_at"]
    }
}


class Service: Mappable {
    
    var id : Int?
    var category_id : String?
    var subcategory_id : String?
    var serviceName : String?
    var serviceDescription : String?
    var created_at : String?
    var updated_at : String?
    var serviceAddress : String?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        category_id <- map["category_id"]
        subcategory_id <- map["subcategory_id"]
        serviceName <- map["serviceName"]
        serviceDescription <- map["serviceDescription"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        serviceAddress <- map["serviceAddress"]
    }
}

class Questionset: Mappable {
    
    var id                :Int?
    var servicerequest_id :String?
    var question_id       :String?
    var answer            :String?
    var created_at        :String?
    var updated_at        :String?
    var question          :String?
    var answer_Array : [String]?
    
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map)
    {
        id <- map["id"]
        servicerequest_id <- map["servicerequest_id"]
        question_id <- map["question_id"]
        answer <- map["answer"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        question <- map["question"]
        answer_Array <- map["json_answer"]
    }
}

class AcceptProposalParam: Mappable {
    
    var proposal_id : Int?
    var stripeToken : String?
    var contactid : Int?
    
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map){
        proposal_id <- map["proposal_id"]
        stripeToken <- map["stripeToken"]
        contactid <- map["contact_id"]
    }
}

class DeleteCardParam: Mappable {
    
    var card_id : String?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map){
        card_id <- map["card_id"]
    }
}
class ConfirmPaymentParam: Mappable {
    
    var contact_id : Int?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map){
        contact_id <- map["contact_id"]
    }
}
