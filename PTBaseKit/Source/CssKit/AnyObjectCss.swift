//
//  AnyObjectCss.swift
//  ThinkerBaseKit
//
//  Created by ThinkerVC on 2017/2/28.
//  Copyright © 2017年 ThinkerVC. All rights reserved.
//

import Foundation

extension NSObject{
    public func setCss<T:NSObject>(_ css: (T)->() ...){
        if self is T {
            css.forEach{$0(self as! T)}
        }
        else{
            fatalError("类型错误: \(T.self)的css不能赋值给\(self.classForCoder)")
        }
    }
}
