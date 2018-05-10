//
//  BaseRecipesViewController.swift
//  pingredients
//
//  Created by Jimmy Burgess on 5/3/18.
//  Copyright © 2018 Catherine Bostian. All rights reserved.
//

import Foundation

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

class BaseRecipesViewController : UICollectionViewController
{
    var recipes: Array<Recipe> = []
    var isLoadingMore = false
    var layout: RecipesLayout?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.delegate = self
        loadRecipes()
        if let layout = collectionView?.collectionViewLayout as? RecipesLayout {
            self.layout = layout
            layout.delegate = self
        }
        NotificationCenter.default.addObserver(self, selector: #selector(ipadWasRotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    func loadRecipes() {
        preconditionFailure("This method must be overridden")
    }
    
    func unmakeCallback(cell: RecipesViewCell) {
        return
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

extension BaseRecipesViewController
{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipesCell", for: indexPath) as! RecipesViewCell
        cell.unmakeCallback = unmakeCallback
        cell.updateUI(recipe: self.recipes[indexPath.item])
        return cell
    }
}

extension BaseRecipesViewController : RecipesLayoutDelegate {
    func heightForPhoto(at indexPath: IndexPath, width: CGFloat) -> CGFloat {
        let recipe = recipes[indexPath.item]
        let photo = recipe.image
        let scaleFactor = width / CGFloat(photo.width)
        return CGFloat(photo.height) * scaleFactor
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
    
    func numberOfItems() -> Int {
        return recipes.count
    }
}
