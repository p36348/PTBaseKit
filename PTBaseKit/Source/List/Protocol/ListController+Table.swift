//
//  ListController+Table.swift
//  PTBaseKit
//
//  Created by P36348 on 09/04/2019.
//  Copyright © 2019 P36348. All rights reserved.
//

import UIKit

public protocol TableSection: class {
    var viewModel: TableSectionViewModel? {get}
}

public protocol TableSectionViewModel {
    
    var header: TableSectionHeaderFooterViewModel? {get}
    
    var footer: TableSectionHeaderFooterViewModel? {get}
    
    var cellViewModels: [TableCellViewModel] {get}
}

public protocol TableSectionHeaderFooter: class {
    
    var viewModel: TableSectionHeaderFooterViewModel? {get}
    
    func setup(with viewModel: TableSectionHeaderFooterViewModel)
}

public protocol TableSectionHeaderFooterViewModel {
    
    var viewClass: AnyClass {get}
    
    var height: CGFloat {get}
}

public protocol TableCell: class {
    
    var viewModel: TableCellViewModel? {get}
    
    func setup(with viewModel: TableCellViewModel)
}

public protocol TableCellViewModel {
    
    var cellClass: AnyClass {get}
    
    var canEdit: Bool {get}
    
    var editActions: [UITableViewRowAction]? {get}
    
    var height: CGFloat {get}
    
    var performWhenSelect: ((UITableView, IndexPath)->Void)? {get}
}

// MARK: - 默认实现
extension TableCellViewModel {
    
    /// 不响应选择操作
    public var performWhenSelect: ((UITableView, IndexPath)->Void)? {
        return nil
    }
    
    /// 不可编辑
    public var canEdit: Bool { return false }
    
    /// 没有编辑行为
    public var editActions: [UITableViewRowAction]? {return nil}
}
