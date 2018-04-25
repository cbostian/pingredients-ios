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

func getRecipePins(oauthToken: String, callback: @escaping (Array<Recipe>) -> ()) {
    var urlArgs = ""
    if cursor != "" {
        urlArgs = "?cursor=" + cursor
    }
    var request = URLRequest(url: URL(string: Bundle.main.pingredientsURL + "/recipes" + urlArgs)!)
    request.setValue(oauthToken, forHTTPHeaderField: "oauth_token")
    Alamofire.request(request).responseJSON(completionHandler: {(response) in
        var recipesToAdd: Array<Recipe> = []
        do {
            for recipe in try JSON(data: response.data!)["data"].array! {
                recipesToAdd.append(Recipe.fromJSON(recipeJSON: recipe))
            }
            cursor = try JSON(data: response.data!)["cursor"].string!
            callback(recipesToAdd)
        } catch {
            print(request)
            print(error)
        }
    })
}
