//
//  RxDisposer.swift
//  PTBaseKit
//
//  Created by P36348 on 05/02/2020.
//  Copyright © 2020 P36348. All rights reserved.
//

import RxSwift

extension DisposableController {
    public struct DisposeIdentifiers {
        public static let `default` = "disposable_controller.default_dispose_identifiers"
    }
}

public class DisposableController {
    
    private lazy var disposeBags: [String: DisposeBag] = [DisposeIdentifiers.default: defaultDisposeBag]
    
    private var defaultDisposeBag: DisposeBag = DisposeBag()
}

extension DisposableController {
    public func add(disposable: Disposable, identifier: String) {
        if
            let bag = self.disposeBags[identifier]
        {
            bag.insert(disposable)
        }
        else
        {
            let bag = DisposeBag()
            bag.insert(disposable)
            self.disposeBags[identifier] = bag
        }
    }
    
    public func dispose(identifier: String) {
        self.disposeBags[identifier] = nil
    }
    
    public func disposeAll() {
        self.disposeBags.removeAll()
        self.defaultDisposeBag = DisposeBag()
    }
}

extension Disposable {
    public func disposed(by disposableController: DisposableController, identifier: String = DisposableController.DisposeIdentifiers.default) {
        disposableController.add(disposable: self, identifier: identifier)
    }
}
