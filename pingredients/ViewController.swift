//
//  ViewController.swift
//  pingredients
//
//  Created by Catherine Bostian on 6/2/18.
//  Copyright © 2018 Catherine Bostian. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var viewModel = ViewModel()


    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("View controller loaded")

        tableView?.register(CustomCell.nib, forCellReuseIdentifier: CustomCell.identifier)
        tableView?.estimatedRowHeight = 100
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.allowsMultipleSelection = true
        tableView?.dataSource = viewModel
        tableView?.delegate = viewModel
        tableView?.separatorStyle = .none

        viewModel.didToggleSelection = { [weak self] hasSelection in
            self?.nextButton?.isEnabled = hasSelection
        }
    }

    @IBAction func next(_ sender: Any) {
        print(viewModel.selectedItems.map { $0.title })
        tableView?.reloadData()
    }
}

