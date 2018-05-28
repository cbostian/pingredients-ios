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
    var unmakeCallback: ((RecipesViewCell) -> ())?

    var post: Recipe!

    func updateUI(recipe: Recipe)
    {
        self.post = recipe
        captionLabel.text = post.name ?? post.note
        captionLabel.font = Constants.captionFont
        clearImage()
        if let img = post.image.downloadedImage {
            postImageView.image = img
        } else {
            downloadUIImage()
        }
        postImageView.layer.cornerRadius = 5.0
        postImageView.layer.masksToBounds = true

        addOrRemove.layer.cornerRadius = addOrRemove.bounds.size.width / 2
        addOrRemove.clipsToBounds = true
        addOrRemove.addTarget(self, action: #selector(toggleAddOrRemoved), for: .primaryActionTriggered)
        setAddOrRemoveColor()
    }
    
    @objc func toggleAddOrRemoved() {
        addOrRemove.isEnabled = false
        self.post.making = !self.post.making
        self.setAddOrRemoveColor()
        if self.post.making == true {
            makeRecipe(recipe: post, callback: {self.addOrRemove.isEnabled = true})
        } else {
            unmakeRecipe(recipe: post, recipeID: post.id, cell: self, callback: unmakeAndEnableButton)
        }
    }
    
    func unmakeAndEnableButton(cell: RecipesViewCell) {
        unmakeCallback!(cell)
        self.addOrRemove.isEnabled = true
    }

    func setAddOrRemoveColor() {
        let jungleGreen = UIColor(red: 0.15, green: 0.76, blue: 0.51, alpha: 1.0)
        addOrRemove.backgroundColor? = self.post.making ? jungleGreen : UIColor.darkGray
    }
    
    func clearImage() {
        postImageView.image = nil
        request?.cancel()
    }
    
    func downloadUIImage() {
        request = Alamofire.request(URLRequest(url: URL(string: post.image.url)!)).responseData(completionHandler: {(response) in
            self.postImageView.image = UIImage(data: response.data!)
            self.post.image.downloadedImage = self.postImageView.image
        })
    }
}
