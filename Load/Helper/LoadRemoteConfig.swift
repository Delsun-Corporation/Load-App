//
//  LoadRemoteConfig.swift
//  Load
//
//  Created by Timotius Leonardo Lianoto on 03/07/22.
//  Copyright © 2022 Haresh Bhai. All rights reserved.
//

import Foundation
import FirebaseRemoteConfig

class LoadRemoteConfig {
    
    static func fetchRemoteConfig() {
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        
        remoteConfig.fetch { status, error in
            guard error == nil else {
                print("Cannot fetch remote config \(error)")
                return
            }
            
            print("Remote config retrieved!")
            remoteConfig.activate()
        }
    }
    
    static func startBooleanRemoteConfig(_ name: String) -> Bool {
        RemoteConfig.remoteConfig().configValue(forKey: name).boolValue
    }
}
