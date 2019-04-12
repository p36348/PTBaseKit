//
//  UIViewController+Rx.swift
//  PTBaseKit
//
//  Created by P36348 on 08/04/2019.
//  Copyright © 2019 P36348. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

extension UIViewController {
    
    /// UIViewController的生命周期事件
    public enum LifeCycleEvent {
        case viewDidLoad, viewWillAppear, viewDidAppear, viewWillDisappear, viewDidDisappear
    }
}
// MARK: - 增加rx拓展, 方便在响应式结构中使用.
extension Reactive where Base: UIViewController {
    /// 用于获取生命周期事件的observable
    ///
    /// - Parameter lifeCycleEvent: 生命周期事件
    public func controlEvent(with lifeCycleEvent: UIViewController.LifeCycleEvent) -> ControlEvent<Base> {
        
        switch lifeCycleEvent {
        case .viewDidLoad:
            return ControlEvent(events: sentMessage(#selector(UIViewController.viewDidLoad)).map({ _ in self.base}))
        case .viewDidAppear:
            return ControlEvent(events: sentMessage(#selector(UIViewController.viewDidAppear)).map({ _ in self.base}))
        case .viewWillAppear:
            return ControlEvent(events: sentMessage(#selector(UIViewController.viewWillAppear)).map({ _ in self.base}))
        case .viewDidDisappear:
            return ControlEvent(events: sentMessage(#selector(UIViewController.viewDidDisappear)).map({ _ in self.base}))
        case .viewWillDisappear:
            return ControlEvent(events: sentMessage(#selector(UIViewController.viewWillDisappear)).map({ _ in self.base}))
        }
    }
    
    public var viewDidLoad: ControlEvent<Base> {
        return controlEvent(with: .viewDidLoad)
    }
    
    public var viewDidAppear: ControlEvent<Base> {
        return controlEvent(with: .viewDidAppear)
    }
    
    public var viewWillAppear: ControlEvent<Base> {
        return controlEvent(with: .viewWillAppear)
    }
    
    public var viewDidDisappear: ControlEvent<Base> {
        return controlEvent(with: .viewDidDisappear)
    }
    
    public var viewWillDisappear: ControlEvent<Base> {
        return controlEvent(with: .viewWillDisappear)
    }
}


extension Reactive where Base: UIViewController {
    public func present(viewController: UIViewController) -> Observable<Base> {
        return Observable.create({  (observer) -> Disposable in
            self.base.present(viewController, animated: true, completion: {
                observer.onNext(self.base)
                observer.onCompleted()
            })
            return Disposables.create()
        })
    }
    
    public func dismiss() -> Observable<Base> {
        return Observable.create({ (observer) -> Disposable in
            self.base.dismiss(animated: true, completion: {
                observer.onNext(self.base)
                observer.onCompleted()
            })
            return Disposables.create()
        })
    }
}
