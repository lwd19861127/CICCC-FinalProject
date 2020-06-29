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
            NotificationCenter.default.post(name: ArticleController.articlesUpdatedNotification, object: nil)
        }
    }
    
    static let shared = ArticleController()
    static let articlesUpdatedNotification = Notification.Name("ArticleController.articlesUpdated")

    init(){}

    func subscribeArticles() {
       self.articleSubscription
           = Amplify.DataStore.publisher(for: Article.self)
               .sink(receiveCompletion: { completion in
                   print("Subscription has been completed: \(completion)")
               }, receiveValue: { mutationEvent in
                   print("Subscription got this value: \(mutationEvent)")
               })
    }
    
    func readArticles(complet: () -> Void){
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
                                            complet()
                                            
                                            ///test
                                            //testFindOrSaveArticle()
                                            //testDeleteArticles()
                                            
                                            for article in dbArticles {
                                                print("==== Article ====")
                                                print("Name: \(article.title)")
                                            }
                                        case .failure(let error):
                                            print("Could not query DataStore: \(error)")
                                        }
                                    })
    }
    
    ///test
    func testFindOrSaveArticle() {
        //        ///save
        //        var article1 = Article(title: "Did you start studying at the age of 0?  What do you read before picture book?", date: Temporal.DateTime(Date()), link: "http://", status: Status.on)
        //        article1.description = "update"
        ////        article1.categories = ArticleCategory.bookRecommendations
        //        var article2 = Article(title: "The book I planned is on the market, the hard-core books that American elementary school students are reading, friends and family are turning up!", date: Temporal.DateTime(Date()), link: "http://", status: Status.on)
        //        article2.description = "update"
        //        article2.categories = ArticleCategory.parentalExperiences
        guard ArticleController.shared.articles.articleList.count > 0 else {
            return
        }
        ArticleController.shared.articles.articleList[0].image = "https://cdn.cnn.com/cnnnext/dam/assets/200624161858-01-dolphin-tools-learning-super-tease.jpg"
        ArticleController.shared.articles.articleList[1].image = "https://cdn.cnn.com/cnnnext/dam/assets/200622094323-hong-kong-china-national-security-law-0620-super-tease.jpg"
                ArticleController.shared.findOrSaveArticle(matching: ArticleController.shared.articles.articleList[0])
                ArticleController.shared.findOrSaveArticle(matching: ArticleController.shared.articles.articleList[1])
    }
    
    ///test
    func testDeleteArticles() {
        for article in ArticleController.shared.articles.articleList {
            ArticleController.shared.deleteArticle(matching: article.id)
        }
    }
    
    func findOrSaveArticle(matching item: Article) {
        Amplify.DataStore.query(Article.self,
                                where: Article.keys.id.eq(item.id),
                                completion: { result in
            switch(result) {
            case .success(let articles):
                if articles.count == 0 {
                    Amplify.DataStore.save(item,
                                           completion: { result in
                                            switch(result) {
                                            case .success(let savedArticle):
                                                print("==== Article ====")
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
                                                    print("==== Article ====")
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
    
    func deleteArticle(matching id: String) {
         Amplify.DataStore.query(Article.self,
                                 where: Article.keys.id.eq(id),
                                 completion: { result in
             switch(result) {
             case .success(let articles):
                 guard articles.count == 1, let toDeleteArticle = articles.first else {
                     print("Did not find exactly one todo, bailing")
                     return
                 }
                 Amplify.DataStore.delete(toDeleteArticle,
                                          completion: { result in
                                             switch(result) {
                                             case .success:
                                                 print("==== Article ====")
                                                 print("Deleted item: \(toDeleteArticle.title)")
                                             case .failure(let error):
                                                 print("Could not update data in Datastore: \(error)")
                                             }
                 })
             case .failure(let error):
                 print("Could not query DataStore: \(error)")
             }
        })
    }
}
