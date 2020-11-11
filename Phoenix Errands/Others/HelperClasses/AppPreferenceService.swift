//
//  AppPreferenceService.swift
//  LastingVideoMemories
//
//  Created by  Software Llp on 02/11/18.
//  Copyright © 2018 iOS Dev. All rights reserved.
//

import Foundation
class AppPreferenceService {
    
    static func setString( _ value:String , key:String){
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    static func getString( _ key:String)-> String?{
        let defaults  = UserDefaults.standard
        if  let value = defaults.string(forKey: key) {
            return value
        }
        return nil
    }
    
    static func removeString( _ key:String)-> String?{
        let defaults  = UserDefaults.standard
        defaults.removeObject(forKey: key)
        return nil
    }
    
    static func setObjects( _ value:AnyObject, key:String){
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    static func getObjects( _ key:String)->AnyObject?{
        if let value = UserDefaults.standard.string(forKey: key) {
            return value as AnyObject?
        }
        return nil
    }
    
    static func setInteger( _ value:Int , key:String){
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    static func getInteger( _ key:String)-> Int{
        let defaults  = UserDefaults.standard
        let value = defaults.integer(forKey: key)
        return value
    }
}
