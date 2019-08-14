//
//  Constants.swift
//  PTBaseKit
//
//  Created by P36348 on 14/08/2019.
//  Copyright © 2019 P36348. All rights reserved.
//

import UIKit

public var kSafeAreInsets: UIEdgeInsets {
    if #available(iOS 11.0, *) {
        return UIApplication.shared.delegate?.window??.safeAreaInsets ?? UIEdgeInsets.zero
    } else {
        return UIEdgeInsets(top: UIApplication.shared.statusBarFrame.height, left: 0, bottom: 0, right: 0)
    }
}

public let windowsFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)

public let kScreenHeight = UIScreen.main.bounds.height

public let kScreenWidth = UIScreen.main.bounds.width
