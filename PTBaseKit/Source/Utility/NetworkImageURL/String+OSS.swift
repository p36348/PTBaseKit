//
//  Helpers.swift
//  PTBaseKit
//
//  Created by P36348 on 17/01/2018.
//  Copyright © 2018 P36348. All rights reserved.
//

import UIKit

public enum OSSImageOptions {
    case resize(size: CGSize)
    case crop(rect: CGRect)
    
    fileprivate var paddingValue: String {
        switch self {
        case .resize:
            return ""
        case .crop(let rect):
            return "/crop,x_\(rect.minX.toInt),y_\(rect.minY.toInt),w_\(rect.width.toInt),h_\(rect.height.toInt)"
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
    public func ossImageUrl(options: OSSImageOptions) -> String? {
        
        guard
            let url = URL(string: self)
            else
        {
            return nil
        }
        
        let params = "x-oss-process=image" + options.paddingValue
        
        var finalURLString: String
        
        let absURL = url.absoluteString
        
        if let query = url.query {
            finalURLString = absURL.replacingOccurrences(of: query, with: params)
        }
        else {
            finalURLString = absURL + "?" + params
        }
        
        return finalURLString
    }
}

