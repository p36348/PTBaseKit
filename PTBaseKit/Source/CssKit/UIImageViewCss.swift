//
//  UIImageViewCss.swift
//  ThinkerBaseKit
//
//  Created by ThinkerVC on 2017/3/1.
//  Copyright © 2017年 ThinkerVC. All rights reserved.
//

import UIKit

public func +=(lhsCube: UIImageView, rhsCube: UIImage?) {
    lhsCube.image = rhsCube
}

extension UIImage{
    public var css: UIImageViewCss {
        return{
            $0.image = self
        }
    }
    
    public var hCss: UIImageViewCss {
        return{
            $0.highlightedImage = self
        }
    }
}
























