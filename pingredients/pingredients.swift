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

#if DEVELOPMENT
    let baseURLString = "http://localhost:8080"
#else
    let baseURLString = "https://pingredients-192501.appspot.com"
#endif

func getRecipePins(oauthToken: String, callback: @escaping (Array<Recipe>) -> ()) {
    var request = URLRequest(url: URL(string: baseURLString + "/recipes")!)
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
