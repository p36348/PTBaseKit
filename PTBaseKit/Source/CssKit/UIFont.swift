//
//  UIFont.swift
//  ThinkerBaseKit
//
//  Created by ThinkerVC on 2017/2/28.
//  Copyright © 2017年 ThinkerVC. All rights reserved.
//

import Foundation
import UIKit

let os = ProcessInfo().operatingSystemVersion

private var fontName: String {
    switch (os.majorVersion, os.minorVersion, os.patchVersion) {
    case (8, _, _):
        return "Helvetica"
    case (9, _, _):
        break
    case (10, _, _):
        break
    case (11, _, _):
        break
    default:
        break
    }
    return "PingFangSC"
}

let iosVersion  = (UIDevice.current.systemVersion as NSString).floatValue

extension CGFloat{
    public var customMediumFont: UIFont {
        return UIFont(name: fontName, size: self) ?? UIFont.systemFont(ofSize: self)
    }
    
    public var customRegularFont: UIFont {
        return UIFont(name: "\(fontName)-Regular", size: self) ?? UIFont.systemFont(ofSize: self)
    }
    
    public var customFont: UIFont {
        return UIFont.init(name: "\(fontName)-Light", size: self) ?? UIFont.systemFont(ofSize: self)
    }
    
}


extension Int{
    public var customMediumFont: UIFont{
        return CGFloat(self).customMediumFont
    }
    
    public var customRegularFont: UIFont{
        return CGFloat(self).customRegularFont
    }
    
    public var customFont: UIFont{
        return CGFloat(self).customFont
    }
}

extension Double{
    public var customMediumFont: UIFont{
        return CGFloat(self).customMediumFont
    }
    public var customRegularFont: UIFont{
        return CGFloat(self).customRegularFont
    }
    public var customFont: UIFont{
        return CGFloat(self).customFont
    }
}
extension Float{
    public var customMediumFont: UIFont{
        return CGFloat(self).customMediumFont
    }
    public var customRegularFont: UIFont{
        return CGFloat(self).customRegularFont
    }
    public var customFont: UIFont{
        return CGFloat(self).customFont
    }
}


