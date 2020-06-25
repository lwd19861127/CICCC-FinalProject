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
    private var loadingView: UIView!


    var article: Article! {
      didSet {
        
      }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        
        ///LoadingView
        setupLoadingView()
        
        ///WebView
        setupWebView()
    }
    
    fileprivate func setupLoadingView() {
        loadingView = UIView()
        let loadingImage = UIImageView(image: UIImage(systemName: "globe"))
        loadingView.addSubview(loadingImage)
        loadingImage.centerXYin(loadingView)
        view.addSubview(loadingView)
        loadingView.matchParent()
    }
    
    fileprivate func setupWebView() {
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        wkWebView = webView

        webView.isHidden = true
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        let myURL = URL(string:"https://mp.weixin.qq.com/s/rq6Ixtvry65XZZKhIt3qZw")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        view.addSubview(webView)
        webView.matchParent()
    }
}

extension ArticleDetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIView.animate(withDuration: 0.8) {
            self.loadingView.isHidden = true
            self.wkWebView.isHidden = false
        }
    }
}
