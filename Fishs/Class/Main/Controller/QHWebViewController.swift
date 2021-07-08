//
//  QHWebViewController.swift
//  KEEP
//
//  Created by 小孩 on 2020/11/3.
//

import WebKit

class QHWebViewController: QHBaseViewController {

    fileprivate(set) var url: URL?
    
    convenience init(_ url: URL?, title: String? = nil) {
        self.init()
        self.url = url
        self.title = title
    }
    
    fileprivate(set) lazy var webView: WKWebView = {
        let view = WKWebView()
        view.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        return view
    }()
    
    fileprivate(set) lazy var progressView = UIProgressView()
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let value = change?[NSKeyValueChangeKey.newKey] as? Double, keyPath == "estimatedProgress" else { return }
        progressView.setProgress(Float(value), animated: true)
        if value > 0.95 { progressView.isHidden = true }
    }
    
    override func structureUI() {
        super.structureUI()
        
        view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide)
            } else {
                make.top.equalToSuperview()
            }
        }
        
        view.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide)
            } else {
                make.top.equalToSuperview()
            }
            make.height.equalTo(2)
        }
        
        guard let `url` = url else { return }
        webView.load(URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData))
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
}
