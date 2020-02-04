//
//  MessageHandler.swift
//  PTBaseKit
//
//  Created by P36348 on 24/12/2019.
//  Copyright © 2019 P36348. All rights reserved.
//

import Foundation
import WebKit

/// JS交互处理(消息从JS传递到Native)
public class MessageHandler: NSObject, WKScriptMessageHandler {
    
    /// 处理闭包
    var handler: (WKScriptMessage) -> Void
    
    /// 唯一标识
    var identifier: String
    
    public init(identifier: String, handler: @escaping (WKScriptMessage)->Void) {
        self.identifier = identifier
        self.handler = handler
    }
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        self.handler(message)
    }
}
