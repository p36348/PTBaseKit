//
//  OtherOperator.swift
//  ThinkerBaseKit
//
//  Created by ThinkerVC on 2017/2/28.
//  Copyright © 2017年 ThinkerVC. All rights reserved.
//

import Foundation
import UIKit


public func +=<T: UIView,W: UIView>( lhsCube: T, rhsCube: W){
    lhsCube.addSubview(rhsCube)
}

public func +=<T: UIView>( lhsCube: T, rhsCube: [UIView]){
    rhsCube.forEach{
        lhsCube.addSubview($0)
    }
}

public func +<T: UIView,W: UIView>( lhsCube: T, rhsCube: W)->[UIView]{
    return [lhsCube,rhsCube]
}

public func +=<T:CALayer,W:CALayer>( lhsCube: T, rhsCube: W){
    lhsCube.addSublayer(rhsCube)
}

