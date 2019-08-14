//
//  ImageSource+css.swift
//  PTBaseKit
//
//  Created by P36348 on 2018/4/26.
//  Copyright © 2018 P36348. All rights reserved.
//

import Foundation
import UIKit

public typealias ImageSetableCss = (ImageSetable) -> ()

extension ImageSource {
    public var imageSourceCss: ImageSetableCss {
        return {  $0.setupImage(with: self) }
    }
    
    public var buttonCss: UIButtonCss {
        return  { $0.setupImage(with: self) }
    }
}
