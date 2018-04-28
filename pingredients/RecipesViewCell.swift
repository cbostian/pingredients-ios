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

    var post: Recipe!

    func updateUI(recipe: Recipe)
    {
        self.post = recipe
        post.image.observer = self
        captionLabel.text = post.name ?? post.note
        captionLabel.font = Constants.captionFont
        
        updateImage()
        postImageView.layer.cornerRadius = 5.0
        postImageView.layer.masksToBounds = true

        addOrRemove.layer.cornerRadius = addOrRemove.bounds.size.width / 2
        addOrRemove.clipsToBounds = true
        addOrRemove.addTarget(self, action: #selector(toggleAddOrRemoved), for: .touchUpInside)
        setAddOrRemoveColor()
    }

    func updateImage() {
        self.postImageView.image = post.image.downloadedImage
    }
    
    @objc func toggleAddOrRemoved() {
        self.post.making = !self.post.making
        setAddOrRemoveColor()
    }

    func setAddOrRemoveColor() {
        let jungleGreen = UIColor(red: 0.15, green: 0.76, blue: 0.51, alpha: 1.0)
        addOrRemove.backgroundColor? = self.post.making ? jungleGreen : UIColor.darkGray
    }
}
