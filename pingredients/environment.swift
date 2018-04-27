//
//  environment.swift
//  pingredients
//
//  Created by Jimmy Burgess on 4/22/18.
//  Copyright © 2018 Catherine Bostian. All rights reserved.
//

import Foundation

public extension Bundle {
    var pingredientsURL: String {
        return object(forInfoDictionaryKey: "pingredientsURL") as? String ?? ""
    }
    
    var devEnvironment: Bool {
        return object(forInfoDictionaryKey: "devEnvironment") as? Bool ?? false
    }
}

var userID = "dev_user_id"

var oauthToken = "dev_token"
