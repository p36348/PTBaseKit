//
//  String+QN.swift
//  PTBaseKit
//
//  Created by P36348 on 14/08/2019.
//  Copyright © 2019 P36348. All rights reserved.
//

import UIKit

enum ScaleOption {
    case matchDevice, value(CGFloat)
}

/*
 把URLString 转换成七牛云格式URL, 利用七牛云的API做裁剪
 https://developer.qiniu.com/dora/manual/1279/basic-processing-images-imageview2
 */
extension String {
    /*
     裁剪中间部分
     */
    func qnCropCenterURL(targetSize: CGSize, scaleOption: ScaleOption = .value(1.8)) -> String? {
        
        let width: Int
        let height: Int
        
        if case let .value(value) = scaleOption {
            width = Int(targetSize.width * value)
            height = Int(targetSize.height * value)
        }else {
            width = Int(targetSize.width * UIScreen.main.scale)
            if targetSize.height == 0 {
                height = Int(1 * UIScreen.main.scale)
            }else{
                height = Int(targetSize.height * UIScreen.main.scale)
                
            }
        }
        
        guard
            let url = URL(string: self)
            else
        {
            return nil
        }
        
        let params = "imageView2/1/w/\(width)/h/\(height)"
        
        var finalURLString: String
        
        let absURL = url.absoluteString
        
        if let query = url.query {
            finalURLString = absURL.replacingOccurrences(of: query, with: params)
        }
        else {
            finalURLString = absURL + "?" + params
        }
        
        return finalURLString
    }
}
