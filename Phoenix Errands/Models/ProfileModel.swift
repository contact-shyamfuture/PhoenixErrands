//
//  ProfileModel.swift
//  Phoenix Errands
//
//  Created by Raghav Beriwala on 07/09/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//


import UIKit
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class ProfileModel: Mappable {
    
    var status  : Int?
    var total   : Int?
    var message : String?
    var perPage : Int?
    var ProfileDetails : ProfileDetails?
    var ProfileActivity : ProfileActivity?
    var MyStatistics : MyStatistics?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        total <- map["total"]
        perPage <- map["perPage"]
        ProfileDetails <- map["profileDetails"]
        ProfileActivity <- map["profileActivity"]
        MyStatistics <- map["myStatistics"]
    }
}

class ProfileDetails: Mappable
{
    var profileName   :String?
    var profileImage  :String?
    var profileAddress:String?
    var profilePhone  :String?
    var profileStatus :String?
    
    var id : Int?
    var userFirstName : String?
    var userLastName : String?
    var email : String?
    var phone = Int()
    var userFCMToken : String?
    var created_at : String?
    var updated_at : String?
    var image : String?
    var is_active : String?
    var is_delete : String?
    var bought : Int?
    var sold : Int?
    var stringPhone = String()
    
    var userCardList : [UserCardList]?
    
    init() {}
    required init?(map: Map)
    {
        mapping(map: map)
    }
    func mapping(map: Map){
        profileName <- map["profileName"]
        profileImage <- map["profileImage"]
        profileAddress <- map["profileAddress"]
        profilePhone <- map["profilePhone"]
        profileStatus <- map["profileStatus"]
        id <- map["id"]
        userFirstName <- map["userFirstName"]
        userLastName <- map["userLastName"]
        email <- map["email"]
        phone <- map["phone"]
        stringPhone <- map["phone"]
        userFCMToken <- map["userFCMToken"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        image <- map["image"]
        is_active <- map["is_active"]
        is_delete <- map["is_delete"]
        bought <- map["bought"]
        sold <- map["sold"]
        userCardList <- map["cards.data"]
    }
}

class ProfileActivity: Mappable
{
    var mission:String?
    var serviceProvided:String?
    var soldItem:String?
    init() {}
    required init?(map: Map)
    {
        mapping(map: map)
    }
    func mapping(map: Map)
    {
        mission <- map["mission"]
        serviceProvided <- map["serviceProvided"]
        soldItem <- map["soldItem"]
    }
}
class MyStatistics: Mappable
{
    var responseTime:String?
    
    init() {}
    required init?(map: Map)
    {
        mapping(map: map)
    }
    func mapping(map: Map)
    {
        responseTime <- map["responseTime"]
    }
}

