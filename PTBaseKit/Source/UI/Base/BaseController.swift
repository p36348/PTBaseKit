//
//  BaseController.swift
//  PTBaseKit
//
//  Created by P36348 on 04/03/2018.
//  Copyright © 2018 P36348. All rights reserved.
//

import UIKit
import RxSwift
//import AsyncDisplayKit

extension BaseController {
    public struct DisposeIdentifiers {
        public static let `default`: String = "default"
    }
}

//public protocol RxViewController {
//    associatedtype E
//    func lifeCycleEvent(with lifeCycleEvent: UIViewController.LifeCycleEvent) -> Observable<E>
//}
//
//extension UIViewController {
//    public enum LifeCycleEvent {
//        case viewDidload, viewWillAppear, viewDidAppear, viewWillDisappear, viewDidDisappear
//    }
//}


/**
 * 基础控制器
 * 为了增加流畅性, 使用 performSetup 函数替代 viewDidLoad 去执行界面初始化工作
 * 接入facebook的texture框架, 进一步提高滑动性能 (暂时去掉)
 */
open class BaseController: UIViewController { //}, RxViewController {
    
//    public typealias E = BaseController
    
    public fileprivate(set) lazy var disposeBags: [String: DisposeBag] = [BaseController.DisposeIdentifiers.default: self.defaultDisposeBag]
    
    public fileprivate(set) var defaultDisposeBag: DisposeBag! = DisposeBag()
    
    
    /// 用于配置viewDidLoad行为, 在不继承的场景下可以使用, 相当于继承之后重载performSetup
    public var performOnViewDidLoad: (BaseController)->Void = { _ in }
    
//    public func lifeCycleEvent(with lifeCycleEvent: LifeCycleEvent) -> Observable<BaseController> {
//        switch lifeCycleEvent {
//        case .viewDidload:
//
//        case .viewDidAppear:
//        case .viewWillAppear:
//        case .viewDidDisappear:
//        case .viewWillDisappear:
//
//        }
//        return Observable.create({ (observer) -> Disposable in
//
//
//            return Disposables.create()
//        })
//    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        self.disposeBags.removeAll()
        self.defaultDisposeBag = nil
        print("\(#function) -- line[\(#line)] -- \((#file as NSString).lastPathComponent)  -- \(self)")
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.performPreSetup()
        
        self.perform(NSSelectorFromString("performSetup"),
                     with: nil,
                     afterDelay: 0.1,
                     inModes: [RunLoop.Mode.default])
    }
    
    /**
     * 非耗时界面初始化操作
     */
    open func performPreSetup() {
        self.view.backgroundColor = UIColor.tk.background
        self.automaticallyAdjustsScrollViewInsets = true
        
        //        if
        //            self.navigationController != nil
        //        {
        //            self.navigationController?.navigationBar.barTintColor = UIColor.tk.white
        //            self.navigationController?.navigationBar.tintColor = UIColor.tk.black
        //            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.tk.black,
        //                                                                            NSAttributedString.Key.font: 18.5.customRegularFont]
        //            self.navigationController?.navigationBar.isTranslucent = false
        //            self.navigationController?.navigationBar.shadowImage = UIImage()
        //
        //            self.navigationController?.navigationBar.backIndicatorImage = PTBaseKit.Resource.backIndicatorImage
        //            self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = PTBaseKit.Resource.backIndicatorTransitionMaskImage
        //
        //            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        //        }
    }
    
    /**
     * 耗时界面初始化操作
     */
    @objc open func performSetup() {
        self.performOnViewDidLoad(self)
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension BaseController {
    public func setupLeftBarItems(_ buttons:UIView...) {
        let negativeIM = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeIM.width = -5
        var barButtons = buttons.map{UIBarButtonItem(customView: $0)}
        barButtons.insert(negativeIM, at: 0)
        self.navigationItem.leftBarButtonItems = barButtons
    }
    
    public func setupRightBarItems(_ buttons:UIView...) {
        let negativeIM = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeIM.width = -5
        var barButtons = buttons.map{UIBarButtonItem(customView: $0)}
        barButtons.insert(negativeIM, at: 0)
        self.navigationItem.rightBarButtonItems = barButtons
    }
    
}

extension BaseController {
    public func dispose(identifier: String = BaseController.DisposeIdentifiers.default) {
        self.disposeBags[identifier] = nil
    }
    
    public func rx_present(viewController: UIViewController) -> Observable<BaseController> {
        return Observable.create({ [unowned self] (observer) -> Disposable in
            self.present(viewController, animated: true, completion: {
                observer.onNext(self)
                observer.onCompleted()
            })
            return Disposables.create()
        })
    }
    
    public func rx_dismiss() -> Observable<BaseController> {
        return Observable.create({ [weak self] (observer) -> Disposable in
            self?.dismiss(animated: true, completion: {
                if let weakSelf = self {
                    observer.onNext(weakSelf)
                    observer.onCompleted()
                }
            })
            return Disposables.create()
        })
    }
}

extension Disposable {
    public func disposed(by controller: BaseController, identifier: String = BaseController.DisposeIdentifiers.default) {
        if
            let bag = controller.disposeBags[identifier]
        {
            bag.insert(self)
        }
        else
        {
            let bag = DisposeBag()
            bag.insert(self)
            controller.disposeBags[identifier] = bag
        }
    }
}

