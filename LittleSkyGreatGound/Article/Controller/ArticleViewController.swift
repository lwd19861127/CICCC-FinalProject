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

    private var tableView: UITableView!
    private let searchController = UISearchController(searchResultsController: nil)

    private let cellId = "ArticleCell"
    
    private var filteredArticles: [Article] = []

    private var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    private var isFiltering: Bool {
      return searchController.isActive && (!isSearchBarEmpty || searchController.searchBar.selectedScopeButtonIndex != 0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor

        ArticleController.shared.subscribeArticles()
//        var article1 = Article(title: "First Article", date: Temporal.DateTime(Date()), link: "http://", status: Status.on)
//        article1.description = "update"
//        article1.categories = ArticleCategory.bookRecommendations
//        var article2 = Article(title: "Tidy up the office", date: Temporal.DateTime(Date()), link: "http://", status: Status.on)
//        article2.description = "update"
//        article2.categories = ArticleCategory.parentalExperiences
//        ArticleController.shared.findOrSaveArticle(matching: article1)
//        ArticleController.shared.findOrSaveArticle(matching: article2)
        ArticleController.shared.readArticles()
//        for article in ArticleController.shared.articles.articleList {
//            ArticleController.shared.deleteArticle(matching: article.id)
//        }
        
        /// Navigation Bar
        setupNavigation()
        
        /// Table view
        setupTableView()
        
        /// Search Bar
        setupSearchController()
    }
    
    fileprivate func setupNavigation() {
        navigationItem.title = "Articles"
    }
    
    fileprivate func setupTableView() {
      tableView = UITableView()
      tableView.dataSource = self
      tableView.delegate = self
      tableView.register(ArticleTableViewCell.self, forCellReuseIdentifier: cellId)
      view.addSubview(tableView)
      tableView.anchors(topAnchor: view.safeAreaLayoutGuide.topAnchor, leadingAnchor: view.leadingAnchor, trailingAnchor: view.trailingAnchor, bottomAnchor: view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    fileprivate func setupSearchController() {
      navigationItem.searchController = searchController
      searchController.obscuresBackgroundDuringPresentation = false
      searchController.searchBar.placeholder = "Search Article"
      searchController.searchResultsUpdater = self
      searchController.searchBar.delegate = self
      // ensure that the search bar doesn't remain on the screen if the user navigates to another view controller while the UISearchController is active
      definesPresentationContext = true
        
        searchController.searchBar.scopeButtonTitles = ["All", ArticleCategory.bookRecommendations.rawValue, ArticleCategory.parentalExperiences.rawValue]
    }
    
    private func filterArticleFor(searchText: String, category: ArticleCategory? = nil) {
        filteredArticles = ArticleController.shared.articles.articleList.filter { (article) in
            let isCategoryMatching =  category == article.categories
            let isSearchTextMatching = article.title.lowercased().contains(searchText.lowercased())
            if category == nil { // when category is nil, means it is All
                if isSearchBarEmpty {
                    return true
                } else {
                    return isSearchTextMatching
                }
            } else {
                if isSearchBarEmpty {
                    return isCategoryMatching
                } else {
                    return isCategoryMatching && isSearchTextMatching
                }
            }
      }
      tableView.reloadData()
    }
}

// MARK: - Table view data source

extension ArticleViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return isFiltering ? filteredArticles.count : ArticleController.shared.articles.articleList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ArticleTableViewCell
    let article = isFiltering ? filteredArticles[indexPath.row] : ArticleController.shared.articles.articleList[indexPath.row]
    cell.textLabel?.text = article.title
    cell.detailTextLabel?.text = article.date.foundationDate.datatypeValue
    return cell
  }
}

// MARK: - Table view delegate

extension ArticleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let articleDetailVC = ArticleDetailViewController()
        articleDetailVC.article = isFiltering ? filteredArticles[indexPath.row] : ArticleController.shared.articles.articleList[indexPath.row]
        navigationController?.pushViewController(articleDetailVC, animated: true)
    }
}

// MARK: - UISearchResultsUpdating

extension ArticleViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
    let category = ArticleCategory(rawValue: searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex])
    filterArticleFor(searchText: searchBar.text!, category: category)
  }
}

extension ArticleViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    let category = ArticleCategory(rawValue: searchBar.scopeButtonTitles![selectedScope])
    filterArticleFor(searchText: searchBar.text!, category: category)
  }
}