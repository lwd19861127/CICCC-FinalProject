//
//  MainTabBarViewController.swift
//  iOS_Clock_App
//
//  Created by Aaron Chen on 2020-05-27.
//  Copyright © 2020 Aaron Chen. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /**Aritcle**/
        let articleViewController = UINavigationController(rootViewController: ArticleViewController())
        articleViewController.tabBarItem = UITabBarItem(title: "Aritcle", image: UIImage(systemName: "globe"), tag: 0)
        
        /**My**/
//        let myViewController = UINavigationController(rootViewController: MyViewController())
//        myViewController.tabBarItem = UITabBarItem(title: "My", image: UIImage(systemName: "globe"), tag: 1)
        let myTableViewController = UINavigationController(rootViewController: MyTableViewController(style: .grouped))
        myTableViewController.tabBarItem = UITabBarItem(title: "My", image: UIImage(systemName: "globe"), tag: 1)
        
        let tabBarList = [articleViewController, myTableViewController]
        
        UITabBar.appearance().tintColor = UIColor(named: "highlightOrange")
        viewControllers = tabBarList
    }
}
