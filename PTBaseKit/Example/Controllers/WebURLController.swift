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
        let item = UIButton(type: UIButton.ButtonType.system)
        item.setAttributedTitle("Browse".attributed([.color(UIColor.pt.main)]), for: .normal)
        item.setAttributedTitle("Browse".attributed([.color(UIColor.pt.lightGray)]), for: .disabled)
        return item
    }()
    
    var rx_submit: Observable<String> {
        return self.internalSubmit
    }
    
    private let internalSubmit: PublishSubject<String> = PublishSubject<String>()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        input.text =  "https://h5.duck.app.zhuiyinanian.com/#/test/tx"//"http://192.168.10.30:3000"//"https://h5.duck.app.zhuiyinanian.com/#/test/tx"
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
        
        self.submit.rx.controlEvent(UIControl.Event.touchUpInside)
            .filter {[unowned self] _ in self.input.text != nil}
            .subscribe (onNext: {  [unowned self] (_) in
                self.internalSubmit.onNext(self.input.text!)
            })
            .disposed(by: self)
    }
}
