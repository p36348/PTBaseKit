//
//  UITableView+Extensions.swift
//  PTBaseKit
//
//  Created by P36348 on 09/04/2019.
//  Copyright © 2019 P36348. All rights reserved.
//

import UIKit

extension UITableView {
    public func ptPerformBatchUpdates(_ updates: (()-> Void)?, completion: ((Bool) -> Void)? = nil) {
        if #available(iOS 11.0, *) {
            self.performBatchUpdates(updates, completion: completion)
        }else {
            self.beginUpdates()
            updates?()
            self.endUpdates()
            completion?(true)
        }
    }
}
