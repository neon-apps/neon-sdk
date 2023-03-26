//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 26.03.2023.
//

import Foundation
import FirebaseRemoteConfig

public class RemoteConfigManager{
    
    public static let shared = RemoteConfigManager()
    
    public func configureRemoteConfig(defaultValues : [String : NSObject]){
        
        setRemoteConfigDefaults(defaultValues: defaultValues)
        fetchRemoteConfigValues()

    }
    
    func setRemoteConfigDefaults(defaultValues : [String : NSObject]){
        
        RemoteConfig.remoteConfig().setDefaults(defaultValues)
        
    }
    
    func fetchRemoteConfigValues(){
        RemoteConfig.remoteConfig().fetch{ (status, error) in
            guard error == nil else{
                print(error?.localizedDescription ?? "" )
                return
            }
            RemoteConfig.remoteConfig().activate { changed, error in
              
            }
        }
    }
    
    public func getRemoteConfigValue(key : String) -> String{
        if let stringValue = RemoteConfig.remoteConfig().configValue(forKey: key).stringValue{
            UserDefaults.standard.setValue(stringValue, forKey: key)
            return stringValue
        }else{
            return UserDefaults.standard.string(forKey: key) ?? ""
        }
    }
    
    public func getRemoteConfigValue(key : String) -> Int{
        if let integerValue = RemoteConfig.remoteConfig().configValue(forKey: key).numberValue as? Int{
            UserDefaults.standard.setValue(integerValue, forKey: key)
            return integerValue
        }else{
            return UserDefaults.standard.integer(forKey: key)
        }
    }
    
    public func getRemoteConfigValue(key : String) -> Double{
        if let doubleValue = RemoteConfig.remoteConfig().configValue(forKey: key).numberValue as? Double{
            UserDefaults.standard.setValue(doubleValue, forKey: key)
            return doubleValue
        }else{
            return UserDefaults.standard.double(forKey: key)
        }
    }
    
    public func getRemoteConfigValue(key : String) -> Bool{
        let boolValue = RemoteConfig.remoteConfig().configValue(forKey: key).boolValue
        UserDefaults.standard.setValue(boolValue, forKey: key)
        return boolValue
        
    }
    
    public func getRemoteConfigValue(key : String) -> [String : Any]{
        if let dictionaryValue = RemoteConfig.remoteConfig().configValue(forKey: key).jsonValue as? [String : Any]{
            UserDefaults.standard.setValue(dictionaryValue, forKey: key)
            return dictionaryValue
        }else{
            return UserDefaults.standard.dictionary(forKey: key) ?? Dictionary()
        }
    }
    
    public func getRemoteConfigValue(key : String) -> [Any]{
        if let arrayValue = RemoteConfig.remoteConfig().configValue(forKey: key).jsonValue as? [Any]{
            UserDefaults.standard.setValue(arrayValue, forKey: key)
            return arrayValue
        }else{
            return UserDefaults.standard.array(forKey: key) ?? []
        }
    }
    
    public func getRemoteConfigValue(key : String) -> Data{
        let dataValue = RemoteConfig.remoteConfig().configValue(forKey: key).dataValue
        UserDefaults.standard.setValue(dataValue, forKey: key)
        return dataValue
    }
    
}
