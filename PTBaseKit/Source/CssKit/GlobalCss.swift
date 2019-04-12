//
//  GlobalCss.swift
//  PTBaseKit
//
//  Created by P36348 on 2018/4/24.
//  Copyright © 2018 P36348. All rights reserved.
//

import Foundation
import UIKit

func setup(mainColorHex: Int, normalGradientStartHex: Int, normalGradientEndHex: Int, highlightedGradientStartHex: Int, highlightedGradientEndHex: Int, noticeRedColorHex: Int, emptyHighlightedGradientStartHex: Int, emptyHighlightedGradientEndHex: Int) {
    
    // update base colors
    
    UIColor.pt.main                          = mainColorHex.hexColor
    UIColor.pt.noticeRed                     = noticeRedColorHex.hexColor
    UIColor.pt.normalGradientStart           = normalGradientStartHex.hexColor
    UIColor.pt.normalGradientEnd             = normalGradientEndHex.hexColor
    UIColor.pt.disableGradientStart          = normalGradientStartHex.hexColor.withAlphaComponent(0.5)
    UIColor.pt.disableGradientEnd            = normalGradientEndHex.hexColor.withAlphaComponent(0.5)
    UIColor.pt.highlightedGradientStart      = highlightedGradientStartHex.hexColor
    UIColor.pt.highlightedGradientEnd        = highlightedGradientEndHex.hexColor
    UIColor.pt.emptyHighlightedGradientStart = emptyHighlightedGradientStartHex.hexColor.withAlphaComponent(0.2)
    UIColor.pt.emptyHighlightedGradientEnd   = emptyHighlightedGradientEndHex.hexColor.withAlphaComponent(0.2)
    // update additional css
    
    // uiview css
    spliteCss          = UIColor.pt.splite.bgCss + CGRect(x: 0, y: 0, width: kScreenWidth, height: onepixel).css
    
    boardCss           = onepixel.borderCss + UIColor.pt.gray.borderCss
    
    //textFieldCss
    textFieldCss        = UIColor.pt.black.textColorCss + NSTextAlignment.left.css + 15.fontCss
    
    //labelCss
    labelCss            = UIColor.pt.black.textColorCss + NSTextAlignment.center.css + 15.fontCss + lableFitSizeCss
    
    labelLCss           = UIColor.pt.black.textColorCss + NSTextAlignment.left.css + 15.fontCss + lableFitSizeCss
    
    border              = 3.cornerRadiusCss + onepixel.borderCss + NSTextAlignment.center.css
    
    labelSelectedCss    = UIColor.pt.main.borderCss + UIColor.pt.main.textColorCss + (0xE6EFFF.hexColor).bgCss + border
    
    labeNormalCss       = UIColor.pt.gray.borderCss + UIColor.pt.black.textColorCss + UIColor.pt.white.bgCss + border
    
    // button css
    
    buttonNormalImg      = CAGradientLayer([UIColor.pt.normalGradientStart, UIColor.pt.normalGradientEnd], windowsFrame).toImage
    
    buttonhighlightedImg = CAGradientLayer([UIColor.pt.highlightedGradientStart, UIColor.pt.highlightedGradientEnd], windowsFrame).toImage
    
    buttonDisableImg     = CAGradientLayer([UIColor.pt.disableGradientStart, UIColor.pt.disableGradientEnd], windowsFrame).toImage
    
    emptyButtonSelectedImg = CAGradientLayer([UIColor.pt.emptyHighlightedGradientStart, UIColor.pt.emptyHighlightedGradientEnd], windowsFrame).toImage
    
    buttonImgCss        = buttonNormalImg.bgCss + buttonhighlightedImg.bgHCss + buttonDisableImg.bgDisableCss
    
    buttonBaseCss       = 3.cornerRadiusCss + clipsToBounds(true)
    
    buttonCss           = [buttonBaseCss, buttonImgCss, UIColor.white.textColorCss]
    
    buttonNormalCss     = buttonCss + enable(true)
    
    buttonDisableCss    = buttonCss + enable(false)
}



// uiview css
public private(set) var spliteCss: UIViewCss = UIColor.pt.splite.bgCss + CGRect(x: 0, y: 0, width: kScreenWidth, height: onepixel).css

public private(set) var boardCss: UIViewCss = onepixel.borderCss + UIColor.pt.gray.borderCss

//textFieldCss
public private(set) var textFieldCss: UITextFieldCss = UIColor.pt.black.textColorCss + NSTextAlignment.left.css + 15.fontCss

//labelCss
public private(set) var labelCss: UILabelCss = UIColor.pt.black.textColorCss + NSTextAlignment.center.css + 15.fontCss + lableFitSizeCss

public private(set) var labelLCss: UILabelCss = UIColor.pt.black.textColorCss + NSTextAlignment.left.css + 15.fontCss + lableFitSizeCss

public private(set) var border = 3.cornerRadiusCss + onepixel.borderCss + NSTextAlignment.center.css

public private(set) var labelSelectedCss: UIViewCss = UIColor.pt.main.borderCss + UIColor.pt.main.textColorCss + (0xE6EFFF.hexColor).bgCss + border

public private(set) var labeNormalCss       = UIColor.pt.gray.borderCss + UIColor.pt.black.textColorCss + UIColor.pt.white.bgCss + border

// button css

public private(set) var buttonNormalImg: UIImage      = CAGradientLayer([UIColor.pt.normalGradientStart, UIColor.pt.normalGradientEnd], windowsFrame).toImage

public private(set) var buttonhighlightedImg: UIImage = CAGradientLayer([UIColor.pt.highlightedGradientStart, UIColor.pt.highlightedGradientEnd], windowsFrame).toImage

public private(set) var buttonDisableImg: UIImage     = CAGradientLayer([UIColor.pt.disableGradientStart, UIColor.pt.disableGradientEnd], windowsFrame).toImage

public private(set) var emptyButtonNormalImg: UIImage = CAGradientLayer([UIColor.white, UIColor.white], windowsFrame).toImage

public private(set) var emptyButtonSelectedImg: UIImage = CAGradientLayer([UIColor.pt.emptyHighlightedGradientStart, UIColor.pt.emptyHighlightedGradientEnd], windowsFrame).toImage

public private(set) var buttonImgCss: UIButtonCss = buttonNormalImg.bgCss + buttonhighlightedImg.bgHCss + buttonDisableImg.bgDisableCss

public private(set) var buttonBaseCss: UIViewCss = 3.cornerRadiusCss + clipsToBounds(true)

public private(set) var buttonCss: [UIButtonCss] = [buttonBaseCss, buttonImgCss, UIColor.white.textColorCss]

public private(set) var buttonNormalCss    = buttonCss + enable(true)

public private(set) var buttonDisableCss   = buttonCss + enable(false)


