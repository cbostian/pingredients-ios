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

class RecipesViewController : UICollectionViewController
{
    var recipes: Array<Recipe> = []
    var isLoadingMore = false
    var layout: RecipesLayout?
    var makingOnly = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.delegate = self
        getRecipePins(callback: updateRecipes)
        if let layout = collectionView?.collectionViewLayout as? RecipesLayout {
            self.layout = layout
            layout.delegate = self
        }
        NotificationCenter.default.addObserver(self, selector: #selector(ipadWasRotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(tabBarController?.selectedIndex)
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isLoadingMore && (scrollView.contentOffset.y +  (scrollView.bounds.height * 2) >= scrollView.contentSize.height) {
            getRecipePins(callback: updateRecipes)
            self.isLoadingMore = true
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if Constants.columns < 3 {
            orientationUtility.lockOrientation(.all)
        }
    }

    func updateRecipes(recipesToAdd: Array<Recipe>) {
        let minNewRecipesIndex = (self.recipes.count)
        recipes += recipesToAdd
        DispatchQueue.main.async {
            if recipesToAdd.count == self.recipes.count {
                self.collectionView?.reloadData()
            } else {
                let numberOfItems: [Int] = Array(minNewRecipesIndex...self.recipes.count - 1)
                self.collectionView?.insertItems(at: numberOfItems.map { IndexPath(item: $0, section: 0) })
                self.isLoadingMore = false
                self.layout?.attributesCache = []
                self.layout?.invalidateLayout()
            }
        }
    }

    @objc func ipadWasRotated() {
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation) && Constants.columns > 2 {
            self.layout?.attributesCache = []
            self.layout?.invalidateLayout()
        }

        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation) && Constants.columns > 2 {
            self.layout?.attributesCache = []
            self.layout?.invalidateLayout()
        }
    }
}

extension RecipesViewController
{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipesCell", for: indexPath) as! RecipesViewCell
        cell.updateUI(recipe: self.recipes[indexPath.item])
        return cell
    }
}

extension RecipesViewController : RecipesLayoutDelegate {
    func heightForPhoto(at indexPath: IndexPath, width: CGFloat) -> CGFloat {
        let recipe = recipes[indexPath.item]
        let photo = recipe.image
        let scaleFactor = width / CGFloat(photo.width)
        let height = CGFloat(photo.height) * scaleFactor

        return height
    }

    func heightForCaption(at indexPath: IndexPath, width: CGFloat) -> CGFloat {
        let recipe = recipes[indexPath.item]
        return self.textHeight(for: recipe.name ?? recipe.note, for: Constants.captionFont, width: width)
    }

    func textHeight(for text: String, for font: UIFont, width: CGFloat) -> CGFloat {
        let nsstring = NSString(string: text)
        let textAttributes = [NSAttributedStringKey.font: font]
        let boundingRect = nsstring.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: textAttributes, context: nil)

        return ceil(boundingRect.height)
    }
}
