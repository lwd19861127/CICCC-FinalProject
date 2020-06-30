//
//  MyViewController.swift
//  LittleSkyGreatGound
//
//  Created by WendaLi on 2020-06-29.
//  Copyright © 2020 WendaLi. All rights reserved.
//

import UIKit

class MyViewController: UIViewController {
    
    private var userImage: UIImageView = {
        let iv = UIImageView()
        let userImageHeightAndWidth = 100
        iv.image = UIImage(named: "userImage")
        iv.frame  = CGRect(x: 0, y: 0, width: userImageHeightAndWidth, height: userImageHeightAndWidth)
        iv.layer.cornerRadius = iv.frame.size.width / 2
        iv.clipsToBounds = true
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 1
        iv.constraintWidth(equalToConstant: CGFloat(userImageHeightAndWidth), heightEqualToConstant: CGFloat(userImageHeightAndWidth))
        return iv
    }()
    
    private var userIDButton: UIButton!
    
    private var signOutButton:UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        
        /// Navigation Bar
        setupNavigation()
        
        ///UserID Button
        setupUserIDButton()
        
        ///StackView
        setupStackView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: MyController.userDataUpdatedNotification, object: nil)
    }
    
    fileprivate func setupNavigation() {
        navigationItem.title = "LittleSkyGreatGround"
        signOutButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(signOut))
        navigationItem.rightBarButtonItem = signOutButton
        navigationController?.navigationBar.backgroundColor = .white
    }
    
    fileprivate func setupUserIDButton() {
        userIDButton = UIButton()
        userIDButton.setTitleColor(.black, for: .normal)
        userIDButton.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        userIDButton.contentHorizontalAlignment = .left
        userIDButton.addTarget(self, action: #selector(signIn), for: .touchUpInside)
    }

    fileprivate func setupStackView() {
        let leadingView = UIImageView()
        leadingView.widthAnchor.constraint(equalToConstant: 10).isActive = true
        let hStackView = HorizontalStackView(arrangedSubviews: [leadingView, userImage, userIDButton], spacing: 20, alignment: .center, distribution: .fill)
        view.addSubview(hStackView)
        hStackView.anchors(topAnchor: view.safeAreaLayoutGuide.topAnchor, leadingAnchor: view.leadingAnchor, trailingAnchor: view.trailingAnchor, bottomAnchor: nil, padding: UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 0), size: .zero)
    }
    
    @objc func updateUI() {
        DispatchQueue.main.async() {
            if MyController.shared.authSession.isSignedIn {
                self.userIDButton.isEnabled = false
                self.userIDButton.setTitle(MyController.shared.userData.userID, for: .normal)
            }else {
                self.userIDButton.isEnabled = true
                self.userIDButton.setTitle("Press to Login", for: .normal)
            }
        }
    }
    
    @objc func signIn() {
           MyController.shared.signInWithWebUI()
       }
    
    @objc func signOut() {
        MyController.shared.signOut()
    }

}
