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
    private var request: DataRequest?

    var post: Recipe! {
        didSet {
            self.updateUI()
        }
    }

    func updateUI()
    {
        captionLabel.text = post.name ?? post.note
        captionLabel.font = Constants.captionFont

        downloadUIImage(recipeImage: post.image)
        postImageView.layer.cornerRadius = 5.0
        postImageView.layer.masksToBounds = true
        addOrRemove.layer.cornerRadius = addOrRemove.bounds.size.width / 2
        addOrRemove.clipsToBounds = true
    }

    func downloadUIImage(recipeImage: RecipeImage) {
        self.postImageView.image = nil
        request?.cancel()
        request = Alamofire.request(URLRequest(url: URL(string: recipeImage.url)!)).responseData(completionHandler: {(response) in
            self.postImageView.image = UIImage(data: response.data!)
        })
    }
}
