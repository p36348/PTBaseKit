//
//  UIImage+Extensions.swift
//  xiaws-demo
//
//  Created by P36348 on 29/8/2017.
//  Copyright © 2017 YAN YAN. All rights reserved.
//

import UIKit

extension UIImage {
    
    /// 获得一个当前UIImage实例缩放的新UIImage
    ///
    /// - Parameter size: 要缩放的尺寸
    /// - Returns: 缩放后的UIImage实例
    public func scale(to size: CGSize, scale: CGFloat? = nil) -> UIImage {
        let _scale = scale ?? UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(size, false, _scale)
        
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        
        let _image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return _image!
    }
    
    /// 获得一个通过压缩当前UIImage的新UIImage实例
    ///
    /// - Parameter quality: 压缩效果 0~1
    /// - Returns: 压缩后的实例
    public func compress(quality: CGFloat) -> UIImage {
        return UIImage(data: self.jpegData(compressionQuality: quality)!)!
    }

}

