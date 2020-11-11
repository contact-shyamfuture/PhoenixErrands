//
//  IntroModel.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 02/09/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class IntroModel: Mappable {

    var status : Int?
    var message : String?
    var introductionText : String?
    var totalReview : Int?
    var averageReview : String?
    
    var privacy : String?
    var terms : String?
    
    var IntroImageArr : [IntroImageArray]?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        
        IntroImageArr <- map["introDetails.introImage"]
        introductionText <- map["introDetails.introductionText"]
        totalReview <- map["introDetails.totalReview"]
        averageReview <- map["introDetails.averageReview"]
        
        privacy <- map["introDetails.privacy"]
        terms <- map["introDetails.terms"]
    }
}
class IntroImageArray: Mappable {

    var id : Int?
    var image : String?
    var created_at : String?
    var updated_at : String?
   
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        image <- map["image"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        
    }
}

class FaqModel: Mappable {

    var status : Int?
    var faqList : [FaqList]?
   
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        faqList <- map["faqs"]
    }
}
class FaqList: Mappable {

    var question : String?
    var answer : String?
   
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        answer <- map["answer"]
        question <- map["question"]
    }
}
