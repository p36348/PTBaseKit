//
//  DispatchQueue+Rx.swift
//  PTBaseKit
//
//  Created by P36348 on 13/03/2018.
//  Copyright © 2018 ThinkerVC. All rights reserved.
//

import Foundation
import RxSwift

extension Reactive where Base: DispatchQueue {
    public func async<T>(with obj: T, afterDelay timeInterval: TimeInterval = 0) -> Observable<T> {
        return Observable
            .create({ (observer) -> Disposable in
                self.base.asyncAfter(deadline: DispatchTime.now() + timeInterval,
                                execute: {
                                        observer.onNext(obj)
                                        observer.onCompleted()
                })
                return Disposables.create()
            })
    }
}
