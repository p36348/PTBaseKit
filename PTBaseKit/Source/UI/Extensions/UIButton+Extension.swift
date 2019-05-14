//
//  UIButton+Extension.swift
//  BaseKit
//
//  Created by P36348 on 06/12/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import UIKit
import RxSwift


extension UIButton {
    public func performWhenClick(action: @escaping ()->Void) -> Disposable {
        return self.rx.controlEvent(UIControl.Event.touchUpInside).subscribe(onNext: { (_) in
            action()
        })
    }
}

// MARK: Count down animation

private var timerKey: String = ""

private var timeCountKey: String = ""

private var preEnableKey: String = ""

private var countDownTitleKey: String = ""

private var preTitleKey: String = ""

private var preTitleColorKey: String = ""

private var observerKey: String = ""

extension UIButton {
    
    public var isCounting: Bool {
        return self.timer != nil
    }
    
    /// 倒计时之前的可用状态
    private var preEnable: Bool {
        set {
            objc_setAssociatedObject(self, &preEnableKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &preEnableKey) as? Bool ?? false
        }
    }
    
    /// 倒计时之前的标题
    private var preTitle: String? {
        set {
            objc_setAssociatedObject(self, &preTitleKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &preTitleKey) as? String ?? ""
        }
    }
    
    /// 倒计时用标题
    private var countDownTitle: String? {
        set {
            objc_setAssociatedObject(self, &countDownTitleKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &countDownTitleKey) as? String ?? ""
        }
    }
    
    /// 倒计时之前的字体(normal状态)
    private var preTitleColor: UIColor? {
        set {
            objc_setAssociatedObject(self, &preTitleColorKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &preTitleColorKey) as? UIColor
        }
    }
    
    private var timeCount: Int {
        set {
            objc_setAssociatedObject(self, &timeCountKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &timeCountKey) as? Int ?? 60
        }
    }
    
    private var countDownObserver: PublishSubject<UIButton> {
        get {
            if let observer = objc_getAssociatedObject(self, &observerKey) as? PublishSubject<UIButton> {
                return observer
            }else {
                let observer = PublishSubject<UIButton>()
                objc_setAssociatedObject(self, &observerKey, observer, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return observer
            }
        }
    }
    
    private var timer: Timer? {
        set {
            objc_setAssociatedObject(self, &timerKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &timerKey) as? Timer
        }
    }
    
    public func startCountDown(count:Int = 60, countDownTitle: String) {
        self.timeCount = count
        
        self.preTitle = self.title(for: .normal) ?? ""
        self.preTitleColor  = titleColor(for: .normal)
        
        self.countDownTitle = countDownTitle
        
        self.setAttributedTitle("\(self.countDownTitle ?? "")(\(self.timeCount))".attributed([.colorUIColor.pt.lightGray)]), for: UIControl.State.disabled)
        
        self.preEnable = self.isEnabled
        self.isEnabled = false
        
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(UIButton.changeTime(_:)), userInfo: nil, repeats: true)
        RunLoop.current.add(self.timer!, forMode: RunLoop.Mode.common)
    }
    
    /// 返回一个Observable,在倒计时完成后会发出信号, 如果不在此处订阅, 倒计时结束后按钮的isEnable会恢复到倒计时前的状态
    public func rx_startCountDown(count:Int = 60, countDownTitle: String) -> Observable<UIButton> {
        self.startCountDown(count: count, countDownTitle: countDownTitle)
        return self.countDownObserver
    }
    
    @objc public func changeTime(_ time:Timer){
        self.timeCount -= 1
        if
            self.timeCount >= 0
        {
            self.setAttributedTitle("\(self.countDownTitle ?? "")(\(self.timeCount))".attributed([.colorUIColor.pt.lightGray)]), for: UIControl.State.disabled)
        }
        else
        {
            self.setAttributedTitle(self.preTitle?.attributed([.colorpreTitleColor ?? UIColor.black)]), for: UIControl.State.disabled)
            
            self.timeCount = 60
            self.isEnabled = self.preEnable
            
            time.invalidate()
            self.timer = nil
            self.countDownObserver.onNext(self)
        }
    }
}

