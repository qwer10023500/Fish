//
//  QHNewsViewController.swift
//  Fishs
//
//  Created by 小孩 on 2021/7/9.
//

import UIKit
import WebKit
import MJRefresh

class QHTHSViewController: QHWebViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        if webView.canGoBack {
            webView.goBack()
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}
