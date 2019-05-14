//
//  CustomTableNodeController.swift
//  PTBaseKit
//
//  Created by P36348 on 20/06/2018.
//  Copyright © 2018 P36348. All rights reserved.
//

import UIKit
import RxSwift

class CustomTableNodeController: BaseController {
    override func performSetup() {
        testTableNodeController(on: self)
    }
}

private func testTableNodeController(on controller: BaseController) {
    let table = DefaultTableController()
    
    table.config.loadAutomatically = true
    
    table.bindReloadDataGenerator {
        Observable.just(.sections(viewModels: createSectionNodeModels(), isLast: false))
    }
    
    table.bindLoadMoreDataGenerator {
        Observable.just(.sections(viewModels: createSectionNodeModels(), isLast: true))
    }
    
    table.tableDidReload.subscribe(onNext: nil, onError: nil).disposed(by: controller)
    
    table.tableDidLoadMore.subscribe(onNext: nil, onError: nil).disposed(by: controller)
    
    controller.view.addSubview(table.view)
    controller.addChild(table)
}

private func createSectionNodeModels() -> [TableSectionNodeModel] {
    let numberOfSection = 20
    return (0..<numberOfSection).map { _ in DefaultTableSectionNodeModel(header: nil,
                                                                         footer: nil,
                                                                         cellViewModels: createCellNodeModels()) }
}

private func createCellNodeModels() -> [TableCellNodeModel] {
    return
        (0...Int(arc4random_uniform(4)))
            .map {_ in
                return DefaultTableCellNodeModel(head: images[Int(arc4random_uniform(4))],
                                                 title: cellTitles[Int(arc4random_uniform(4))].appending(subTitles[Int(arc4random_uniform(4))]),
                                                 tail: ButtonContentOptions.attributedString("Click Me".attributed([.font(17.customMediumFont), .colorUIColor.pt.main)])),
                                                 accessorable: Int(arc4random_uniform(4))%2 == 1)}
}
