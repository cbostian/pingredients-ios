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
    var request = URLRequest(url: URL(string: Bundle.main.pingredientsURL + "/recipes")!)
    request.setValue(oauthToken, forHTTPHeaderField: "oauth_token")
    if cursor != "" {
        request = URLRequest(url: URL(string: Bundle.main.pingredientsURL + "/recipes"  + "?cursor=" + cursor)!)
    }
    Alamofire.request(request).responseJSON(completionHandler: {(response) in
        var recipesToAdd: Array<Recipe> = []
        print("RESPONSEE!!!   " + String(describing: response))
        do {
            print("done loading data")
            for recipe in try JSON(data: response.data!)["data"].array! {
                recipesToAdd.append(Recipe.fromJSON(recipeJSON: recipe))
            }
            cursor = try JSON(data: response.data!)["cursor"].string!
            print("CURSORRR!!!  " + cursor)
            callback(recipesToAdd)
        } catch {
            print(request)
            print(error)
        }
    })
}
