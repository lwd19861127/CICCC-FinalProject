//
//  InfoTableViewController.swift
//  LittleSkyGreatGound
//
//  Created by WendaLi on 2020-07-02.
//  Copyright © 2020 WendaLi. All rights reserved.
//

import UIKit

class InfoTableViewController: UITableViewController {

    private let tableViewCellId = "TableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(TableViewCell.self, forCellReuseIdentifier: tableViewCellId)

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellId, for: indexPath) as! TableViewCell
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "User ID"
            cell.detailTextLabel?.text = MyController.shared.user?.id
        case 1:
            cell.textLabel?.text = "User Name"
            cell.detailTextLabel?.text = MyController.shared.user?.userName
        case 2:
            cell.textLabel?.text = "Email"
            cell.detailTextLabel?.text = MyController.shared.user?.userEmail
        default:
            cell.textLabel?.text = ""
        }
        return cell
    }

    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
