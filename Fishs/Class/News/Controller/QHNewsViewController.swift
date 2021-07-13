//
//  QHNewsViewController.swift
//  Fishs
//
//  Created by 小孩 on 2021/7/9.
//

import UIKit
import WebKit
import MJRefresh

class QHNewsViewController: QHWebViewController {

    @IBOutlet weak var backItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.navigationDelegate = self
        backItem.isEnabled = webView.canGoBack
        
        guard let url = URL(string: "https://m.10jqka.com.cn") else { return }
        webView.load(URLRequest(url: url))
        
        MJRefreshNormalHeader { [weak self] in
            guard let `self` = self else { return }
            self.webView.reload()
            self.webView.scrollView.mj_header?.endRefreshing()
        }.autoChangeTransparency(true)
        .link(to: webView.scrollView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func backAction(_ sender: UIBarButtonItem) {
        webView.goBack()
    }
}

// MARK: WKNavigationDelegate
extension QHNewsViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        backItem.isEnabled = webView.canGoBack
    }
}
