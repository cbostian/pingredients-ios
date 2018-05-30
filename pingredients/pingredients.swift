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

let RECIPES_ENDPOINT = "/recipes"
let USERS_ENDPOINT = "/users/"
let MAKING_RECIPES_ENDPOINT = "/making-recipes"

var cursor = ""

func getRecipePins(callback: @escaping ([Recipe]) -> ()) {
    var urlArgs = ""
    if cursor != "" {
        urlArgs = "?cursor=" + cursor
    }
    makePingredientsRequest(route: RECIPES_ENDPOINT, urlArgs: urlArgs, responseHandler: {(response) in
        let recipesToAdd = recipesFromJSON(networkResponseData: response)
        do {
            cursor = try JSON(data: response.data!)["cursor"].string ?? ""
        } catch {
            print(error)
        }
        callback(recipesToAdd)
    })
    
}

func createUser(callback: @escaping () -> ()) {
    makePingredientsRequest(route: USERS_ENDPOINT, urlArgs: userID, method: "PUT", tokenOnly: true, responseHandler: {(response) in
        callback()
    })
}

func makeRecipe(recipe: Recipe, callback: @escaping () -> ()) {
    makePingredientsRequest(route: MAKING_RECIPES_ENDPOINT, method: "POST", payload: recipe.toJson(), responseHandler: {(response) in
        callback()
    })
}

func unmakeRecipe(recipe: Recipe, recipeID: String, cell: RecipesViewCell, callback: @escaping (RecipesViewCell) -> ()) {
    makePingredientsRequest(route: MAKING_RECIPES_ENDPOINT + "/", urlArgs: recipeID, method: "DELETE", responseHandler: {(response) in
        callback(cell)
    })
}

func getMakingRecipes(callback: @escaping ([Recipe]) -> ()) {
    makePingredientsRequest(route: MAKING_RECIPES_ENDPOINT, responseHandler:{(response) in
        callback(recipesFromJSON(networkResponseData: response))
    })
}

func makePingredientsRequest(route: String, urlArgs: String = "", method: String = "GET", tokenOnly: Bool = false, payload: JSON = JSON.null, responseHandler: @escaping (DataResponse<Any>) -> Void) {
    var request = URLRequest(url: URL(string: Bundle.main.pingredientsURL + route + urlArgs)!)
    request.setValue(oauthToken, forHTTPHeaderField: "oauth_token")
    if !tokenOnly {
        request.setValue(userID, forHTTPHeaderField: "user_id")
    }
    request.httpMethod = method
    if method == "POST" && payload != JSON.null {
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        print(payload.rawValue)
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload.rawValue)
        } catch {
            print(error)
        }
    }
    Alamofire.request(request).responseJSON(completionHandler: {(response) in
        responseHandler(response)
    })
}

func recipesFromJSON(networkResponseData: DataResponse<Any>) -> [Recipe] {
    var recipes: [Recipe] = []
    do {
        for recipe in try JSON(data: networkResponseData.data!)["data"].array! {
            recipes.append(Recipe.fromJSON(recipeJSON: recipe))
        }
    } catch {
        print(error)
    }
    return recipes
}
