//
//  ListController.swift
//  PTBaseKit
//
//  Created by P36348 on 13/12/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import Foundation
import UIKit


public protocol ListController: class {
    
    associatedtype ListView: UIScrollView
    
    associatedtype ListSectionViewModel
    
    associatedtype ListCellViewModel
    
    var listView: ListView {get}
    
    func beginReload() -> Void
    
    func endUpdating() -> Void
    
    func reload(withCellViewModels viewModels: [ListCellViewModel], isLast: Bool) -> Void
    
    func loadMore(withCellViewModels viewModels: [ListCellViewModel], isLast: Bool) -> Void
    
    func reload(withSectionViewModels viewModels: [ListSectionViewModel], isLast: Bool) -> Void
    
    func loadMore(withSectionViewModels viewModels: [ListSectionViewModel], isLast: Bool) -> Void
    
    func bindItemSelection(action: @escaping (Self, IndexPath) -> Void) -> Void
}

extension ListController {
    public func endUpdating() {
        if let refresh = self.listView.mj_header, refresh.isRefreshing {
            refresh.endRefreshing()
        }
        
        if let refresh = self.listView.mj_footer, refresh.isRefreshing {
            refresh.endRefreshing()
        }
    }
    
    public func beginReload() {
        if let refresh = self.listView.mj_header {
            refresh.beginRefreshing()
        }
    }
}
