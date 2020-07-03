//
//  ArticleDetailViewController.swift
//  LittleSkyGreatGound
//
//  Created by WendaLi on 2020-06-24.
//  Copyright © 2020 WendaLi. All rights reserved.
//

import UIKit
import WebKit

class ArticleDetailViewController: UIViewController {

    private var wkWebView: WKWebView!
    private var activityIndicator: UIActivityIndicatorView!
    private var refreshControl: UIRefreshControl!
    private var favoriteButton:UIBarButtonItem!

    var article: Article!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        
        ///LoadingView
        setupActivityIndicator()
        
        /// Navigation Bar
        setupNavigation()
        
        ///WebView
        setupWebView()
        
        ///Refresh Control
        setupRefresh()
        
        ///Load Webpage
        loadWebPage()
    }
    
    fileprivate func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .lightGray
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        view.addSubview(activityIndicator)
    }
    
    fileprivate func setupNavigation() {
        favoriteButton = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(addFavoriteArticle))
        navigationItem.rightBarButtonItem = favoriteButton
    }
    
    fileprivate func setupWebView() {
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        wkWebView = webView
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        view.addSubview(webView)
        webView.matchParent()
    }
    
    fileprivate func setupRefresh() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshWebView(_:)), for: .valueChanged)
        wkWebView.scrollView.refreshControl = refreshControl
    }
    
    fileprivate func loadWebPage(){
        let myURL = URL(string:article.link)
        let myRequest = URLRequest.init(url: myURL!, cachePolicy: URLRequest.CachePolicy.reloadRevalidatingCacheData, timeoutInterval: 15)
        wkWebView.load(myRequest)
    }
    
    func setupAlartController() -> UIAlertController{
        let alertController = UIAlertController(title: "Prompt", message: "", preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "Confirm", style: UIAlertAction.Style.cancel, handler: nil )
        alertController.addAction(cancelAction)
        return alertController
    }
    
    @objc func refreshWebView(_ sender: UIRefreshControl) {
        wkWebView?.reload()
    }
    
    @objc func addFavoriteArticle() {
        let alertController = setupAlartController()
        if !MyController.shared.authSession.isSignedIn {
            alertController.message = Constant.notLoginMessage
            self.present(alertController, animated: true, completion: nil)
        }else {
            if let user = MyController.shared.user {
                ArticleController.shared.saveFavoriteArticle(with: article, for: user)
                alertController.message = Constant.saveFavoriteArticle
                self.present(alertController, animated: true, completion: nil)
            }else {
                alertController.message = Constant.reLogin
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}

extension ArticleDetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        activityIndicator.stopAnimating()
        refreshControl.endRefreshing()
        perform(#selector(showWkWebView), with: self, afterDelay: 0.2)
    }

    @objc func showWkWebView() {
        wkWebView.isHidden = false
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.startAnimating()
        wkWebView.isHidden = true
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
        refreshControl.endRefreshing()
    }
}
