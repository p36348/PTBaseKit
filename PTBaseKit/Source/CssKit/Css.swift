//
//  Cssa.swift
//  ThinkerBaseKit
//
//  Created by ThinkerVC on 2017/2/28.
//  Copyright © 2017年 ThinkerVC. All rights reserved.
//

import Foundation
import UIKit

public typealias Css               = (NSObject)->()
public typealias UIViewCss         = (UIView)->()
public typealias UILabelCss        = (UILabel)->()
public typealias UIButtonCss       = (UIButton)->()
public typealias UITextFieldCss    = (UITextField)->()
public typealias UITextViewCss     = (UITextView)->()
public typealias UIImageCss        = (UIImage)->()
public typealias UIImageViewCss    = (UIImageView)->()

// MARK: backgroundColor titleColor BackgroundImage
public func +=<T: UIView>(lhsCube: T, rhsCube: UIColor){
    lhsCube.setCss(rhsCube.bgCss)
}

extension UIColor {
    public var bgCss: UIViewCss {
            return { $0.backgroundColor = self }
    }
    
    public var textColorCss: Css {
            return {
                if $0 is UILabel{
                    ($0 as! UILabel).textColor = self
                    return
                }
                if $0 is UIButton{
                    ($0 as! UIButton).setTitleColor(self, for: .normal)
                    return
                }
                if $0 is UITextField{
                    ($0 as! UITextField).textColor = self
                    return
                }
            }
    }
    
    public var titleHColorCss: UIButtonCss {
            return {
                $0.setTitleColor(self, for: .highlighted)
            }
    }
    
    public var bgImgCss: UIButtonCss {
            return {
                $0.setBackgroundImage(self.translateIntoImage(), for: .normal)
            }
        
    }
    public var bgImgHCss: UIButtonCss {
            return {
                $0.setBackgroundImage(self.translateIntoImage(), for: .highlighted)
            }
    }
}



// MARK: text placeholder 
public func +=<T:NSObject>(lhsCube: T, rhsCube:String){
    lhsCube.setCss(rhsCube.css)
}

extension String {
    public var css: Css {
        return
            {
                switch $0 {
                case is UILabel:
                    ($0 as! UILabel).text = self
                case is UIButton:
                    ($0 as! UIButton).setTitle(self, for: UIControlState.normal)
                case is UITextView:
                    ($0 as! UITextView).text = self
                case is UITextField:
                    ($0 as! UITextField).text = self
                default:
                    break
                }
                
        }
    }
    public var placeholderCss: UITextFieldCss {
        return { $0.placeholder = self }
    }
}

extension NSAttributedString {
    public var css: Css {
        return
            {
                switch $0 {
                case is UILabel:
                    ($0 as! UILabel).attributedText = self
                case is UITextView:
                    ($0 as! UITextView).attributedText = self
                case is UITextField:
                    ($0 as! UITextField).attributedText = self
                case is UIButton:
                    ($0 as! UIButton).setAttributedTitle(self, for: UIControlState.normal)
                default:
                    break
                }
        }
    }
}
