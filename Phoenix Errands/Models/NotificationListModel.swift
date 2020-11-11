//
//  NotificationListModel.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 30/09/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class NotificationListModel: Mappable {

    var status : Int?
    var notificationArray : [NotificationList]?
    
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        
        status <- map["status"]
        notificationArray <- map["notification"]
    }
}
class NotificationList: Mappable {

    var id : Int?
    var user_id : String?
    var message : String?
    var status : String?
    var created_at : String?
    var updated_at : String?
    var notiType : String?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        
        id <- map["id"]
        user_id <- map["user_id"]
        message <- map["message"]
        status <- map["status"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        notiType <- map["type"]
    }
}
class NotificationUpdateModel: Mappable {
    
    var status : Int?
    var isNotificationUpdated : Bool?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        
        status <- map["status"]
        isNotificationUpdated <- map["isNotificationUpdated"]
    }
}
