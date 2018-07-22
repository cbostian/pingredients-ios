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
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipesViewController = self
        collectionView?.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
    }
    
    @objc private func refresh(_ sender: Any) {
        if !isLoadingMore {
            isLoadingMore = true
            cursor = "default"
            recipes = []
            layout?.invalidateLayout()
            loadRecipes()
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isLoadingMore && (scrollView.contentOffset.y +  (scrollView.bounds.height * 2) >= scrollView.contentSize.height) {
            loadRecipes()
            self.isLoadingMore = true
        }
    }

    func updateRecipes(recipesToAdd: [Recipe]) {
        if recipesToAdd.count == 0 {
            return
        }
        let minNewRecipesIndex = (self.recipes.count)
        recipes += recipesToAdd
        if recipesToAdd.count == self.recipes.count {
            self.collectionView?.reloadData()
            self.refreshControl.endRefreshing()
            self.isLoadingMore = false
        } else {
            let numberOfItems: [Int] = Array(minNewRecipesIndex...self.recipes.count - 1)
            self.collectionView?.insertItems(at: numberOfItems.map { IndexPath(item: $0, section: 0) })
            self.isLoadingMore = false
            self.layout?.invalidateLayout()
        }
    }
    
    override func loadRecipes() {
        getRecipePins(callback: updateRecipes)
    }
}
