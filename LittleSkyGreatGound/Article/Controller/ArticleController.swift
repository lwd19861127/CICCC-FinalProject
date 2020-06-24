//
//  ArticleController.swift
//  LittleSkyGreatGound
//
//  Created by WendaLi on 2020-06-23.
//  Copyright © 2020 WendaLi. All rights reserved.
//

import Foundation
import Amplify
import Combine

class ArticleController {
    var articleSubscription: AnyCancellable?

    var articles = Articles()
    {
        didSet {
        }
    }
    
    init(){}
    static let shared = ArticleController()
    
    func subscribeArticles() {
       self.articleSubscription
           = Amplify.DataStore.publisher(for: Article.self)
               .sink(receiveCompletion: { completion in
                   print("Subscription has been completed: \(completion)")
               }, receiveValue: { mutationEvent in
                   print("Subscription got this value: \(mutationEvent)")
               })
    }
    
    func readArticles(){
        Amplify.DataStore.query(Article.self,
                                where: Article.keys.status.eq(Status.on),
                                completion: {result in
                                    switch(result) {
                                        case .success(let dbArticles):
                                            guard dbArticles.count > 0 else {
                                                print("==== Article ====")
                                                print("No Article")
                                                return
                                            }
                                            self.articles.articleList = dbArticles
                                            for article in dbArticles {
                                                print("==== Article ====")
                                                print("Name: \(article.title)")
                                            }
                                        case .failure(let error):
                                            print("Could not query DataStore: \(error)")
                                        }
                                    })
    }
    
    func findOrSaveArticle(matching item: Article) {
        Amplify.DataStore.query(Article.self,
                                where: Article.keys.title.eq(item.title),
                                completion: { result in
            switch(result) {
            case .success(let articles):
                if articles.count == 0 {
                    Amplify.DataStore.save(item,
                                           completion: { result in
                                            switch(result) {
                                            case .success(let savedArticle):
                                                print("Saved item: \(savedArticle.title )")
                                            case .failure(let error):
                                                print("Could not update data in Datastore: \(error)")
                                            }
                    })
                }else if articles.count == 1 {
                    if var updatedArticle = articles.first {
                        updatedArticle.title = item.title
                        updatedArticle.date = item.date
                        updatedArticle.link = item.link
                        updatedArticle.status = item.status
                        updatedArticle.image = item.image
                        updatedArticle.categories = item.categories
                        updatedArticle.priority = item.priority
                        updatedArticle.description = item.description
                        Amplify.DataStore.save(updatedArticle,
                                               completion: { result in
                                                switch(result) {
                                                case .success(let savedArticle):
                                                    print("Updated item: \(savedArticle.title )")
                                                case .failure(let error):
                                                    print("Could not update data in Datastore: \(error)")
                                                }
                        })
                    }
                }else {
                    print("Did not find exactly one todo, bailing")
                }
            case .failure(let error):
                print("Could not query DataStore: \(error)")
            }
        })
    }
}
