//
//  IngredientsViewController.swift
//  pingredients
//
//  Created by Catherine Bostian on 6/5/18.
//  Copyright © 2018 Catherine Bostian. All rights reserved.
//

import UIKit

class IngredientsViewController: UITableViewController {

    var tableViewModel = TableViewModel()

    @IBOutlet var ingredientsTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        ingredientsTableView?.register(CustomCell.nib, forCellReuseIdentifier: CustomCell.identifier)
        ingredientsTableView?.estimatedRowHeight = 100
        ingredientsTableView?.rowHeight = UITableViewAutomaticDimension
        ingredientsTableView?.allowsMultipleSelection = true
        ingredientsTableView?.dataSource = tableViewModel
        ingredientsTableView?.delegate = tableViewModel
        ingredientsTableView?.separatorStyle = .none

        viewModel.didToggleSelection = { [weak self] hasSelection in
            self?.nextButton?.isEnabled = hasSelection
        }
    }
}
