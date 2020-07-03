//
//  MyViewController.swift
//  LittleSkyGreatGound
//
//  Created by WendaLi on 2020-06-29.
//  Copyright © 2020 WendaLi. All rights reserved.
//

import UIKit

class MyViewController: UIViewController, MyControllerDelegate {
    
    private var signOutButton:UIBarButtonItem!
    private var refreshController: UIRefreshControl!
    private var hStackView: UIStackView!
    
    private var userImage: UIImageView = {
        let iv = UIImageView()
        let userImageHeightAndWidth = 100
        iv.image = .userImage
        iv.frame  = CGRect(x: 0, y: 0, width: userImageHeightAndWidth, height: userImageHeightAndWidth)
        iv.layer.cornerRadius = iv.frame.size.width / 2
        iv.clipsToBounds = true
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 1
        iv.constraintWidth(equalToConstant: CGFloat(userImageHeightAndWidth), heightEqualToConstant: CGFloat(userImageHeightAndWidth))
        return iv
    }()
    
    private var userIDButton:UIButton = {
        let bt = UIButton()
        bt.setTitle("Hi, there!", for: .normal)
        bt.setTitleColor(.black, for: .normal)
        bt.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        bt.contentHorizontalAlignment = .left
        return bt
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        MyController.shared.delegate = self

        /// Navigation Bar
        setupNavigation()
        
        ///Refresh Controller
        setupRefresh()
        
        ///UserID Button
        setupUserIDButton()
        
        ///StackView
        setupStackView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        MyController.shared.getCurrentUser()
    }
    
    fileprivate func setupNavigation() {
        navigationItem.title = "LittleSkyGreatGround"
        signOutButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(confirmToSignOut))
        navigationItem.rightBarButtonItem = signOutButton
        navigationController?.navigationBar.backgroundColor = .white
    }
    
    fileprivate func setupRefresh() {
        refreshController = UIRefreshControl()
        refreshController.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
    }
    
    @objc func refresh(_ sender: UIRefreshControl) {
        MyController.shared.getCurrentUser()
    }
    
    fileprivate func setupUserIDButton() {
        userIDButton.addTarget(self, action: #selector(signIn), for: .touchUpInside)
    }

    fileprivate func setupStackView() {
        hStackView = HorizontalStackView(arrangedSubviews: [userImage, userIDButton], spacing: 20, alignment: .center, distribution: .fill)
        view.addSubview(hStackView)
        hStackView.anchors(topAnchor: view.safeAreaLayoutGuide.topAnchor, leadingAnchor: view.leadingAnchor, trailingAnchor: view.trailingAnchor, bottomAnchor: nil, padding: UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 0), size: .zero)
    }
    
    func updateUI(forIsSignedInStatus isSignedIn: Bool, withUserName userName: String) {
        DispatchQueue.main.async() {
            if isSignedIn {
                self.userIDButton.isEnabled = false
            }else {
                self.userIDButton.isEnabled = true
            }
            self.userIDButton.setTitle(userName, for: .normal)
        }
    }
    
    @objc func signIn() {
        MyController.shared.signInWithWebUI()
    }
    
    @objc func confirmToSignOut() {
        let alertController = UIAlertController(title: "Prompt", message: "", preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil )
        alertController.addAction(cancelAction)
        if !MyController.shared.authSession.isSignedIn {
            alertController.message = "Not Login"
        }else {
            alertController.message = "Are you sure to Logout?"
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

}
