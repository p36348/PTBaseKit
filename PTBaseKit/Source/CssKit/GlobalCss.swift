//
//  GlobalCss.swift
//  ThinkerBaseKit
//
//  Created by P36348 on 2018/4/24.
//  Copyright © 2018 P36348. All rights reserved.
//

import Foundation
import UIKit

public func setup(mainColorHex: Int, normalGradientStartHex: Int, normalGradientEndHex: Int, highlightedGradientStartHex: Int, highlightedGradientEndHex: Int, noticeRedColorHex: Int) {
    
    // update base colors
    
    UIColor.tk.main                     = mainColorHex.hexColor
    UIColor.tk.noticeRed                = noticeRedColorHex.hexColor
    UIColor.tk.normalGradientStart      = normalGradientStartHex.hexColor
    UIColor.tk.normalGradientEnd        = normalGradientEndHex.hexColor
    UIColor.tk.disableGradientStart     = normalGradientStartHex.hexColor.withAlphaComponent(0.5)
    UIColor.tk.disableGradientEnd       = normalGradientEndHex.hexColor.withAlphaComponent(0.5)
    UIColor.tk.highlightedGradientStart = highlightedGradientStartHex.hexColor
    UIColor.tk.highlightedGradientEnd   = highlightedGradientEndHex.hexColor
    
    // update additional css
    
    // uiview css
    spliteCss          = UIColor.tk.splite.bgCss + CGRect(x: 0, y: 0, width: kScreenWidth, height: onepixel).css
    
    boardCss           = onepixel.borderCss + UIColor.tk.gray.borderCss
    
    //textFieldCss
    textFieldCss        = UIColor.tk.black.textColorCss + NSTextAlignment.left.css + 15.fontCss
    
    //labelCss
    labelCss            = UIColor.tk.black.textColorCss + NSTextAlignment.center.css + 15.fontCss + lableFitSizeCss
    
    labelLCss           = UIColor.tk.black.textColorCss + NSTextAlignment.left.css + 15.fontCss + lableFitSizeCss
    
    border              = 3.cornerRadiusCss + onepixel.borderCss + NSTextAlignment.center.css
    
    labelSelectedCss    = UIColor.tk.main.borderCss + UIColor.tk.main.textColorCss + (0xE6EFFF.hexColor).bgCss + border
    
    labeNormalCss       = UIColor.tk.gray.borderCss + UIColor.tk.black.textColorCss + UIColor.tk.white.bgCss + border
    
    // button css
    
    buttonNormalImg      = CAGradientLayer([UIColor.tk.normalGradientStart, UIColor.tk.normalGradientEnd], windowsFrame).toImage
    
    buttonhighlightedImg = CAGradientLayer([UIColor.tk.highlightedGradientStart, UIColor.tk.highlightedGradientEnd], windowsFrame).toImage
    
    buttonDisableImg     = CAGradientLayer([UIColor.tk.disableGradientStart, UIColor.tk.disableGradientEnd], windowsFrame).toImage
    
    
    buttonImgCss        = buttonNormalImg.bgCss + buttonhighlightedImg.bgHCss + buttonDisableImg.bgDisableCss
    
    buttonBaseCss       = 3.cornerRadiusCss + clipsToBounds(true)
    
    buttonCss           = [buttonBaseCss, buttonImgCss, UIColor.white.textColorCss]
    
    buttonNormalCss     = buttonCss + enable(true)
    
    buttonDisableCss    = buttonCss + enable(false)
}

// MARK: - base colors
extension UIColor {
    public struct tk {
        /// 主题色
        static public fileprivate(set) var main                     = 0xffbb4a.hexColor
        /// 背景色
        static public fileprivate(set) var background               = 0xf5f5f5.hexColor
        /// 分割线
        static public fileprivate(set) var splite                   = 0xe5e5e5.hexColor
        /// 辅助灰
        static public fileprivate(set) var lightGray                = 0xb2b2b2.hexColor
        /// 黑色
        static public fileprivate(set) var black                    = UIColor.black
        /// 深灰色
        static public fileprivate(set) var gray                     = 0x888888.hexColor
        /// 提示红
        static public fileprivate(set) var noticeRed                = 0xFF4200.hexColor
        /// 可操作渐变起始
        static public fileprivate(set) var normalGradientStart      = 0x000000.hexColor
        /// 可操作渐变结束
        static public fileprivate(set) var normalGradientEnd        = 0x000000.hexColor
        /// 不可操作渐变起始
        static public fileprivate(set) var disableGradientStart     = 0x000000.hexColor
        /// 不可操作渐变起始
        static public fileprivate(set) var disableGradientEnd       = 0x000000.hexColor
        /// 点击状渐变起始
        static public fileprivate(set) var highlightedGradientStart = 0x000000.hexColor
        /// 点击状渐变起始
        static public fileprivate(set) var highlightedGradientEnd   = 0x000000.hexColor
        
        static public fileprivate(set) var white                    = UIColor.white
    }
}

// MARK: - additional css

//edges
public private(set) var small:CGFloat = 12

public private(set) var normal:CGFloat = 25

// uiview css
public private(set) var spliteCss: UIViewCss = UIColor.tk.splite.bgCss + CGRect(x: 0, y: 0, width: kScreenWidth, height: onepixel).css

public private(set) var boardCss: UIViewCss = onepixel.borderCss + UIColor.tk.gray.borderCss

//textFieldCss
public private(set) var textFieldCss: UITextFieldCss = UIColor.tk.black.textColorCss + NSTextAlignment.left.css + 15.fontCss

//labelCss
public private(set) var labelCss: UILabelCss = UIColor.tk.black.textColorCss + NSTextAlignment.center.css + 15.fontCss + lableFitSizeCss

public private(set) var labelLCss: UILabelCss = UIColor.tk.black.textColorCss + NSTextAlignment.left.css + 15.fontCss + lableFitSizeCss

public private(set) var border = 3.cornerRadiusCss + onepixel.borderCss + NSTextAlignment.center.css

public private(set) var labelSelectedCss: UIViewCss = UIColor.tk.main.borderCss + UIColor.tk.main.textColorCss + (0xE6EFFF.hexColor).bgCss + border

public private(set) var labeNormalCss       = UIColor.tk.gray.borderCss + UIColor.tk.black.textColorCss + UIColor.tk.white.bgCss + border

// button css

public private(set) var buttonNormalImg: UIImage      = CAGradientLayer([UIColor.tk.normalGradientStart, UIColor.tk.normalGradientEnd], windowsFrame).toImage

public private(set) var buttonhighlightedImg: UIImage = CAGradientLayer([UIColor.tk.highlightedGradientStart, UIColor.tk.highlightedGradientEnd], windowsFrame).toImage

public private(set) var buttonDisableImg: UIImage     = CAGradientLayer([UIColor.tk.disableGradientStart, UIColor.tk.disableGradientEnd], windowsFrame).toImage


public private(set) var buttonImgCss: UIButtonCss = buttonNormalImg.bgCss + buttonhighlightedImg.bgHCss + buttonDisableImg.bgDisableCss

public private(set) var buttonBaseCss: UIViewCss = 3.cornerRadiusCss + clipsToBounds(true)

public private(set) var buttonCss: [UIButtonCss] = [buttonBaseCss, buttonImgCss, UIColor.white.textColorCss]

public private(set) var buttonNormalCss    = buttonCss + enable(true)

public private(set) var buttonDisableCss   = buttonCss + enable(false)

extension Int {
    public var hexColor: UIColor {
        return UIColor(red:CGFloat((self & 0xFF0000) >> 16) / 255 , green: CGFloat((self & 0x00FF00) >> 8) / 255, blue: CGFloat((self & 0x0000FF) ) / 255, alpha: 1.0)
    }
}

public let windowsFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)

public let onepixel: CGFloat = 1 / UIScreen.main.scale

public let kScreenHeight: CGFloat = UIScreen.main.bounds.height

public let kScreenWidth: CGFloat  = UIScreen.main.bounds.width


