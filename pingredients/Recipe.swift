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
    var servings: Servings
    var board: String
    var making: Bool
    var json: JSON

    init(
        note: String,
        description: String?,
        name: String?,
        image: RecipeImage,
        original_link: URL,
        id: String,
        ingredients: Dictionary<String, [Ingredient]>,
        servings: Servings,
        board: String,
        making: Bool,
        json: JSON
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
        self.json = json
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
            ingredients: Ingredient.ingredientsFromJSON(ingredientsJSON: recipeJSON["metadata"]["recipe"]["ingredients"]),
            servings: Servings (
                serves: recipeJSON["metadata"]["servings"]["serves"].float,
                yields: recipeJSON["metadata"]["servings"]["yields"].float,
                yield_units: recipeJSON["metadata"]["servings"]["yield_units"].string
            ),
            board: recipeJSON["board"]["name"].string!,
            making: recipeJSON["making"].bool!,
            json: recipeJSON
        )
    }
}

struct Ingredient {
    var name: String
    var unit: String?
    var amount: String?

    static func ingredientsFromJSON(ingredientsJSON: JSON) -> Dictionary<String, [Ingredient]> {
        var ingredientDict = Dictionary<String, Array<Ingredient>>()
        for (category, ingredients) in ingredientsJSON {
            ingredientDict[category] = []
            for ingredient in ingredients.array! {
                ingredientDict[category]!.append(Ingredient(name: ingredient["name"].string!, unit: ingredient["unit"].string, amount: ingredient["amount"].string))
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

    init(
        url: String,
        height: Int,
        width: Int
        ){
        self.url = url
        self.height = height
        self.width = width
    }
}

class Servings {
    var serves: Float?
    var yields: Float?
    var yield_units: String?

    init(
        serves: Float?,
        yields: Float?,
        yield_units: String?
        ){
        self.serves = serves
        self.yields = yields
        self.yield_units = yield_units
    }
}
