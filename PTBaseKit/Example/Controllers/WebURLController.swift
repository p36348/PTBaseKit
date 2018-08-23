//
//  WebURLController.swift
//  PTBaseKit
//
//  Created by P36348 on 23/08/2018.
//  Copyright © 2018 P36348. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class WebURLController: BaseController {
    
    lazy var input: UITextField = ViewFactory.createTextField()
    
    lazy var submit: UIButton = {
        let item = UIButton(type: UIButtonType.system)
        item.setAttributedTitle("Browse".attributed([.textColor(UIColor.tk.main)]), for: .normal)
        item.setAttributedTitle("Browse".attributed([.textColor(UIColor.tk.lightGray)]), for: .disabled)
        return item
    }()
    
    var rx_submit: Observable<String> {
        return self.internalSubmit
    }
    
    private let internalSubmit: PublishSubject<String> = PublishSubject<String>()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func performSetup() {
        self.view.addSubview(self.input)
        self.view.addSubview(self.submit)
        
        self.input.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalTo(45)
            make.width.equalTo(200)
        }
        self.submit.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.input)
            make.top.equalTo(self.input.snp.bottom).offset(10)
        }
        
        self.input.rx.value
            .map({$0?.isEmpty == false})
            .bind(to: self.submit.rx.isEnabled)
            .disposed(by: self)
        
        self.submit.rx.controlEvent(UIControlEvents.touchUpInside)
            .subscribe (onNext: {  [weak self] () in
                if let _self = self, let text = self?.input.text {
                    _self.internalSubmit.onNext(text)
                }
            }).disposed(by: self)
    }
}
