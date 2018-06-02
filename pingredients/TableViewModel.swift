//
//  TableViewModel.swift
//  pingredients
//
//  Created by Catherine Bostian on 6/2/18.
//  Copyright © 2018 Catherine Bostian. All rights reserved.
//

import Foundation
import UIKit

let ingredientsArray = [Ingredient(amount: "4", unit: "lbs", name: "apples"), Ingredient(amount: "1", unit: "ml", name: "olive oil",), Ingredient(amount: "2", unit: "cups", name: "flour"), Ingredient(amount: "1", unit: "tbsp", name: "salt"),]

class TableViewModelItem {
    private var item: Ingredient

    var isSelected = false

    var amount: String {
        return item.amount
    }

    var unit: String {
        return item.unit
    }

    var name: String {
        return item.name
    }

    init(item: Ingredient) {
        self.item = item
    }
}

class TableViewModel: NSObject {
    var items = [TableViewModelItem]()

    var didToggleSelection: ((_ hasSelection: Bool) -> ())? {
        didSet {
            didToggleSelection?(!selectedItems.isEmpty)
        }
    }

    var selectedItems: [TableViewModelItem] {
        return items.filter { return $0.isSelected }
    }

    override init() {
        super.init()
        items = ingredientsArray.map { TableViewModelItem(item: $0) }
    }
}

extension TableViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : IngredientTableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! IngredientTableViewCell

            // select/deselect the cell
            if items[indexPath.row].isSelected {
                if !cell.isSelected {
                    tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                }
            } else {
                if cell.isSelected {
                    tableView.deselectRow(at: indexPath, animated: false)
                }
            }

            return cell
        }
        return UITableViewCell()
    }
}

extension TableViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // update ViewModel item
        items[indexPath.row].isSelected = true

        didToggleSelection?(!selectedItems.isEmpty)
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {

        // update ViewModel item
        items[indexPath.row].isSelected = false

        didToggleSelection?(!selectedItems.isEmpty)
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if selectedItems.count > 2 {
            return nil
        }
        return indexPath
    }
}
