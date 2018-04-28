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
        addOrRemove.addTarget(self, action: #selector(toggleAddOrRemoved), for: .touchUpInside)
    }

    func downloadUIImage(recipeImage: RecipeImage) {
        Alamofire.request(URLRequest(url: URL(string: recipeImage.url)!)).responseData(completionHandler: {(response) in
            self.postImageView.image = UIImage(data: response.data!)
        })
    }

    @objc func toggleAddOrRemoved() {
        self.making = !self.making
    }

    var making = false {
        didSet {
            let jungleGreen = UIColor(red: 0.15, green: 0.76, blue: 0.51, alpha: 1.0)
            addOrRemove.backgroundColor? = making ? jungleGreen : UIColor.darkGray
        }
    }
}
