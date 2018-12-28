//
//  UILabelCss.swift
//  ThinkerBaseKit
//
//  Created by ThinkerVC on 2017/2/28.
//  Copyright © 2017年 ThinkerVC. All rights reserved.
//

import Foundation
import UIKit


public var lableFitSizeCss: UILabelCss = {
    $0.sizeToFit()
}

public func +=(lhsCube: UILabel, rhsCube:String){
    lhsCube.text = rhsCube
}

public func +=(lhsCube: UILabel, rhsCube: UIFont){
    lhsCube.font = rhsCube
}

public func +=(lhsCube: UILabel, rhsCube:CGFloat){
    lhsCube.font = rhsCube.customFont
}

extension Bool {
    public var enableCss: UILabelCss{
        return{
            $0.isEnabled = self
        }
    }
}


extension String {
    public var textCss: UILabelCss{
        return{
            $0.text = self
        }
    }
}

extension UIFont {
    public var css:Css {
            return {
                if let a = $0 as? UILabel{
                    a.font = self
                    return
                }
                if let a = $0 as? UITextView{
                    a.font = self
                    return
                }
                if let a = $0 as? UITextField{
                    a.font = self
                    return
                }
                if let a = $0 as? UIButton{
                    a.titleLabel?.font = self
                    return
                }
            }
        }
}

extension CGFloat{
    public var fontCss:Css {
        return customFont.css
    }
    
    public var regularFontCss: UILabelCss{
        return customRegularFont.css
    }
}

extension Int {
    public var fontCss: Css {
        return self.customFont.css
    }
    
    public var linesCss: UILabelCss {
        return { $0.numberOfLines = self }
    }
}

extension NSTextAlignment {
    public var css: UIViewCss{
        return {
            if let a = $0 as? UILabel {
                a.textAlignment = self
                return
            }
            if let a = $0 as? UITextField {
                a.textAlignment = self
                return
            }
            if let a = $0 as? UITextView {
                a.textAlignment = self
                return
            }
        }
    }
}
