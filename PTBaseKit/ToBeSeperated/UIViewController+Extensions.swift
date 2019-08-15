
//  UIViewController+Extensions.swift
//  AugenClient
//
//  Created by Seal on 16/7/9.
//  Copyright © 2016年 augen. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD
import SnapKit


private var hub: MBProgressHUD?

private var loadingRefCount = 0


extension UIViewController {
    
    public func showToast(_ text: String, duration: TimeInterval = 3 , completeBlock:(()->())? = nil) {
        let hub = MBProgressHUD.showAdded(to: self.view, animated: true)
        hub.mode = .text;
        hub.label.text = text
        hub.label.numberOfLines = 0
        hub.completionBlock = completeBlock
        hub.hide(animated: true, afterDelay: duration)
    }
    
    public func removeLoading() {
        loadingRefCount = 0
        hub?.hide(animated: true)
        hub = nil
    }
    
    public func showLoading() {
        loadingRefCount += 1
        if hub == nil {
            hub = MBProgressHUD.showAdded(to: self.view, animated: true)
        }
    }
    
    public func hideLoading() {
        if hub == nil {
            return
        }
        loadingRefCount -= 1
        if loadingRefCount <= 0 {
            hub?.hide(animated: true)
            hub = nil
        }
    }
}

extension UIViewController {
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

// MARK: - alert
extension UIViewController{
    
    public func presentAlert(title: String ,message: String, force: Bool = false, warning: Bool = false, confirmTitle: String = Resource.alertConfirmTitle, confirmAction: (()->())? = nil) -> UIAlertController {
        var controller = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        if (UIDevice.current.userInterfaceIdiom != .phone){
            controller = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
            let popover = controller.popoverPresentationController
            if (popover != nil){
                popover?.sourceView = self.view
                popover?.sourceRect = CGRect.init(x: kScreenWidth/2, y: kScreenHeight/2, width: 0, height: 0)
                popover?.permittedArrowDirections = UIPopoverArrowDirection.down
            }
        }
        let confirmAction = UIAlertAction(title: confirmTitle, style: warning ? .destructive : .default) { (_) in
            confirmAction?()
        }
        if !force {
            controller.addAction(UIAlertAction(title: Resource.alertCancelTitle, style: UIAlertAction.Style.cancel, handler: nil))
        }
        
        !warning ? confirmAction.setValue(UIColor.pt.main, forKey: "_titleTextColor") : nil
        
        controller.addAction(confirmAction)
        
        self.present(controller, animated: true, completion: nil)
        
        return controller
    }
}


