//
//  Global.swift
//  PTBaseKit
//
//  Created by P36348 on 11/11/2018.
//  Copyright © 2018 P36348. All rights reserved.
//

import UIKit
import MJRefresh

public struct PTBaseKit {
   public static func setupCss(mainColorHex: Int, normalGradientStartHex: Int, normalGradientEndHex: Int, highlightedGradientStartHex: Int, highlightedGradientEndHex: Int, noticeRedColorHex: Int, emptyHighlightedGradientStartHex: Int, emptyHighlightedGradientEndHex: Int) {
        setup(mainColorHex: mainColorHex, normalGradientStartHex: normalGradientStartHex, normalGradientEndHex: normalGradientEndHex, highlightedGradientStartHex: highlightedGradientStartHex, highlightedGradientEndHex: highlightedGradientEndHex, noticeRedColorHex: noticeRedColorHex, emptyHighlightedGradientStartHex: emptyHighlightedGradientStartHex, emptyHighlightedGradientEndHex: emptyHighlightedGradientEndHex)
    }
    
    public static var buttonRadius: CGFloat = 5
}

public let onepixel: CGFloat = 1 / UIScreen.main.scale

// MARK: - base colors
extension UIColor {
    
    public struct pt {
        /// 主题色
        static public  var main                     = 0xffbb4a.hexColor
        /// 背景色
        static public  var background               = 0xf5f5f5.hexColor
        /// 分割线
        static public  var splite                   = 0xe5e5e5.hexColor
        /// 辅助灰
        static public  var lightGray                = 0xb2b2b2.hexColor
        /// 黑色
        static public  var black                    = UIColor.black
        /// 深灰色
        static public  var gray                     = 0x888888.hexColor
        /// 提示红
        static public  var noticeRed                = 0xFF4200.hexColor
        /// 提示红
        static public  var red                      = 0xFF4200.hexColor
        /// 可操作渐变起始
        static public  var normalGradientStart      = 0x000000.hexColor
        /// 可操作渐变结束
        static public  var normalGradientEnd        = 0x000000.hexColor
        /// 不可操作渐变起始
        static public  var disableGradientStart     = 0x000000.hexColor
        /// 不可操作渐变起始
        static public  var disableGradientEnd       = 0x000000.hexColor
        /// 点击状渐变起始
        static public  var highlightedGradientStart = 0x000000.hexColor
        /// 点击状渐变起始
        static public  var highlightedGradientEnd   = 0x000000.hexColor
        /// 空心渐变起始
        static public  var emptyHighlightedGradientStart = 0x000000.hexColor
        /// 空心渐变结束
        static public  var emptyHighlightedGradientEnd = 0x000000.hexColor
        
        static public  var white                    = UIColor.white
    }
}

extension Int {
    public var hexColor: UIColor {
        return UIColor(red:CGFloat((self & 0xFF0000) >> 16) / 255 , green: CGFloat((self & 0x00FF00) >> 8) / 255, blue: CGFloat((self & 0x0000FF) ) / 255, alpha: 1.0)
    }
}




