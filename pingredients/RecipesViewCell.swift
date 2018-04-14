//
//  RecipesViewCell.swift
//  pingredients
//
//  Created by Catherine Bostian on 1/30/18.
//  Copyright © 2018 Catherine Bostian. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class RecipesViewCell: UICollectionViewCell
{
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var addOrRemove: UIButton!

    @IBOutlet weak var imageHeight: NSLayoutConstraint!

    var post: Recipe! {
        didSet {
            self.updateUI()
        }
    }

    func updateUI()
    {
        captionLabel.text = post.name ?? post.note

        downloadUIImage(recipeImage: post.image)
        postImageView.layer.cornerRadius = 5.0
        postImageView.layer.masksToBounds = true
        addOrRemove.layer.cornerRadius = addOrRemove.bounds.size.width / 2
        addOrRemove.clipsToBounds = true
    }

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let attributes = layoutAttributes as? RecipesLayoutAttributes {
            imageHeight.constant = attributes.photoHeight
        }
    }

    func downloadUIImage(recipeImage: RecipeImage) {
        Alamofire.request(URLRequest(url: URL(string: recipeImage.url)!)).responseData(completionHandler: {(response) in
            self.postImageView.image = UIImage(data: response.data!)
        })
    }
}
