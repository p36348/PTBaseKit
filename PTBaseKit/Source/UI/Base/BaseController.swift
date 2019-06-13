//
//  BaseController.swift
//  PTBaseKit
//
//  Created by P36348 on 04/03/2018.
//  Copyright © 2018 P36348. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

extension BaseController {
    public struct DisposeIdentifiers {
        public static let `default`: String = "default"
    }
}

/**
 * 基础控制器
 * 为了增加流畅性, 使用 performSetup 函数替代 viewDidLoad 去执行界面初始化工作
 * 接入facebook的texture框架, 进一步提高滑动性能 (暂时去掉)
 */
open class BaseController: UIViewController {
    
    public fileprivate(set) lazy var disposeBags: [String: DisposeBag] = [BaseController.DisposeIdentifiers.default: self.defaultDisposeBag]
    
    public fileprivate(set) var defaultDisposeBag: DisposeBag! = DisposeBag()
    
    
    /// 用于配置viewDidLoad行为, 在不继承的场景下可以使用, 相当于继承之后重载performSetup
    public var performOnViewDidLoad: (BaseController)->Void = { _ in }

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
        self.view.backgroundColor = UIColor.pt.background
        self.automaticallyAdjustsScrollViewInsets = true
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
    public func dispose(identifier: String = BaseController.DisposeIdentifiers.default) {
        self.disposeBags[identifier] = nil
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

