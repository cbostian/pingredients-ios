//
//  CustomCell.swift
//  pingredients
//
//  Created by Catherine Bostian on 6/1/18.
//  Copyright © 2018 Catherine Bostian. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    print("in custom cell")

    var item: ViewModelItem? {
        didSet {
            titleLabel?.text = item?.title
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none
    }

    @IBOutlet weak var titleLabel: UILabel!

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
