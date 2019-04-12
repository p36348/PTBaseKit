//
//  Helpers.swift
//  PTBaseKit
//
//  Created by P36348 on 17/01/2018.
//  Copyright © 2018 P36348. All rights reserved.
//

import UIKit

public enum OSSImageOptions {
    case resize(width: Numberable, height: Numberable)
    case crop(width: Numberable, height: Numberable, x:  Numberable, y: Numberable)
    case autoOrient
    case format
    
    fileprivate var paddingValue: String {
        switch self {
        case .resize:
            return ""
        case .crop(let width, let height, let x, let y):
            return "/crop,x_\(x.toInt),y_\(y.toInt),w_\(width.toInt),h_\(height.toInt)"
        case .autoOrient:
            return ""
        case .format:
            return ""
        }
    }
}

public protocol Numberable {
    var toInt: Int64 {get}
}

extension Numberable {
    public var toInt: Int64 {
        switch self {
        case is Int:
            return NSNumber(value: self as! Int).int64Value
        case is Int32:
            return NSNumber(value: self as! Int32).int64Value
        case is Int64:
            return self as! Int64
        case is CGFloat:
            return NSNumber(value: Float(self as! CGFloat)).int64Value
        case is Double:
            return NSNumber(value: self as! Double).int64Value
        default:
            return 0
        }
    }
}

extension Int: Numberable {
    
}

extension Int32: Numberable {
    
}

extension Int64: Numberable {
    
}

extension CGFloat: Numberable {
    
}

extension Double: Numberable {
    
}

extension String {
    public func ossImageUrl(options: OSSImageOptions) -> String {
        return self + "?x-oss-process=image" + options.paddingValue
    }
}
