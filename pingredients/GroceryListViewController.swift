//
//  GroceryListViewController.swift
//  pingredients
//
//  Created by Jimmy Burgess on 6/21/18.
//  Copyright © 2018 Catherine Bostian. All rights reserved.
//

import Foundation
import UIKit

struct Category {
    var opened = Bool()
    var title = String()
}

var groceries = [String:[Ingredient]]()
var categories = [Category]()

class GroceryListViewController: UITableViewController {
    func overwriteGroceries(newGroceries:[String:[Ingredient]]) {
        groceries = newGroceries
        categories = []
        for category in Array(groceries.keys){
            categories.append(Category(opened: false, title: category))
        }
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getGroceryList(callback: overwriteGroceries)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getGroceryList(callback: overwriteGroceries)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return groceries.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if categories[section].opened == true {
            return groceries[categories[section].title]!.count + 1
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {return UITableViewCell()}
            cell.textLabel?.text = categories[indexPath.section].title
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {return UITableViewCell()}
            cell.textLabel?.text = groceries[categories[indexPath.section].title]![indexPath.row - 1].name
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            categories[indexPath.section].opened = !categories[indexPath.section].opened
            tableView.reloadSections(IndexSet.init(integer: indexPath.section), with: .none)
        }
    }
}
