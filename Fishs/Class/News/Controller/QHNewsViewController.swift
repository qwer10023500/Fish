//
//  QHNewsViewController.swift
//  Fishs
//
//  Created by 小孩 on 2021/7/9.
//

import UIKit
import WebKit

class QHNewsViewController: QHWebViewController {

    @IBOutlet weak var backItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.navigationDelegate = self
        backItem.isEnabled = webView.canGoBack
        
        guard let url = URL(string: "https://m.10jqka.com.cn") else { return }
        webView.load(URLRequest(url: url))
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
