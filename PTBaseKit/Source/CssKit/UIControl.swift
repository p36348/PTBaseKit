//
//  UIControl.swift
//  tulip
//
//  Created by ThinkerVC on 2017/3/14.
//  Copyright © 2017年 ThinkerVC. All rights reserved.
//

import Foundation
import UIKit

public typealias UIControlCss = (UIControl)->()

public func enable(_ value:Bool) -> UIControlCss {
    return {
        $0.isEnabled = value
    }
}
