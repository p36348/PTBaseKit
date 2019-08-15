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

extension Int {
    public var hexColor: UIColor {
        return UIColor(red:CGFloat((self & 0xFF0000) >> 16) / 255 , green: CGFloat((self & 0x00FF00) >> 8) / 255, blue: CGFloat((self & 0x0000FF) ) / 255, alpha: 1.0)
    }
}




