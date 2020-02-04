//
//  WKWebView+Intercept.swift
//  PTBaseKit
//
//  Created by P36348 on 24/12/2019.
//  Copyright © 2019 P36348. All rights reserved.
//

import Foundation
import WebKit

@available(iOS 11, *)
public class URLSchemeHandler: NSObject, WKURLSchemeHandler {
    
    var scheme: String = ""
    
    var startHandler: ((WKURLSchemeTask) -> Void)? = nil
    
    var stopHandler: ((WKURLSchemeTask) -> Void)? = nil
    
    public init(scheme: String, startHandler: ((WKURLSchemeTask) -> Void)?, stopHandler: ((WKURLSchemeTask) -> Void)? = nil) {
        super.init()
        self.scheme = scheme
        self.startHandler = startHandler
        self.stopHandler = stopHandler
    }
    
    public func webView(_ webView: WKWebView, start urlSchemeTask: WKURLSchemeTask) {
        self.startHandler?(urlSchemeTask)
    }
    
    public func webView(_ webView: WKWebView, stop urlSchemeTask: WKURLSchemeTask) {
        self.stopHandler?(urlSchemeTask)
    }
}


