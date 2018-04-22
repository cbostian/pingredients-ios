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
    let threshold: CGFloat = 100.0 // threshold from bottom of tableView
    var isLoadingMore = false // flag

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.delegate = self
        getRecipePins(oauthToken: Bundle.main.devEnvironment ? "devToken" : PDKClient.sharedInstance().oauthToken, callback: updateRecipes)
        if let layout = collectionView?.collectionViewLayout as? RecipesLayout {
            layout.delegate = self
        }
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;

        print("IM IN A FUNCCCC !!!!")
        if !isLoadingMore && (maximumOffset - contentOffset <= threshold) {
            // Get more data - API call
            print("I SCROLLEDD!!!!")
            self.isLoadingMore = true

            // Update UI
            DispatchQueue.main.async {
                print("I SCROLLEDD 2222222!!!!")
                //                    UICollectionView.reloadData()
                self.isLoadingMore = false
            }
        }
    }

    func updateRecipes(recipesToAdd: Array<Recipe>) {
        recipes += recipesToAdd
        self.collectionView?.reloadData()
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
        cell.post = self.recipes[indexPath.item]
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
