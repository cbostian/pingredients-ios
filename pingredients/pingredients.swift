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

var cursor = ""

func getRecipePins(callback: @escaping (Array<Recipe>) -> ()) {
    var urlArgs = ""
    if cursor != "" {
        urlArgs = "?cursor=" + cursor
    }
    makePingredientsRequest(route: "/recipes", urlArgs: urlArgs, responseHandler: {(response) in
        var recipesToAdd: Array<Recipe> = []
        do {
            for recipe in try JSON(data: response.data!)["data"].array! {
                recipesToAdd.append(Recipe.fromJSON(recipeJSON: recipe))
            }
            cursor = try JSON(data: response.data!)["cursor"].string ?? ""
            callback(recipesToAdd)
        } catch {
            print(error)
        }
    })
    
}

func createUser(callback: @escaping () -> ()) {
    makePingredientsRequest(route: "/users/", urlArgs: userID, method: "PUT", tokenOnly: true, responseHandler: {(response) in
        callback()
    })
}

func makePingredientsRequest(route: String, urlArgs: String = "", method: String = "GET", tokenOnly: Bool = false, responseHandler: @escaping (DataResponse<Any>) -> Void) {
    var request = URLRequest(url: URL(string: Bundle.main.pingredientsURL + route + urlArgs)!)
    request.setValue(oauthToken, forHTTPHeaderField: "oauth_token")
    if !tokenOnly {
        request.setValue(userID, forHTTPHeaderField: "user_id")
    }
    request.httpMethod = method
    Alamofire.request(request).responseJSON(completionHandler: {(response) in
        responseHandler(response)
    })
}
