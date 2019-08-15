//
//  LoadingController.swift
//  PTBaseKit
//
//  Created by P36348 on 23/11/2017.
//  Copyright © 2017 ThinkerVC. All rights reserved.
//

import UIKit

import RxSwift

public class LoadingController: BaseController {
    
    fileprivate var effectView: UIVisualEffectView = UIVisualEffectView()
    
    fileprivate var views: [UIView] = []
    
    lazy var logo: UIImageView = UIImageView()
    
    fileprivate lazy var progressBar: UIProgressView = {
        let bar = UIProgressView(frame: CGRect.zero)
        bar.trackTintColor = UIColor.clear
        bar.progressTintColor = UIColor.pt.main
        bar.progressViewStyle = UIProgressView.Style.bar
        return bar
    }()
    
    let progressLabel: UILabel = UILabel() + 14.customRegularFont.css
    
    public let stateLabel: UILabel = UILabel() + 14.customRegularFont.css
    
    // data
    
    fileprivate var progressTitle: String = ""
    
    fileprivate var progressTimer: Timer?
    
    fileprivate var timeOutTipsTimer: Timer?
    
    fileprivate var errorChecker: (() -> Bool)? = nil
    
    fileprivate var timeOutDuration: Double = 30
    
    fileprivate var timeoutObservers: [AnyObserver<LoadingController>] = []
    
    public convenience init(loadingLogo: UIImage? = Resource.loadingLogo, progressTitle: String = Resource.loadingProgressTitle, timeout: Double = 30) {
        self.init()
        self.logo.image = loadingLogo
        self.progressTitle = progressTitle
        self.timeOutDuration = timeout
        self.transitioningDelegate = self
        self.modalPresentationStyle = .overCurrentContext
    }
    
    
    public override func performPreSetup() {
        self.views = [self.logo, self.progressBar, self.progressLabel, self.stateLabel]
        
        view += UIColor.clear
        view += [self.effectView] + self.views

        self.effectView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.logo.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(kScreenHeight * 0.35)
        }
        
        self.progressBar.snp.makeConstraints { (make) in
            make.top.equalTo(logo.snp.bottom).offset(17)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: kScreenWidth/3, height: 4))
        }
        
        self.progressLabel.snp.makeConstraints { (make) in
            make.top.equalTo(progressBar.snp.bottom).offset(18)
            make.centerX.equalToSuperview()
        }
        
        self.stateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(progressLabel.snp.bottom).offset(18)
            make.centerX.equalToSuperview()
        }
    }
}

extension LoadingController {
    public func startAnimation() {
        self.progressBar.progress = 0
        self.progressTimer = Timer.scheduledTimer(timeInterval: 1/20, target: self, selector: #selector(performProgress(_:)), userInfo: nil, repeats: true)
        self.timeOutTipsTimer = Timer.scheduledTimer(timeInterval: self.timeOutDuration, target: self, selector: #selector(performTimeout(_:)), userInfo: nil, repeats: false)
        RunLoop.current.add(self.progressTimer!, forMode: RunLoop.Mode.common)
        RunLoop.current.add(self.timeOutTipsTimer!, forMode: RunLoop.Mode.common)
    }
    
    public func completeAnimation(completion: ((Bool) -> Void)? = nil) {
        self.progressTimer?.invalidate()
        self.timeOutTipsTimer?.invalidate()
        let duration = 0.25
        
        UIView.animate(withDuration: duration, animations: {
            self.progressBar.setProgress(1, animated: true)
            self.progressLabel.text = Resource.loadingFinishTitle
            self.progressLabel.alpha = 0
        }, completion: completion)
    }
    
    @objc dynamic private func performProgress(_ sender: Timer) {
        if self.progressBar.progress <= 0.95 {//精度问题,百分比显示有误,加0.01
            self.progressBar.setProgress(self.progressBar.progress + 0.05, animated: true)
            self.progressLabel.text = "\(self.progressTitle) " + "\(Int(self.progressBar.progress/0.01))"  + "%"
        }else {
            self.progressTimer?.invalidate()
        }
    }
    
    @objc dynamic private func performTimeout(_ sender: Timer?) {
        self.progressTimer?.invalidate()
        self.timeoutObservers.forEach {[unowned self] in $0.onNext(self)}
        self.timeoutObservers.removeAll(keepingCapacity: true)
    }
}

extension LoadingController {
    public func rx_completeAnimation() -> Observable<LoadingController> {
        return Observable.create({ [weak self] (observer) -> Disposable in
            if let weakSelf = self { weakSelf.completeAnimation(completion: {_ in observer.onNext(weakSelf)}) }
            return Disposables.create()
        })
    }
    
    public var rx_timeout: Observable<LoadingController> {
        return Observable.create({ (observer) -> Disposable in
            self.timeoutObservers.append(observer)
            return Disposables.create()
        })
    }
}

extension LoadingController: UIViewControllerTransitioningDelegate {
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissTransition()
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentTransition()
    }
}

private let kAnimationDuration = 0.5

private class PresentTransition: NSObject , UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return kAnimationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? LoadingController else { return }
        
        transitionContext.containerView.addSubview(toViewController.view)
        
        UIView.animate(withDuration: kAnimationDuration, animations: {
            if #available(iOS 10, *) {
                toViewController.effectView.effect = UIBlurEffect(style: .prominent)
                
            }else {
                toViewController.effectView.effect = UIBlurEffect(style: .light)
                
            }
            
            toViewController.views.forEach{$0.alpha = 1}
        }) { (finished) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

private class DismissTransition: NSObject , UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return kAnimationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? LoadingController else { return }
        
        transitionContext.containerView.addSubview(fromViewController.view)
        
        UIView.animate(withDuration: kAnimationDuration, animations: {
            fromViewController.view.backgroundColor = .clear
            fromViewController.views.forEach{$0.alpha = 0}
            fromViewController.effectView.effect = nil
        }) { (finished) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

