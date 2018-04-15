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

    override func viewDidLoad() {
        super.viewDidLoad()
        getRecipePins(oauthToken: PDKClient.sharedInstance().oauthToken, callback: updateRecipes)
        if let layout = collectionView?.collectionViewLayout as? RecipesLayout {
            layout.delegate = self
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
        let boundingRect = CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
        let rect = AVMakeRect(aspectRatio: CGSize(width: photo.width, height: photo.height), insideRect: boundingRect)

        return rect.size.height
    }

    func heightForCaption(at indexPath: IndexPath, width: CGFloat) -> CGFloat {
        let recipe = recipes[indexPath.item]
        var font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption2)
        font = UIFontMetrics(forTextStyle: UIFontTextStyle.caption2).scaledFont(for: font)
//        NotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.didChangePreferredContentSize), name: UIContentSizeCategoryDidChangeNotification, object: nil)

        let captionHeight = self.textHeight(for: recipe.name ?? recipe.note, for: font, width: width)

        return captionHeight
    }

    func textHeight(for text: String, for font: UIFont, width: CGFloat) -> CGFloat {
        let nsstring = NSString(string: text)
        let maxHeight = 42.0
        let textAttributes = [NSAttributedStringKey.font: font]
        let boundingRect = nsstring.boundingRect(with: CGSize(width: width, height: CGFloat(maxHeight)), options: .usesLineFragmentOrigin, attributes: textAttributes, context: nil)

        return ceil(boundingRect.height)
    }
}
