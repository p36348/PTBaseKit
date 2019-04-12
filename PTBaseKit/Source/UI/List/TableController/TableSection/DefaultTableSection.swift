//
//  DefaultTableSection.swift
//  PTBaseKit
//
//  Created by P36348 on 2018/4/27.
//  Copyright © 2018 P36348. All rights reserved.
//

import UIKit

public class DefaultTableSectionView: UITableViewHeaderFooterView, TableSectionHeaderFooter {
    public var viewModel: TableSectionHeaderFooterViewModel?
    
    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor.pt.background
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setup(with viewModel: TableSectionHeaderFooterViewModel) {
        guard let _viewModel = viewModel as? DefaultTableSectionHeaderFooterViewModel else {return}
        self.viewModel = viewModel
        if let _backgroundCss = _viewModel.backgroundCss {
            self.contentView += _backgroundCss
        }
    }
}


public class DefaultTableSectionHeaderFooterViewModel: TableSectionHeaderFooterViewModel {
    
    public var viewClass: AnyClass = DefaultTableSectionView.self
    
    public var height: CGFloat
    
    var backgroundCss: UIViewCss?
    
    init(backgroundCss: UIViewCss? = nil, height: CGFloat = 10) {
        self.backgroundCss = backgroundCss
        self.height = height
    }
    
}
