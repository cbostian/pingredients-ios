//
//  IngredientsViewController.swift
//  pingredients
//
//  Created by Catherine Bostian on 6/2/18.
//  Copyright © 2018 Catherine Bostian. All rights reserved.
//

import UIKit

class IngredientsViewController: UITableViewController {

    var tableViewModel = TableViewModel()

    @IBOutlet var ingredientTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView?.register(IngredientTableViewCell.nib, forCellReuseIdentifier: IngredientTableViewCell.identifier)
        tableView?.estimatedRowHeight = 100
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.allowsMultipleSelection = true
        tableView?.dataSource = tableViewModel
        tableView?.delegate = tableViewModel
        tableView?.separatorStyle = .none

//        viewModel.didToggleSelection = { [weak self] hasSelection in
//            self?.nextButton?.isEnabled = hasSelection
//        }
    }
}

