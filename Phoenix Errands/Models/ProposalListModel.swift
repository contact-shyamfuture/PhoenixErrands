//
//  ProposalListModel.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 10/09/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class ProposalListModel: Mappable {

    var status : Int?
    var message : String?
    var total : Int?
    var perPage : Int?
    
    var id : Int?
    var category_id : String?
    var subcategory_id : String?
    var serviceName : String?
    var serviceDescription : String?
    var created_at : String?
    var updated_at : String?
    var serviceAddress : String?
    
    var proposalListArr : [ProposalList]?
    
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        total <- map["total"]
        message <- map["message"]
        perPage <- map["perPage"]
        
        id <- map["service.id"]
        category_id <- map["service.category_id"]
        subcategory_id <- map["service.subcategory_id"]
        serviceName <- map["service.serviceName"]
        serviceDescription <- map["service.serviceDescription"]
        created_at <- map["service.created_at"]
        updated_at <- map["service.updated_at"]
        serviceAddress <- map["service.serviceAddress"]
        proposalListArr <- map["proposalsList"]
    }
}


class ProposalList: Mappable {

    var id : Int?
    var providerId : Int?
    var providerName : String?
    var providerImage : String?
    var proposalStatus : String?
    var proposalPrice : String?
    var providerRating : Int?
    var providerTotalRating : Int?
    var proposalDateTime : String?
    var proposalType : String?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        providerName <- map["providerName"]
        providerImage <- map["providerImage"]
        proposalStatus <- map["proposalStatus"]
        proposalPrice <- map["proposalPrice"]
        providerRating <- map["providerRating"]
        providerTotalRating <- map["providerTotalRating"]
        proposalDateTime <- map["proposalDateTime"]
        providerId <- map["providerId"]
        proposalType <- map["proposalType"]
    }
}


class CancelRequestResponse: Mappable {

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
