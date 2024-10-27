//
//  MainViewController.swift
//  MyPlace
//
//  Created by user246073 on 10/27/24.
//

import UIKit

class MainViewController: UITableViewController {
    
    var restaurantNames = [
        "Burger Heroes", "Kitchen", "Bonsai", "Дастархан",
        "Индокитай", "X.O", "Балкан Гриль", "Sherlock Holmes",
        "Speak Easy", "Morris Pub", "Вкусные истории",
        "Классик", "Love&Life", "Шок", "Бочка"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 120
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantNames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = restaurantNames[indexPath.row]
        content.image = UIImage(named: restaurantNames[indexPath.row])
        cell.contentConfiguration = content
        return cell
    }

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedEmoji = restaurantNames.remove(at: sourceIndexPath.row)
        restaurantNames.insert(movedEmoji, at: destinationIndexPath.row)
        tableView.reloadData()
    }
}
