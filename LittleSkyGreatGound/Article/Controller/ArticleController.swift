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

protocol RecentlyReadArticlesDelegate: class {
    func updateRecentlyReadArticlesViewControllerUI(with recentlyReadArticles: Articles)
}
protocol FavoriteArticlesDelegate: class {
    func updateFavoriteArticlesViewControllerUI(with favoriteArticles: Articles)
}

class ArticleController {
    weak var recentlyReadArticlesDelegate: RecentlyReadArticlesDelegate?
    weak var favoriteArticlesDelegate: FavoriteArticlesDelegate?
    
    var articleSubscription: AnyCancellable?

    var articles = Articles()
    {
        didSet {
            NotificationCenter.default.post(name: ArticleController.articlesUpdatedNotification, object: nil)
        }
    }
    var recentlyReadArticles = Articles()
    var favoriteArticles = Articles()
    
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
                        print("==== Article ====\nNo Article")
                        return
                    }
                    self.articles.articleList = dbArticles
                    complet()
                    for article in dbArticles {
                        print("==== Article ====")
                        print("Name: \(article.title)")
                    }
                case .failure(let error):
                    print("Could not query DataStore: \(error)")
            }
        })
    }
    
    func readRecentlyReadArticles(by userId: String, complet: () -> Void){
        Amplify.DataStore.query(User.self,
            where: User.keys.id.eq(userId)) { result in
            switch (result) {
            case .success(let users):
                let user = users.first
                if let userWithRecentlyReadArticles = user {
                    if let recentlyReadArticles = userWithRecentlyReadArticles.recentlyRead {
                        guard recentlyReadArticles.count > 0 else {
                            print("==== Article ====")
                            print("No RecentlyReadArticles")
                            return
                        }
                        self.recentlyReadArticles.articleList = recentlyReadArticles.compactMap { $0.article }
                        self.recentlyReadArticlesDelegate?.updateRecentlyReadArticlesViewControllerUI(with: self.recentlyReadArticles)
                        complet()
                    }
                } else {
                    print("User not found")
                }
            case .failure(let error):
                print("User not found - \(error.localizedDescription)")
            }
        }
    }
    
    func readFavoriteArticles(by userId: String, complet: () -> Void){
        Amplify.DataStore.query(User.self, byId: userId) {
            switch $0 {
            case .success(let user):
                if let userWithFavoriteArticles = user {
                    if let favoriteArticles = userWithFavoriteArticles.favorites {
                        guard favoriteArticles.count > 0 else {
                            print("==== Article ====")
                            print("No FavoriteArticles")
                            return
                        }
                        self.favoriteArticles.articleList = favoriteArticles.compactMap { $0.article }
                        self.favoriteArticlesDelegate?.updateFavoriteArticlesViewControllerUI(with: self.favoriteArticles)
                        complet()
                    }
                } else {
                    print("User not found")
                }
            case .failure(let error):
                print("User not found - \(error.localizedDescription)")
            }
        }
    }
    
    func saveRecentlyReadArticle(with article: Article, for user: User) {
        Amplify.DataStore.save(user) { userResult in
            switch userResult {
            case .failure(let error):
                print("Error adding post - \(error.localizedDescription)")
            case .success:
                Amplify.DataStore.save(article) { articleResult in
                    switch articleResult {
                    case .failure(let error):
                        print("Error adding user - \(error.localizedDescription)")
                    case .success:
                        let recentlyReadArticles = RecentlyReadArticles(user: user, article: article)
                        Amplify.DataStore.save(recentlyReadArticles) { recentlyReadArticlesResult in
                            switch recentlyReadArticlesResult {
                            case .failure(let error):
                                print("Error saving recentlyReadArticlesResult - \(error.localizedDescription)")
                            case .success:
                                print("Saved user, and recentlyReadArticlesResult!")
                            }
                        }
                    }
                }
            }
        }
    }
    
    func saveFavoriteArticle(with article: Article, for user: User) {
        Amplify.DataStore.save(user) { userResult in
            switch userResult {
            case .failure(let error):
                print("Error adding post - \(error.localizedDescription)")
            case .success:
                Amplify.DataStore.save(article) { articleResult in
                    switch articleResult {
                    case .failure(let error):
                        print("Error adding user - \(error.localizedDescription)")
                    case .success:
                        let favoriteArticles = FavoriteArticles(user: user, article: article)
                        Amplify.DataStore.save(favoriteArticles) { favoriteArticlesResult in
                            switch favoriteArticlesResult {
                            case .failure(let error):
                                print("Error saving favoriteArticles - \(error.localizedDescription)")
                            case .success:
                                print("Saved user, and favoriteArticles!")
                            }
                        }
                    }
                }
            }
        }
    }
    
    func saveArticle(matching item: Article) {
        Amplify.DataStore.save(item) { result in
                switch(result) {
                case .success(let savedArticle):
                    print("==== Article ====")
                    print("Saved item: \(savedArticle.title )")
                case .failure(let error):
                    print("Could not update data in Datastore: \(error)")
            }
        }
    }
    
    func deleteArticle(matching id: String) {
         Amplify.DataStore.query(Article.self, byId: id){ result in
             switch(result) {
             case .success(let article):
                Amplify.DataStore.delete(Article.self, withId: article!.id) { result in
                                             switch(result) {
                                             case .success:
                                                 print("==== Article ====")
                                                 print("Deleted item: \(article!.title)")
                                             case .failure(let error):
                                                 print("Could not update data in Datastore: \(error)")
                                             }
                 }
             case .failure(let error):
                 print("Could not query DataStore: \(error)")
             }
        }
    }
    
    ///test
    func testSaveArticle(){
        let article = self.articles.articleList[0]
        saveArticle(matching: article)
    }
    
    ///test
    func testDeleteArticles() {
        for article in ArticleController.shared.articles.articleList {
            if article.title == "List of books 0~1 year old baby reading? Sense Unification (Part 3)" {
                deleteArticle(matching: article.id)
            }
        }
    }
}
