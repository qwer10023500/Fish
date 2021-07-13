//
//  QHDetailWebViewController.swift
//  Fishs
//
//  Created by 小孩 on 2021/7/13.
//

import UIKit
import WebKit

class QHDetailWebViewController: QHWebViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftItem = UIBarButtonItem(title: "back", style: .done, target: nil, action: nil)
        leftItem.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            if self.webView.canGoBack {
                self.webView.goBack()
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }).disposed(by: rx.disposeBag)
        navigationItem.leftBarButtonItem = leftItem
        
        webView.navigationDelegate = self
    }
}

// MARK: WKNavigationDelegate
extension QHDetailWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        QHLog(error)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        QHLog(webView.url)
    }
}
