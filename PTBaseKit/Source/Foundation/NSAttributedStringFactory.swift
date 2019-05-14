//
//  NSAttributedStringFactory.swift
//  PTBaseKit
//
//  Created by P36348 on 16/12/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import Foundation
import UIKit
public protocol AttributedStringSource {
    var attr: NSMutableAttributedString {get}
    var hasDefaultStyle: Bool {get}
}

extension String: AttributedStringSource {
    public var attr: NSMutableAttributedString {
        return self.attributed()
    }
    public var hasDefaultStyle: Bool {return false}
}

extension NSAttributedString: AttributedStringSource {
    public var attr: NSMutableAttributedString {
        if let _mAttr = self as? NSMutableAttributedString {
            return _mAttr
        }
        return NSMutableAttributedString(attributedString: self)
    }
    public var hasDefaultStyle: Bool {return true}
}


/// 富文本样式枚举
///
/// - color: 文本颜色
/// - font: 文本字体
/// - paragraphStyle: 段落样式
/// - underLine: 下划线
public enum AttributedStringOptions {
    case color(UIColor)
    case font(UIFont)
    case paragraphStyle(lineSpacing: CGFloat?, alignment: NSTextAlignment?)
    case lineBreakMode(NSLineBreakMode)
    case indent(head: CGFloat, tail: CGFloat)
    case underLine(NSUnderlineStyle?,  UIColor?)
    case spacing(CGFloat)
}

extension String {
    
    public func attributed(_ options: [AttributedStringOptions] = [.font(15.customRegularFont), .color(UIColor.pt.gray), .paragraphStyle(lineSpacing: nil, alignment: nil)]) -> NSMutableAttributedString {
        
        var attributes: [NSAttributedString.Key: Any] = [:]
        
        var textColor: UIColor = UIColor.pt.gray
        
        var textFont: UIFont = 15.customRegularFont
        
        let paragraphStyle = NSMutableParagraphStyle()
        
        options.forEach { (option) in
            switch option {
            case .spacing(let spacing):
                attributes[NSAttributedString.Key.kern] = spacing
            case .color(let color):
                textColor = color
            case .font(let font):
                textFont = font
            case .paragraphStyle(let lineSpacing, let alignment):
                if let _alignment = alignment {
                    paragraphStyle.alignment = _alignment
                }
                if let _lineSpacing = lineSpacing {
                    paragraphStyle.lineSpacing = _lineSpacing
                }
            case .lineBreakMode(let lineBreakMode):
                paragraphStyle.lineBreakMode = lineBreakMode
            case .indent(let head, let tail):
                paragraphStyle.firstLineHeadIndent = head
                paragraphStyle.headIndent = head
                paragraphStyle.tailIndent = tail
            case .underLine(let style, let color):
                if let _style = style {
                    attributes[NSAttributedString.Key.underlineStyle] = _style.rawValue
                }
                if let _color = color {
                    attributes[NSAttributedString.Key.underlineColor] = _color
                }
            }
        }
        // fix
        attributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle
        
        attributes[NSAttributedString.Key.foregroundColor] = textColor
        
        attributes[NSAttributedString.Key.font] = textFont
        
        return NSMutableAttributedString(string: self, attributes: attributes)
    }
}

extension NSMutableAttributedString {
    public func appending(_ attr: NSAttributedString) -> NSMutableAttributedString {
        self.append(attr)
        return self
    }
}

public func +<T: NSMutableAttributedString>(left: T, right: NSAttributedString) -> T {
    left.append(right)
    return  left
}

public func +<T: NSMutableAttributedString>(left: T, option: AttributedStringOptions) -> T {
    left.enumerateAttributes(in: NSRange(location: 0, length: left.string.count), options: []) { [weak left] (originalAttribute, range, ptr) in
        var newAttribute = originalAttribute
        
        let paragraphStyle = (newAttribute[NSAttributedString.Key.paragraphStyle] as? NSMutableParagraphStyle) ?? NSMutableParagraphStyle()
        
        switch option {
        case .spacing(let spacing):
            newAttribute[NSAttributedString.Key.kern] = spacing
        case .color(let color):
            newAttribute[NSAttributedString.Key.foregroundColor] = color
        case .font(let font):
            newAttribute[NSAttributedString.Key.font] = font
        case .paragraphStyle(let lineSpacing, let alignment):
            if let _alignment = alignment {
                paragraphStyle.alignment = _alignment
            }
            if let _lineSpacing = lineSpacing {
                paragraphStyle.lineSpacing = _lineSpacing
            }
        case .lineBreakMode(let lineBreakMode):
            paragraphStyle.lineBreakMode = lineBreakMode
        case .indent(let head, let tail):
            paragraphStyle.firstLineHeadIndent = head
            paragraphStyle.headIndent = head
            paragraphStyle.tailIndent = tail
        case .underLine(let style, let color):
            if let _style = style {
                newAttribute[NSAttributedString.Key.underlineStyle] = _style.rawValue
            }
            if let _color = color {
                newAttribute[NSAttributedString.Key.underlineColor] = _color
            }
        }
        left?.addAttributes(newAttribute, range: range)
    }
    return left
}
