//
//  SystemInfo.swift
//  PTBaseKit
//
//  Created by P36348 on 14/06/2018.
//  Copyright © 2018 P36348. All rights reserved.
//

import Foundation

public var applicationVersion: String {
    return "version \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? "") build \(Bundle.main.infoDictionary?["CFBundleVersion"] ?? "")"
}
