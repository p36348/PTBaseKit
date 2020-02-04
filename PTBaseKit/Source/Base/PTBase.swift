//
//  PTBase.swift
//  PTBaseKit
//
//  Created by P36348 on 24/12/2019.
//  Copyright © 2019 P36348. All rights reserved.
//

import Foundation


public struct PT<Base> {
    
    public let base: Base
    
    public init(_ base: Base) {
        self.base = base
    }
}

/// A type that has PT extensions.
public protocol PTCompatible {
    /// Extended type
    associatedtype CompatibleType

    /// PT extensions.
    static var pt: PT<CompatibleType>.Type { get set }

    /// PT extensions.
    var pt: PT<CompatibleType> { get set }
}

extension PTCompatible {
    /// PT extensions.
    public static var pt: PT<Self>.Type {
        get {
            return PT<Self>.self
        }
        set {
            // this enables using PT to "mutate" base type
        }
    }

    /// PT extensions.
    public var pt: PT<Self> {
        get {
            return PT(self)
        }
        set {
            // this enables using PT to "mutate" base object
        }
    }
}

import class Foundation.NSObject

/// Extend NSObject with `pt` proxy.
extension NSObject: PTCompatible { }
