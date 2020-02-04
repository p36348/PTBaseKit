//
//  Disposer.swift
//  PTBaseKit
//
//  Created by P36348 on 05/02/2020.
//  Copyright © 2020 P36348. All rights reserved.
//

import RxSwift

protocol Disposer {
    var disposableController: DisposableController {get}
}
