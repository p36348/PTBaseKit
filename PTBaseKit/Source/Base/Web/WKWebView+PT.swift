//
//  WKWebView+PT.swift
//  PTBaseKit
//
//  Created by P36348 on 24/12/2019.
//  Copyright © 2019 P36348. All rights reserved.
//

import Foundation
import WebKit

extension WKWebView {
    @available(iOS 11, *)
    public convenience init(jsScripts: [String] = [], scriptMessageHandlers: [MessageHandler] = [], urlSchemeHandlers: [URLSchemeHandler] = []) {
        
        let config = WKWebViewConfiguration()
        
        jsScripts
            .map { WKUserScript(source: $0, injectionTime: .atDocumentStart, forMainFrameOnly: false) }
            .forEach { config.userContentController.addUserScript($0) }
        
        scriptMessageHandlers.forEach { config.userContentController.add($0, name: $0.identifier) }
        
        urlSchemeHandlers.forEach { config.setURLSchemeHandler($0, forURLScheme: $0.scheme) }
        
        self.init(frame: .zero, configuration: config)
    }
}
