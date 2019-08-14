//
//  Configuration.swift
//  PTBaseKit
//
//  Created by P36348 on 14/08/2019.
//  Copyright © 2019 P36348. All rights reserved.
//

import UIKit
import MJRefresh

public struct PTBaseKitConfig {
    
    public static var color: ColorConfig = kDefaultColorConfig
    
    public static var font: FontConfig = kDefaultFontConfig
    
    public static var scrollRefresh: ScrollRefreshConfig = kDefaultScrollRefreshConfig
}

public struct ColorConfig {
    public let textDefault: UIColor
}

public struct FontConfig {
    public let textDefault: UIFont
}

public struct ScrollRefreshConfig {
    
    public let headerCreator: () -> MJRefreshHeader
    
    public let footerCreator: () -> MJRefreshFooter
    
    public init(headerCreator: @escaping () -> MJRefreshHeader, footerCreator: @escaping () -> MJRefreshFooter) {
        self.headerCreator = headerCreator
        self.footerCreator = footerCreator
    }
}

private let kDefaultColorConfig: ColorConfig =
    ColorConfig(textDefault: UIColor.black)

private let kDefaultFontConfig: FontConfig =
    FontConfig(textDefault: 15.customRegularFont)

private let kDefaultScrollRefreshConfig: ScrollRefreshConfig =
    ScrollRefreshConfig(headerCreator: { MJRefreshNormalHeader() },
                        footerCreator: { MJRefreshAutoFooter() })
