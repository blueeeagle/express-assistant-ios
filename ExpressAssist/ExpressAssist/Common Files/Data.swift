//
//  Data.swift
//  RodeoHorse
//
//  Created by MACMINI1 on 22/09/17.
//  Copyright © 2017 Udaan. All rights reserved.
//

import Foundation

class AppData {

   public var name:String
   {
        get {
           
            let name = UserDefaults.standard.string(forKey: "name")
            if name != nil {
                return name!
            }
            else{
                return ""
            }
          
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "name")
            defaults.synchronize()
        }
    }
    public var lastName:String
    {
        get {
            
            let lastName = UserDefaults.standard.string(forKey: "last_name")
            if lastName != nil {
                return lastName!
            }
            else{
                return ""
            }
     
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "last_name")
            defaults.synchronize()
        }
    }

    public var username:String
    {
        get {
            let userName = UserDefaults.standard.string(forKey: "username")
            if userName != nil {
                return userName!
            }
            else{
                return ""
            }
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "username")
            defaults.synchronize()
        }
    }
    public var email:String
    {
        get {
            let email = UserDefaults.standard.string(forKey: "email")
            if email != nil {
                return email!
            }
            else{
                return ""
            }
           
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "email")
            defaults.synchronize()
        }
    }
    
    public var phone:String
    {
        get {
            
            let mobile = UserDefaults.standard.string(forKey: "mobile")
            if mobile != nil {
                return mobile!
            }
            else{
                return ""
            }
        
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "mobile")
            defaults.synchronize()
        }
    }
    public var checkPaid:String
    {
        get {
            let checkPaid = UserDefaults.standard.string(forKey: "is_paid")
            if checkPaid != nil {
                return checkPaid!
            }
            else{
                return ""
            }
            
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "is_paid")
            defaults.synchronize()
        }
    }
    
    public var ID:String
    {
        get {
            let ID = UserDefaults.standard.string(forKey: "user_id")
            if ID != nil {
                return ID!
            }
            else{
                return ""
            }
            
            
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "user_id")
            defaults.synchronize()
        }
    }
    
    public var UserRole:String
    {
        get {
            let UserRole = UserDefaults.standard.string(forKey: "role_name")
            if UserRole != nil {
                return UserRole!
            }
            else{
                return ""
            }
            
            
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "role_name")
            defaults.synchronize()
        }
    }
    
    public var userprofileImage:String
    {
        get {
            let photo = UserDefaults.standard.string(forKey: "photo")
            if photo != nil {
                return photo!
            }
            else{
                return ""
            }
            
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "photo")
            defaults.synchronize()
        }
    }
    
    public var vehicleNumber:String
    {
        get {
            let specialization = UserDefaults.standard.string(forKey: "vehicle_number")
            if specialization != nil {
                return specialization!
            }
            else{
                return ""
            }
            
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "vehicle_number")
            defaults.synchronize()
        }
    }
    
    public var address:String
    {
        get {
            let address = UserDefaults.standard.string(forKey: "address")
            if address != nil {
                return address!
            }
            else{
                return ""
            }
            
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "address")
            defaults.synchronize()
        }
    }
    
    public var state:String
    {
        get {
            let state = UserDefaults.standard.string(forKey: "state")
            if state != nil {
                return state!
            }
            else{
                return ""
            }
            
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "state")
            defaults.synchronize()
        }
    }
    
    public var token:String
    {
        get {
            let token = UserDefaults.standard.string(forKey: "token")
            if token != nil {
                return token!
            }
            else{
                return ""
            }
    
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "token")
            defaults.synchronize()
        }
    }
    
    public var state_registration_no:String
    {
        get {
        let sateRegistration = UserDefaults.standard.string(forKey: "state_registration_no")
        if sateRegistration != nil {
            return sateRegistration!
        }
        else{
            return ""
        }
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "state_registration_no")
            defaults.synchronize()
        }
    }
    
    public var ref_code:String
    {
        get {
            let refCode = UserDefaults.standard.string(forKey: "ref_code")
            if refCode != nil {
                return refCode!
            }
            else{
                return ""
            }
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "ref_code")
            defaults.synchronize()
        }
    }
    public var ActiveKey:Bool
    {
        get {
            return (UserDefaults.standard.bool(forKey: "ActiveKey"))
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "ActiveKey")
            defaults.synchronize()
        }
    }
    public var deviceId:String
    {
        get {
            return UserDefaults.standard.string(forKey: "deviceId")!
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "deviceId")
            defaults.synchronize()
        }
        
    }
    

    static func getDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, YYYY"
        let result = formatter.string(from: date)
        return result
    }
    
    static func getDateTime() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, YYYY HH:MM a"
        let result = formatter.string(from: date)
        return result
    }
    
    
    
}
