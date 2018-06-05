//
//  TableViewModel.swift
//  pingredients
//
//  Created by Catherine Bostian on 6/5/18.
//  Copyright © 2018 Catherine Bostian. All rights reserved.
//

import Foundation
import UIKit

let dataArray = [TableModel(amount: "5", unit: "cups", name: "wine"), TableModel(amount: "5", unit: "cups", name: "wine"), TableModel(amount: "5", unit: "cups", name: "wine"), TableModel(amount: "5", unit: "cups", name: "wine")]

class TableViewModelItem {
    private var item: TableModel

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

    init(item: TableModel) {
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
        items = dataArray.map { TableViewModelItem(item: $0) }
    }
}

extension TableViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier, for: indexPath) as? CustomCell {
            cell.item = items[indexPath.row]

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
