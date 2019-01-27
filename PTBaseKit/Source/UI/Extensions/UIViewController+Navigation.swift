//
//  UIViewController+Navigation.swift
//  PTBaseKit
//
//  Created by P36348 on 20/11/2018.
//  Copyright © 2018 P36348. All rights reserved.
//

import UIKit


// MARK: - 针对普通的ViewController的navigation相关封装, 本身是NavigationViewController不适用
extension UIViewController {
    
    public func customPush(to viewController: UIViewController) {
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    public func customPop(){
        self.navigationController?.popViewController(animated: true)
    }
    
    public var navigationBarHeight: CGFloat {
        return self.navigationController?.navigationBar.bounds.height ?? 0
    }
    
    // 顶部位移(controller全屏幕的时候才适用)
    public var topOffset: CGFloat {
        
        var result: CGFloat = custom_safeAreaInsets.top
        
        if self.navigationController?.navigationBar.isTranslucent == false {
            result -= self.navigationBarHeight
        }
        
        return result
    }
    
    public var custom_safeAreaInsets: UIEdgeInsets {
        get {
            let insets: UIEdgeInsets
            if #available(iOS 11.0, *) {
                insets = self.view.safeAreaInsets
            } else {
                insets = UIEdgeInsets(top: UIApplication.shared.statusBarFrame.height, left: 0, bottom: 0, right: 0)
            }
            return insets
        }
    }
}
