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
        
        /**Discovery**/
        let discoveryViewController = UINavigationController(rootViewController: DiscoveryViewController())
        discoveryViewController.tabBarItem = UITabBarItem(title: "Discovery", image: UIImage(systemName: "globe"), tag: 0)
        
        /**Aritcle**/
        let articleViewController = UINavigationController(rootViewController: ArticleViewController())
        articleViewController.tabBarItem = UITabBarItem(title: "Aritcle", image: UIImage(systemName: "globe"), tag: 1)
        
        /**My**/
        let myTableViewController = UINavigationController(rootViewController: MyTableViewController(style: .grouped))
        myTableViewController.tabBarItem = UITabBarItem(title: "My", image: UIImage(systemName: "globe"), tag: 2)
        
        let tabBarList = [articleViewController, myTableViewController]
        
        UITabBar.appearance().tintColor = UIColor(named: "highlightOrange")
        viewControllers = tabBarList
    }
}
