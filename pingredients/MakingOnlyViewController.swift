//
//  RecipesViewController.swift
//  pingredients
//
//  Created by Catherine Bostian on 1/24/18.
//  Copyright © 2018 Catherine Bostian. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import PinterestSDK

class MakingOnlyViewController : BaseRecipesViewController
{
    func overwriteRecipes(newRecipes: [Recipe]) {
        recipes = newRecipes
        collectionView?.reloadData()
        layout?.invalidateLayout()
    }
    
    override func loadRecipes() {
        getMakingRecipes(callback: overwriteRecipes)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadRecipes()
    }
    
    override func unmakeCallback(cell: RecipesViewCell) {
        let index = (collectionView?.indexPath(for: cell))!
        recipes.remove(at: index.item)
        unmakeInRecipesController(recipeID: cell.post.id)
        collectionView?.performBatchUpdates({
            layout?.invalidateLayout()
            collectionView?.deleteItems(at: [index])
        }, completion: nil)
    }
    
    func unmakeInRecipesController(recipeID: String) {
        for (index, recipe) in recipesViewController!.recipes.enumerated() {
            if recipe.id == recipeID {
                recipe.making = false
                if let recipesCell = recipesViewController!.collectionView!.cellForItem(at: IndexPath(item: index, section: 0)) as? RecipesViewCell {
                    recipesCell.setAddOrRemoveColor()
                }
                return
            }
        }
    }
}
