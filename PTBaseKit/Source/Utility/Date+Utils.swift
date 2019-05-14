//
//  Date+Utils.swift
//  PTBaseKit
//
//  Created by P36348 on 29/10/2018.
//  Copyright © 2018 P36348. All rights reserved.
//

import Foundation

private let kFormatter = DateFormatter()

extension Date {
    public func string(withFormat format: String = "yyyy-MM-dd") -> String {
        kFormatter.dateFormat = format
        kFormatter.timeZone = TimeZone.current
        return kFormatter.string(from: self)
    }
}
