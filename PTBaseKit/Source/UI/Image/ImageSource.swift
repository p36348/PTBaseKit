//
//  ImageSource.swift
//  PTBaseKit
//
//  Created by P36348 on 30/01/2018.
//  Copyright © 2018 P36348. All rights reserved.
//

import UIKit
import Kingfisher

public enum ImageSourceType {
    case string(String), url(URL), image(UIImage), data(Data)
}

public protocol ImageSource {
    
    var type: ImageSourceType {get}
    
    var targetSize: CGSize {get}
    
    var css: UIViewCss? {get}
    
    var rawData: ImageRawData {get}
    
    var placeHolder: ImageRawData? {get}
}

extension ImageSource {
    public var targetSize: CGSize {
        return CGSize.zero
    }
}

struct DefaultImageSource: ImageSource {
    
    var placeHolder: ImageRawData? = nil
    
    var type: ImageSourceType
    {
        return self.rawData.type
    }
    
    var css: UIViewCss?
    
    var rawData: ImageRawData
    
    var targetSize: CGSize
    
    init(rawData: ImageRawData, placeHolder: ImageRawData?, css: UIViewCss?, targetSize: CGSize?) {
        self.rawData = rawData
        self.css = css
        self.placeHolder = placeHolder
        if let _targetSize = targetSize {
            self.targetSize = _targetSize
        }else {
            self.targetSize = .zero
        }
    }
}

public protocol ImageRawData: ImageSource {
    
}

extension ImageRawData {
    
    public var placeHolder: ImageRawData? {
        return self
    }
    
    public func imageSource(placeHolder: ImageRawData? = nil, css: UIViewCss?, targetSize: CGSize? = nil) -> ImageSource {
        return DefaultImageSource(rawData: self, placeHolder: placeHolder, css: css, targetSize: targetSize)
    }
}

public func imageSource(with rawData: ImageRawData, placeHolder: ImageRawData? = nil, css: UIViewCss?, targetSize: CGSize? = nil) -> ImageSource {
    return DefaultImageSource(rawData: rawData, placeHolder: placeHolder, css: css, targetSize: targetSize)
}


extension ImageRawData {
    
    public var css: UIViewCss? {
        return nil
    }
    
    public var rawData: ImageRawData {
        return self
    }
}

extension String: ImageRawData {
    
    public var type: ImageSourceType
    {
        return .string(self)
    }
}

extension URL: ImageRawData {
    public var type: ImageSourceType
    {
        return .url(self)
    }
}

extension UIImage: ImageRawData {
    
    public var targetSize: CGSize {
        return self.size
    }
    
    public var type: ImageSourceType
    {
        return .image(self)
    }
}

extension Data: ImageRawData {
    
    public var type: ImageSourceType
    {
        return .data(self)
    }
}


public protocol ImageSetable {
    func setupImage(with imageSource: ImageSource?)
}



extension UIButton: ImageSetable {
    
    public func setupImage(with imageSource: ImageSource?) {
        
        guard let source = imageSource else {return self.setImage(nil, for: UIControl.State.normal)}
        
        if
            let imageView = self.imageView,
            let css = source.css
        {
            imageView += css
        }
        
        //TODO: Kingfisher 的 UIButton 没有添加loading 菊花
        
        switch
            source.type
        {
        case .string(let string):
            self.kf.setImage(with: URL(string: string),
                             for: UIControl.State.normal,
                             placeholder: imageSource?.placeHolder?.imageValue,
                             options: [.scaleFactor(UIScreen.main.scale)],
                             progressBlock: nil,
                             completionHandler: nil)
        case .url(let url):
            self.kf.setImage(with: url,
                             for: UIControl.State.normal,
                             placeholder: imageSource?.placeHolder?.imageValue,
                             options: [.scaleFactor(UIScreen.main.scale)],
                             progressBlock: nil,
                             completionHandler: nil)
        case .data(let data):
            self.setImage(UIImage(data: data), for: UIControl.State.normal)
        case .image(let image):
            self.setImage(image, for: UIControl.State.normal)
        }
    }
}

extension UIImageView: ImageSetable {
    
    public func setupImage(with imageSource: ImageSource?) {
        
        guard let source = imageSource else {return (self.image = nil)}
        
        if
            let css = source.css
        {
            self += css
        }
        
        self.kf.indicatorType = .activity
        
        switch
            source.type
        {
        case .string(let string):
            self.kf.setImage(with: URL(string: string),
                             placeholder: imageSource?.placeHolder?.imageValue,
                             options: [.scaleFactor(UIScreen.main.scale)],
                             progressBlock: nil,
                             completionHandler: nil)
        case .url(let url):
            self.kf.setImage(with: url,
                             placeholder: source.placeHolder?.imageValue,
                             options: [.scaleFactor(UIScreen.main.scale)],
                             progressBlock: nil,
                             completionHandler: nil)
        case .data(let data):
            self.image = UIImage(data: data)
        case .image(let image):
            self.image = image
        }
    }
}

extension ImageRawData {
    var imageValue: UIImage? {
        switch self.type {
        case .image:
            return self.rawData as? UIImage
        case .data:
            return UIImage(data: self.rawData as! Data)
        case .url:
            return UIImage(contentsOfFile: (self.rawData as! URL).absoluteString)
        case .string:
            return UIImage(contentsOfFile: self.rawData as! String)
        }
    }
}

