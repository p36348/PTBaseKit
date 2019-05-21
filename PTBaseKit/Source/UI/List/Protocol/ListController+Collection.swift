//
//  ListController+Collection.swift
//  PTBaseKit
//
//  Created by P36348 on 21/05/2019.
//  Copyright © 2019 P36348. All rights reserved.
//

import UIKit

/// 可复用cell
public protocol ReusableCell {
    var viewModel: ReusableCellViewModel? {get set}
    func setup(viewModel: ReusableCellViewModel)
}


public protocol ReusableCellViewModel {
    var cellClass: AnyClass {get}
    var size: CGSize {get}
    var performWhenSelect: ((IndexPath)->Void)? {get}
}


public extension ReusableCellViewModel {
    var performWhenSelect: ((IndexPath)->Void)? {
        return nil
    }
}


public protocol ReusableSectionViewModel {
    var cellViewModels: [ReusableCellViewModel] {get}
}
