//
//  pingredients.swift
//  pingredients
//
//  Created by Catherine Bostian on 1/21/18.
//  Copyright © 2018 Catherine Bostian. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

func getRecipePins(oauthToken: String, callback: @escaping (Array<Recipe>) -> ()) {
    var request = URLRequest(url: URL(string: Bundle.main.pingredientsURL + "/recipes")!)
    request.setValue(oauthToken, forHTTPHeaderField: "oauth_token")
    Alamofire.request(request).responseJSON(completionHandler: {(response) in
        var recipesToAdd: Array<Recipe> = []
        do {
            print("done loading data")
            for recipe in try JSON(data: response.data!)["data"].array! {
                recipesToAdd.append(Recipe.fromJSON(recipeJSON: recipe))
            }
            callback(recipesToAdd)
        } catch {
            print(request)
            print(error)
        }
    })
}

func createUser(oauthToken: String, callback: @escaping () -> ()) {
    var request = URLRequest(url: URL(string: Bundle.main.pingredientsURL + "/users/" + userID)!)
    request.httpMethod = "PUT"
    request.setValue(oauthToken, forHTTPHeaderField: "oauth_token")
    Alamofire.request(request).response(completionHandler: {(response) in
        callback()
    })
}
