//
//  ListController+Rx.swift
//  PTBaseKit
//
//  Created by P36348 on 08/04/2019.
//  Copyright © 2019 P36348. All rights reserved.
//

import Foundation
import RxSwift

private var refreshErrorKey = ""
private var loadMoreErrorKey = ""
private var updateErrorKey = ""

extension Reactive where Base: ListController {
    
    public typealias SectionUpdater = (viewModels: [Base.ListSectionViewModel], isLast: Bool)
    
    public typealias CellUpdater = (viewModels: [Base.ListCellViewModel], isLast: Bool)
    
    public typealias SectionViewModelGenerator = (Base) -> Observable<SectionUpdater>
    
    public typealias CellViewModelGenerator = (Base) -> Observable<CellUpdater>
    
    /// 是否正在刷新状态
    public var refreshing: Observable<Bool> {
        return base.listView.rx.refreshing
    }
    
    /// 拖拽刷新事件
    public var pullToRefresh: Observable<Base> {
        return base.listView.rx.pullToRefresh.map({ _ in self.base})
    }
    
    /// 拖拽加载更多事件
    public var pullToLoadMore: Observable<Base> {
        return base.listView.rx.pullToLoadMore.map({ _ in self.base})
    }
    
    /// 刷新报错
    public var refreshError: Observable<Error> {
        return internal_refreshError.share()
    }
    
    /// 加载更多报错
    public var loadMoreError: Observable<Error> {
        return internal_loadMoreError.share()
    }
    
    /// 更新报错(包括刷新和加载)
    public var updateError: Observable<Error> {
        return internal_updateError.share()
    }
    
    public func bindRefresh(toGenerator viewModelsGenerator: @escaping SectionViewModelGenerator) -> Disposable {
        return pullToRefresh.flatMap({(_base) in
            viewModelsGenerator(_base).observeOn(MainScheduler.asyncInstance)
                .map { (result) -> Base in
                    self.base.reload(withSectionViewModels: result.viewModels, isLast: result.isLast)
                    return self.base
                }
                .catchError({ (err) -> Observable<Base> in
                    self.base.endUpdating()
                    self.internal_refreshError.onNext(err)
                    self.internal_updateError.onError(err)
                    return Observable.of(self.base)
                })
        })
            .subscribe()
    }
    
    public func bindLoadMore(toGenerator viewModelsGenerator: @escaping SectionViewModelGenerator) -> Disposable {
        return pullToLoadMore.flatMap({ (_base) in
            viewModelsGenerator(_base).observeOn(MainScheduler.asyncInstance)
                .map { (result) -> Base in
                    self.base.loadMore(withSectionViewModels: result.viewModels, isLast: result.isLast)
                    return self.base
                }
                .catchError({ (err) -> Observable<Base> in
                    self.base.endUpdating()
                    self.internal_loadMoreError.onNext(err)
                    self.internal_updateError.onError(err)
                    return Observable.of(self.base)
                })
        })            .subscribe()
    }
    
    public func bindRefresh(toGenerator viewModelsGenerator: @escaping CellViewModelGenerator) -> Disposable {
        return pullToRefresh.flatMap({(_base) in
            viewModelsGenerator(_base).observeOn(MainScheduler.asyncInstance)
                .map { (result) -> Base in
                    self.base.reload(withCellViewModels: result.viewModels, isLast: result.isLast)
                    return self.base
                }
                .catchError({ (err) -> Observable<Base> in
                    self.base.endUpdating()
                    self.internal_refreshError.onNext(err)
                    self.internal_updateError.onError(err)
                    return Observable.of(self.base)
                })
        })
            .subscribe()
    }
    
    public func bindLoadMore(toGenerator viewModelsGenerator: @escaping CellViewModelGenerator) -> Disposable {
        return pullToLoadMore.flatMap({ (_base) in
            viewModelsGenerator(_base).observeOn(MainScheduler.asyncInstance)
                .map { (result) -> Base in
                    self.base.loadMore(withCellViewModels: result.viewModels, isLast: result.isLast)
                    return self.base
                }
                .catchError({ (err) -> Observable<Base> in
                    self.base.endUpdating()
                    self.internal_loadMoreError.onNext(err)
                    self.internal_updateError.onError(err)
                    return Observable.of(self.base)
                })
        })            .subscribe()
    }
    
    // MARK: private
    private var internal_refreshError: PublishSubject<Error> {
        get {
            if let subject = objc_getAssociatedObject(base, &refreshErrorKey) as? PublishSubject<Error> {
                return subject
            }
            let subject = PublishSubject<Error>()
            objc_setAssociatedObject(base, &refreshErrorKey, subject, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return subject
        }
    }

    private var internal_loadMoreError: PublishSubject<Error> {
        get {
            if let subject = objc_getAssociatedObject(base, &loadMoreErrorKey) as? PublishSubject<Error> {
                return subject
            }
            let subject = PublishSubject<Error>()
            objc_setAssociatedObject(base, &loadMoreErrorKey, subject, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return subject
        }
    }

    private var internal_updateError: PublishSubject<Error> {
        get {
            if let subject = objc_getAssociatedObject(base, &updateErrorKey) as? PublishSubject<Error> {
                return subject
            }
            let subject = PublishSubject<Error>()
            objc_setAssociatedObject(base, &updateErrorKey, subject, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return subject
        }
    }
}
