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

class RecipesViewController : BaseRecipesViewController
{
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isLoadingMore && (scrollView.contentOffset.y +  (scrollView.bounds.height * 2) >= scrollView.contentSize.height) {
            loadRecipes()
            self.isLoadingMore = true
        }
    }

    func updateRecipes(recipesToAdd: [Recipe]) {
        let minNewRecipesIndex = (self.recipes.count)
        recipes += recipesToAdd
        DispatchQueue.main.async {
            if recipesToAdd.count == self.recipes.count {
                self.collectionView?.reloadData()
            } else {
                let numberOfItems: [Int] = Array(minNewRecipesIndex...self.recipes.count - 1)
                self.collectionView?.insertItems(at: numberOfItems.map { IndexPath(item: $0, section: 0) })
                self.isLoadingMore = false
                self.layout?.invalidateLayout()
            }
        }
    }
    
    override func loadRecipes() {
        getRecipePins(callback: updateRecipes)
    }
}
