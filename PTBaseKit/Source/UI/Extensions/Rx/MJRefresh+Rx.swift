//
//  MJRefresh+Rx.swift
//  PTBaseKit
//
//  Created by P36348 on 14/08/2018.
//  Copyright © 2018 P36348. All rights reserved.
//

import Foundation
import MJRefresh
import RxSwift

private var internal_rx_refreshing_key = "internal_rx_refreshing_key"
private var internal_rx_pullToRefresh_key = "internal_rx_pullToRefresh_key"
private var internal_rx_pullToLoadMore_key = "internal_rx_pullToLoadMore_key"

extension Reactive where Base: UIScrollView {
    
    public var refreshing: Observable<Bool> {
        return internal_rx_refreshing.share()
    }
    
    private var internal_rx_refreshing: PublishSubject<Bool> {
        get {
            guard let item = objc_getAssociatedObject(base, &internal_rx_refreshing_key) as? PublishSubject<Bool> else {
                let item = PublishSubject<Bool>()
                objc_setAssociatedObject(base, &internal_rx_refreshing_key, item, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return item
            }
            return item
        }
    }
    
    private var internal_rx_pullToRefresh: PublishSubject<Base> {
        get {
            guard let item = objc_getAssociatedObject(base, &internal_rx_pullToRefresh_key) as? PublishSubject<Base> else {
                let item = PublishSubject<Base>()
                objc_setAssociatedObject(base, &internal_rx_pullToRefresh_key, item, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return item
            }
            return item
        }
    }
    
    private var internal_rx_pullToLoadMore: PublishSubject<Base> {
        get {
            guard let item = objc_getAssociatedObject(base, &internal_rx_pullToLoadMore_key) as? PublishSubject<Base> else {
                let item = PublishSubject<Base>()
                objc_setAssociatedObject(base, &internal_rx_pullToLoadMore_key, item, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return item
            }
            return item
        }
    }

    
    public func beginReload() -> Observable<Base> {
        if let footer = base.mj_footer, !footer.isRefreshing {
            footer.beginRefreshing()
            return Observable.just(base)
        }
        else {
            return Observable.error(NSError(domain: "没有定义刷新操作", code: 0, userInfo: nil))
        }
    }
    
    public func beginLoadMore() -> Observable<Base> {
        if let footer = base.mj_footer, !footer.isRefreshing {
            footer.beginRefreshing()
            return Observable.just(base)
        }
        else {
            return Observable.error(NSError(domain: "没有定义刷新操作", code: 0, userInfo: nil))
        }
    }
    
    public func stopLoading() -> Observable<Base> {
        if base.mj_header?.isRefreshing == true {
            base.mj_header.endRefreshing()
        }
        if base.mj_footer?.isRefreshing == true {
            base.mj_footer.endRefreshing()
        }
        self.internal_rx_refreshing.onNext(false)
        return Observable.of(base)
    }
    
    public var pullToRefresh: Observable<Base> {
        if base.mj_header == nil {
            base.mj_header = MJRefreshNormalHeader()
            base.mj_header.refreshingBlock = {
                self.internal_rx_refreshing.onNext(true)
                self.internal_rx_pullToRefresh.onNext(self.base)
                self.base.mj_footer?.isHidden = false
            }
        }
        
        return internal_rx_pullToRefresh.share()
    }
    
    public var pullToLoadMore: Observable<Base> {
        if base.mj_footer == nil {
            base.mj_footer = MJRefreshAutoStateFooter()
            base.mj_footer.refreshingBlock = {
                self.internal_rx_refreshing.onNext(true)
                self.internal_rx_pullToLoadMore.onNext(self.base)
            }
            base.mj_footer.isHidden = true
        }
        
        return internal_rx_pullToLoadMore.share()
    }
}
