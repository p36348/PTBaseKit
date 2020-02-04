//
//  WebController.swift
//  PTBaseKit
//
//  Created by P36348 on 16/12/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import UIKit
import WebKit
import RxSwift

/// Web容器控制器
public class WebController: BaseController {
    
    // MARK: view
    
    public private(set) lazy var webView: WKWebView = {
        return WKWebView(frame: .zero, configuration: configuration)
    }()
    
    private var configuration: WKWebViewConfiguration = WKWebViewConfiguration()
    
    lazy var progressBar: UIProgressView = {
        let bar = UIProgressView(progressViewStyle: .bar)
        bar.tintColor = UIColor.pt.main
        return bar
    }()
    
    lazy var cancelButtonItem: UIBarButtonItem = ViewFactory.createBarButtonItem(Resource.webCancelImage)
    
    lazy var goBackButtonItem: UIBarButtonItem = {
        let item = ViewFactory.createBarButtonItem(Resource.backIndicatorImage)
        item.imageInsets = UIEdgeInsets(top: 0, left: -9, bottom: 0, right: 9)
        return item
    }()
    
    public fileprivate(set) var rightButtonItem: UIBarButtonItem?
    
    // MARK: data
    
    public fileprivate(set) var url: URL?
    
    public fileprivate(set) var request: URLRequest?
    
    public fileprivate(set) var header: [String: String]?
    
    public fileprivate(set) var scriptMessageHandlers: [MessageHandler] = []
    
    public convenience init(url: URL? = nil, header: [String: String]? = nil, jsScript: String? = nil, scriptMessageHandlers: [MessageHandler] = []) {
        self.init(nibName: nil, bundle: nil)
        self.url = url
        self.header = header
        self.scriptMessageHandlers = scriptMessageHandlers
        if let _jsScript = jsScript {
            configuration.userContentController.addUserScript(WKUserScript(source: _jsScript, injectionTime: .atDocumentStart, forMainFrameOnly: false))
        }
        scriptMessageHandlers.forEach { [unowned self] in self.configuration.userContentController.add($0, name: $0.identifier) }
    }
    
    @available(iOS 11, *)
    public convenience init(url: URL? = nil, header: [String: String]? = nil, jsScript: [String] = [], scriptMessageHandlers: [MessageHandler] = [], urlSchemeHandlers: [URLSchemeHandler] = []) {
        self.init(url: url, header: header, jsScript: jsScript.first, scriptMessageHandlers: scriptMessageHandlers)
        urlSchemeHandlers.forEach { [unowned self] in self.configuration.setURLSchemeHandler($0, forURLScheme: $0.scheme)}
    }
    
    public override func performPreSetup() {
        self.addObservers(for: self.webView)
        self.setupUI()
        self.bindObservable()
        self.loadUrl(url: self.url)
    }
    
    func loadUrl(url : URL?) {
        guard let _url = url else {return}
        self.request = URLRequest(url: _url)
        self.request?.allHTTPHeaderFields = self.header
        self.webView.load(self.request!)
    }
    
    private func bindObservable() {
        self.cancelButtonItem.performWhemTap { [weak self] in
            self?.navigationController?.popViewController(animated: true)
            }.disposed(by: self)
        
        self.goBackButtonItem.performWhemTap { [weak self] in
            self?.webView.goBack()
            }.disposed(by: self)
    }
    
    private func setupUI() {
        self.view.addSubview(self.webView)
        self.view.addSubview(self.progressBar)
        
        self.webView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.progressBar.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalTo(self.webView)
        }
        
        self.webView.backgroundColor = UIColor.pt.background
        
        self.navigationItem.setRightBarButton(self.rightButtonItem, animated: true)
    }
    
    private func addObservers(for webView: WKWebView) {
        webView.addObserver(self, forKeyPath: "title", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "canGoBack", options: .new, context: nil)
    }
    
    deinit {
        self.webView.removeObserver(self, forKeyPath: "title")
        self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
        self.webView.removeObserver(self, forKeyPath: "canGoBack")
    }
}

extension WebController {
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let _keyPath = keyPath else {return}
        
        switch _keyPath {
        case "title":
            self.title = change?[NSKeyValueChangeKey.newKey] as? String
        case "estimatedProgress":
            self.updateProgressBar(progress: self.webView.estimatedProgress)
        case "canGoBack":
            self.updateNavigationBar(webCanGoBack: self.webView.canGoBack)
        default:
            return
        }
    }
}

extension WebController {
    func updateProgressBar(progress: Double) {
        
        let _progress = Float(progress)
        
        self.progressBar.setProgress(_progress, animated: true)
        
        if progress >= 1 {
            self.progressBar.animateHidden(true)
        }else {
            self.progressBar.alpha = 1
        }
    }
    func updateNavigationBar(webCanGoBack: Bool) {
        let items = webCanGoBack ? [self.goBackButtonItem, self.cancelButtonItem] : nil
        self.navigationItem.setLeftBarButtonItems(items, animated: true)
    }
}

extension WebController {
    public func setupURL(_ url: URL?, header: [String: String]? = nil) -> WebController {
        self.url = url
        self.header = header
        return self
    }
    
    public func setup(rightBarItem: UIBarButtonItem) -> WebController {
        self.rightButtonItem = rightBarItem
        return self
    }
}
