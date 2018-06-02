//
//  IngredientTableViewCell.swift
//  pingredients
//
//  Created by Catherine Bostian on 6/1/18.
//  Copyright © 2018 Catherine Bostian. All rights reserved.
//

import UIKit

class IngredientTableViewCell: UITableViewCell {

    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var unit: UILabel!
    @IBOutlet weak var name: UILabel!

    var item: TableViewModelItem? {
        didSet {
            amount?.text = item?.amount
            unit?.text = item?.unit
            name?.text = item?.name
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    static var identifier: String {
        return String(describing: self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // update UI
        accessoryType = selected ? .checkmark : .none
    }

}
