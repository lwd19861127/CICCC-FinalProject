//
//  ArticleViewController.swift
//  LittleSkyGreatGound
//
//  Created by WendaLi on 2020-06-23.
//  Copyright © 2020 WendaLi. All rights reserved.
//

import UIKit
import Amplify

class ArticleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brown

        ArticleController.shared.subscribeArticles()
        var article = Article(title: "First Article", date: Temporal.DateTime(Date()), link: "http://", status: Status.on)
        article.description = "update"
        //ArticleController.shared.findOrSaveArticle(matching: article)
        ArticleController.shared.readArticles()
    }
        
}
