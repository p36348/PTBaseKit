//
//  Int+HexColor.swift
//  PTBaseKit
//
//  Created by P36348 on 15/08/2019.
//  Copyright © 2019 P36348. All rights reserved.
//

import UIKit

extension Int {
    public var hexColor: UIColor {
        return
            UIColor(
                red:CGFloat((self & 0xFF0000) >> 16) / 255 ,
                green: CGFloat((self & 0x00FF00) >> 8) / 255,
                blue: CGFloat((self & 0x0000FF) ) / 255,
                alpha: 1.0)
    }
}
