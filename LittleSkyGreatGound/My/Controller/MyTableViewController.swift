//
//  MyTableViewController.swift
//  LittleSkyGreatGound
//
//  Created by WendaLi on 2020-07-02.
//  Copyright © 2020 WendaLi. All rights reserved.
//

import UIKit

struct Constant {
    public static let notLoginMessage = "Not login"
    public static let logoutConfirmMessage = "Are you sure to Logout?"
    
    public static let myInfoLable = "My Info"
    public static let favoriteArticlesLable = "Favorite Articles"
    public static let recentlyReadArticlesLable = "Recently Read Articles"
    public static let aboutUsLable = "About Us"
    public static let signOutLable = "Sign Out"
}

class MyTableViewController: UITableViewController, MyControllerDelegate {
    
    private let loginCellId = "LoginCell"
    private let tableViewCellId = "TableViewCell"
        
    private var refreshController: UIRefreshControl!
    
    private var userName: String = "Hi, There!"
    private var isUserInteractionEnabled = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .backgroundColor
        
        tableView.register(LoginViewCell.self, forCellReuseIdentifier: loginCellId)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: tableViewCellId)
        
        view.backgroundColor = .backgroundColor
        MyController.shared.delegate = self

        /// Navigation Bar
        setupNavigation()
        
        ///Refresh Controller
        setupRefresh()
    }

    override func viewWillAppear(_ animated: Bool) {
        MyController.shared.getCurrentUser()
    }
    
    fileprivate func setupNavigation() {
        navigationItem.title = "LittleSkyGreatGround"
        navigationController?.navigationBar.backgroundColor = .white
    }
    
    fileprivate func setupRefresh() {
        refreshController = UIRefreshControl()
        refreshController.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        tableView.refreshControl = refreshController
    }
    
    @objc func refresh(_ sender: UIRefreshControl) {
        MyController.shared.fetchCurrentAuthSession()
        refreshController.endRefreshing()
    }
    
    func setupAlartController() -> UIAlertController{
        let alertController = UIAlertController(title: "Prompt", message: "", preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil )
        alertController.addAction(cancelAction)
        return alertController
    }
    
    func updateUI(forIsSignedInStatus isSignedIn: Bool, withUserName userName: String) {
        DispatchQueue.main.async() {
            self.userName = userName
            self.isUserInteractionEnabled = !isSignedIn
            self.tableView.reloadData()
        }
    }
    
    @objc func signIn() {
        MyController.shared.signInWithWebUI()
    }
    
    @objc func confirmToSignOut() {
        let alertController = setupAlartController()
        if !MyController.shared.authSession.isSignedIn {
            alertController.message = Constant.notLoginMessage
        }else {
            alertController.message = Constant.logoutConfirmMessage
            let confirmAction = UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default) { (ACTION) in
                self.signOut()
            }
            alertController.addAction(confirmAction)
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    func signOut() {
        MyController.shared.signOut()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: loginCellId, for: indexPath) as! LoginViewCell
            cell.userIDLable.text = userName
            cell.isUserInteractionEnabled = isUserInteractionEnabled
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellId, for: indexPath)
        cell.accessoryType = .disclosureIndicator
        switch indexPath.row {
        case 1:
            cell.textLabel?.text = Constant.myInfoLable
        case 2:
            cell.textLabel?.text = Constant.favoriteArticlesLable
        case 3:
            cell.textLabel?.text = Constant.recentlyReadArticlesLable
        case 4:
            cell.textLabel?.text = Constant.aboutUsLable
        case 5:
            cell.textLabel?.text = Constant.signOutLable
        default:
            break
        }
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        return view
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 150
        }else {
            return 70
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            signIn()
        case 1:
            if !MyController.shared.authSession.isSignedIn {
                let alertController = setupAlartController()
                alertController.message = Constant.notLoginMessage
                self.present(alertController, animated: true, completion: nil)
                tableView.deselectRow(at: indexPath, animated: true)
            }else {
                let infoVC = InfoTableViewController(style: .grouped)
                navigationController?.pushViewController(infoVC, animated: true)
            }
        case 3:
            if !MyController.shared.authSession.isSignedIn {
                let alertController = setupAlartController()
                alertController.message = Constant.notLoginMessage
                self.present(alertController, animated: true, completion: nil)
                tableView.deselectRow(at: indexPath, animated: true)
            }else {
                let rRVC = RecentlyReadArticlesViewController()
                navigationController?.pushViewController(rRVC, animated: true)
            }
        case 4:
            let auVC = AboutUsViewController()
            navigationController?.pushViewController(auVC, animated: true)
        case 5:
            confirmToSignOut()
            tableView.deselectRow(at: indexPath, animated: true)
        default:
            break
        }
    }
}
