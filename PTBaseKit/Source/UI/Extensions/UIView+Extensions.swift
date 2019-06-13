//
//  UIView+Extensions.swift
//  PTBaseKit
//
//  Created by P36348 on 06/12/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import UIKit


extension UIView {
    public func performWhenTap(action: @escaping ()->Void) {
        let tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
        _ = tap.rx.event.subscribe(onNext: { tap in
            action()
        })
    }
    
    public func removeAllGestrue() {
        if gestureRecognizers != nil{
            for g in gestureRecognizers!{
                self.removeGestureRecognizer(g)
            }
        }
    }
}

extension UIView {
    public func animateHidden(_ flag: Bool) {
        UIView.animate(withDuration: 0.25) {
            self.alpha = !flag ? 1 : 0
        }
    }
}

private var timerKey: String = ""

extension UIView {
    
    private var timer: Timer? {
        get {
            return objc_getAssociatedObject(self, &timerKey) as? Timer
        }
        set {
            objc_setAssociatedObject(self, &timerKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public func startRotation() {
        
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = 2 * Double.pi
        anim.duration = 1
        anim.repeatCount = 3
        anim.isRemovedOnCompletion = true
        self.layer.add(anim, forKey: "rotation")
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1 * 3, target: self, selector: NSSelectorFromString("startRotation"), userInfo: nil, repeats: false)
        
    }
    
    public func stopRotation() {
        timer?.invalidate()
    }
}
