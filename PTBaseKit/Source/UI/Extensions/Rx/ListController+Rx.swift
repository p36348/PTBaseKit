//
//  ListController+Rx.swift
//  PTBaseKit
//
//  Created by P36348 on 08/04/2019.
//  Copyright © 2019 P36348. All rights reserved.
//

import Foundation
import RxSwift


extension Reactive where Base: ListController {
    
    public typealias ListUpdater = (viewModels: [Base.ListSectionViewModel], isLast: Bool)
    
    public typealias ViewModelGenerator = (Base) -> Observable<ListUpdater>
    
    public var refreshing: Observable<Bool> {
        return base.listView.rx.refreshing
    }
    
    public var pullToRefresh: Observable<Base> {
        return base.listView.rx.pullToRefresh.map({ _ in self.base})
    }
    
    public var pullToLoadMore: Observable<Base> {
        return base.listView.rx.pullToLoadMore.map({ _ in self.base})
    }
    
    public func bindRefresh(toGenerator viewModelsGenerator: @escaping ViewModelGenerator) -> Disposable {
        return pullToRefresh.flatMap(viewModelsGenerator)
            .observeOn(MainScheduler.asyncInstance)
            .map { (result) -> Base in
                self.base.reload(withSectionViewModels: result.viewModels, isLast: result.isLast)
                return self.base
        }.subscribe()
    }
    
    public func onError() {
        
    }
    
    public func bindLoadMore(toGenerator viewModelsGenerator: @escaping ViewModelGenerator) -> Disposable {
        return pullToLoadMore.flatMap(viewModelsGenerator)
            .observeOn(MainScheduler.asyncInstance)
            .map { (result) -> Base in
                self.base.loadMore(withSectionViewModels: result.viewModels, isLast: result.isLast)
                return self.base
        }.subscribe()
    }
    
}
