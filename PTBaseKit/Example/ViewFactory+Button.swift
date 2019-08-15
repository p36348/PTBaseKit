//
//  ViewFactory+Button.swift
//  PTBaseKit
//
//  Created by P36348 on 15/08/2019.
//  Copyright © 2019 P36348. All rights reserved.
//

import Foundation

extension ViewFactory {
    public static func createGradientButton(cornerRadius: CGFloat? = nil) -> UIButton {
        let button = UIButton(type: UIButton.ButtonType.system)
        button += buttonCss
        if let _cornerRadius = cornerRadius {
            button += _cornerRadius.cornerRadiusCss
        }
        return button
    }
    
    public static func createRoundButton(tintColor: UIColor = UIColor.pt.white, radius: CGFloat = PTBaseKit.buttonRadius) -> UIButton {
        let btn = UIButton(type: UIButton.ButtonType.system)
        btn += radius.cornerRadiusCss
        btn += buttonImgCss
        btn += tintColor.textColorCss
        return btn
    }
}
