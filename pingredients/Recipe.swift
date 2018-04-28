//
//  Recipe.swift
//  pingredients
//
//  Created by Catherine Bostian on 1/26/18.
//  Copyright © 2018 Catherine Bostian. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire

class Recipe {
    var note: String
    var description: String?
    var name: String?
    var image: RecipeImage
    var original_link: URL
    var id: String
    var ingredients: Dictionary<String, [Ingredient]>
    var servings: Int?
    var board: String
    var making: Bool

    init(
        note: String,
        description: String?,
        name: String?,
        image: RecipeImage,
        original_link: URL,
        id: String,
        ingredients: Dictionary<String, [Ingredient]>,
        servings: Int?,
        board: String,
        making: Bool
        ) {
        self.note = note
        self.description = description
        self.name = name
        self.image = image
        self.original_link = original_link
        self.id = id
        self.ingredients = ingredients
        self.servings = servings
        self.board = board
        self.making = making
    }

    static func fromJSON(recipeJSON: JSON) -> Recipe {
        return Recipe(
            note: recipeJSON["note"].string!,
            description: recipeJSON["metadata"]["article"]["description"].string,
            name: recipeJSON["metadata"]["article"]["name"].string,
            image: RecipeImage(
                url: recipeJSON["image"]["original"]["url"].string!,
                height: recipeJSON["image"]["original"]["height"].int!,
                width: recipeJSON["image"]["original"]["width"].int!
            ),
            original_link: recipeJSON["original_link"].url!,
            id: recipeJSON["id"].string!,
            ingredients: Ingredient.ingredientsFromJSON(ingredientsJSON: recipeJSON["metadata"]["recipe"]["ingredients"].array!),
            servings: recipeJSON["metadata"]["servings"]["serves"].int,
            board: recipeJSON["board"]["name"].string!,
            making: false
        )
    }
}

struct Ingredient {
    var name: String
    var amount: String?

    static func ingredientsFromJSON(ingredientsJSON: [JSON]) -> Dictionary<String, [Ingredient]> {
        var ingredientDict = Dictionary<String, Array<Ingredient>>()
        for ingredients in ingredientsJSON {
            ingredientDict[ingredients["category"].string!] = []
            for ingredient in ingredients["ingredients"].array! {
                ingredientDict[ingredients["category"].string!]!.append(
                    Ingredient(
                        name: ingredient["name"].string!,
                        amount: ingredient["amount"].string)
                )
            }
        }
        return ingredientDict
    }
}

class RecipeImage {
    var url: String
    var height: Int
    var width: Int
    var downloadedImage: UIImage?
    var observer: RecipesViewCell?

    init(
        url: String,
        height: Int,
        width: Int
        ){
        self.url = url
        self.height = height
        self.width = width
        downloadUIImage()
    }

    func downloadUIImage() {
        Alamofire.request(URLRequest(url: URL(string: url)!)).responseData(completionHandler: {(response) in
            self.downloadedImage = UIImage(data: response.data!)
            self.observer?.updateImage()
        })
    }
}
