//
//  UIBarButtonItem+Extension.swift
//  PTBaseKit
//
//  Created by P36348 on 24/01/2018.
//  Copyright © 2018 P36348. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension UIBarButtonItem {
    public func performWhemTap(_ action: (()->Void)?) -> Disposable {
        return self.rx.tap.subscribe(onNext: { (_) in
            action?()
        })
    }
}
