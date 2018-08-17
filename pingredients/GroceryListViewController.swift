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
            cell.textLabel?.textColor = UIColor(red: 0.0, green: 135.0/255.0, blue: 241.0/255.0, alpha: 1.0)
            cell.textLabel?.textAlignment = .left
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {return UITableViewCell()}
            let ingredient = groceries[categories[indexPath.section].title]![indexPath.row - 1]
            
            var label = ""
            if let displayAmount = ingredient.displayAmount {
                if displayAmount != "" {
                    label += displayAmount + " "
                }
            }
            if let unit = ingredient.unit {
                if unit != "" {
                    label += unit + " "
                }
            }
            label += ingredient.name
            cell.textLabel?.text = label
            cell.textLabel?.textColor = UIColor.black
            cell.textLabel?.textAlignment = .center
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
