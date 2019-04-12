//
//  ViewFactory.swift
//  PTBaseKit
//
//  Created by P36348 on 01/01/2018.
//  Copyright © 2018 P36348. All rights reserved.
//

import UIKit


public struct ViewFactory {
    public static func createTextField(font: UIFont = 17.customFont, tintColor: UIColor = UIColor.pt.main, keyboardType: UIKeyboardType = .default, isSecureTextEntry: Bool = false) -> UITextField {
        let textField = UITextField()
        textField.backgroundColor = UIColor.white
        textField.font = font
        textField.tintColor = tintColor
        textField.keyboardType = keyboardType
        textField.isSecureTextEntry = isSecureTextEntry
        return textField
    }
    
    public static func createLabel(font: UIFont = 15.customFont, color: UIColor = UIColor.pt.black) -> UILabel {
        let label = UILabel()
        label.font = font
        label.textColor = color
        return label
    }
    
    public static func createEmptyButton(tintColor: UIColor = UIColor.pt.gray, radius: CGFloat = PTBaseKit.buttonRadius) -> UIButton {
        let btn = UIButton(type: UIButton.ButtonType.system)
        btn += tintColor.textColorCss
        btn += 1.borderCss
        btn += tintColor.borderCss
        btn += radius.cornerRadiusCss
        return btn
    }
    
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
    
    public static func createBarButton(with normalImage: UIImage, hightlightedImage: UIImage? = nil) -> UIButton {
        var button: UIButton!
        if #available(iOS 11, *) {
            button = UIButton(type: UIButton.ButtonType.custom)
        }else {
            button = UIButton(frame: CGRect(x: 0, y: 0, width: normalImage.size.width, height: normalImage.size.height))
        }
        button.setImage(normalImage, for: UIControl.State.normal)
        button.setImage(hightlightedImage, for: UIControl.State.highlighted)
        return button
    }
    
    public static func createBarButton(title: NSAttributedString?, disabledTitle: NSAttributedString? = nil) -> UIButton {
        let button: UIButton = UIButton(type: UIButton.ButtonType.system)
        if #available(iOS 11, *) {
            
            
        }else {
            if let size = title?.size() {
                button.frame = CGRect(x: 0, y: 0, width: size.width + 20, height: size.height)
            }
        }
        button.setAttributedTitle(title, for: UIControl.State.normal)
        if let _disabledTitle = disabledTitle {
            button.setAttributedTitle(_disabledTitle, for: UIControl.State.disabled)
        }
        return button
    }
    
    public static func createBarButtonItem(_ image: UIImage?) -> UIBarButtonItem {
        return UIBarButtonItem(image: image, style: UIBarButtonItem.Style.plain, target: nil, action: nil)
    }
    
    public static func createBarButtonItem(_ title: String?) -> UIBarButtonItem {
        return UIBarButtonItem(title: title, style: UIBarButtonItem.Style.plain, target: nil, action: nil)
    }
}

extension UITextField {
    public enum Style {
        case normal, underline
    }
}

public class PTTextField: UITextField {
    
    public var contentInsets: UIEdgeInsets = UIEdgeInsets.zero
    
    public var style: Style = .normal
    
    override open func draw(_ rect: CGRect) {
        if self.style == .underline {
            let context = UIGraphicsGetCurrentContext()
            context?.setFillColor(0xDEDFE0.hexColor.cgColor)
            context?.setLineWidth(0.5)
            context?.fill(CGRect(x: 0, y: rect.maxY - 1, width: rect.width, height: 0.5))
        }
    }
    
    
    private func textContentRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + contentInsets.left,
                      y: bounds.origin.y + contentInsets.top,
                      width: bounds.width - contentInsets.left - contentInsets.right,
                      height: bounds.height - contentInsets.top - contentInsets.bottom)
    }
    
    
    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        return self.textContentRect(forBounds: super.textRect(forBounds: bounds))
    }
    
    
    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return self.textContentRect(forBounds: super.editingRect(forBounds: bounds))
    }
    
    
    public override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        let superResult = super.leftViewRect(forBounds: bounds)
        return CGRect(x: superResult.origin.x + contentInsets.left, y: superResult.origin.y + contentInsets.top, width: superResult.width, height: superResult.height - contentInsets.top - contentInsets.bottom)
    }
    
    
    public override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let superResult = super.rightViewRect(forBounds: bounds)
        return CGRect(x: superResult.origin.x - contentInsets.right, y: superResult.origin.y + contentInsets.top, width: superResult.width, height: superResult.height - contentInsets.top - contentInsets.bottom)
    }
}
