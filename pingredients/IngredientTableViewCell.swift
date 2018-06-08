//
//  IngredientTableViewCell.swift
//  pingredients
//
//  Created by Catherine Bostian on 6/8/18.
//  Copyright © 2018 Catherine Bostian. All rights reserved.
//

import UIKit

class IngredientTableViewCell: UITableViewCell {
    //MARK: Properties
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var unit: UILabel!
    @IBOutlet weak var name: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
