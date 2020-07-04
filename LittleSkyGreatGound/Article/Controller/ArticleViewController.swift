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
    private var refreshController: UIRefreshControl!
    
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
        
        /// Navigation Bar
        setupNavigation()
        
        /// Table view
        setupTableView()
        
        /// Search Bar
        setupSearchController()
        
        ///Refresh Controller
        setupRefresh()
        
        NotificationCenter.default.addObserver(tableView!, selector: #selector(tableView.reloadData), name: ArticleController.articlesUpdatedNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        MyController.shared.getCurrentUser()
        searchForArticles()
    }
    
    fileprivate func setupNavigation() {
        navigationItem.title = "LittleSkyGreatGround"
    }
    
    fileprivate func setupTableView() {
      tableView = UITableView()
      tableView.backgroundColor = .backgroundColor
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
    
    fileprivate func setupRefresh() {
        refreshController = UIRefreshControl()
        refreshController.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        tableView.refreshControl = refreshController
    }
    
    @objc func refresh(_ sender: UIRefreshControl) {
        ///Test
        //ArticleController.shared.testSaveArticle()
        //ArticleController.shared.testDeleteArticles()
        
        searchForArticles()
        MyController.shared.fetchCurrentAuthSession()
        refreshController.endRefreshing()
    }
    
    private func searchForArticles() {
        DispatchQueue.main.async {
            ArticleController.shared.readArticles {
                self.tableView.refreshControl?.endRefreshing()
            }
        }
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
    cell.article = article
    return cell
  }
}

// MARK: - Table view delegate

extension ArticleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var article = isFiltering ? filteredArticles[indexPath.row] : ArticleController.shared.articles.articleList[indexPath.row]
        let articleDetailVC = ArticleDetailViewController()
        articleDetailVC.article = article
        navigationController?.pushViewController(articleDetailVC, animated: true)
        
        ///Update priority and RecentlyReadArticle
        article.priority = article.priority + 1
        if let user = MyController.shared.user {
            ArticleController.shared.saveRecentlyReadArticle(with: article, for: user)
        }else {
            ArticleController.shared.saveArticle(matching: article)
        }
        tableView.deselectRow(at: indexPath, animated: true)
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
