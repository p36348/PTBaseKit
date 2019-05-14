//
//  TextFieldController.swift
//  PTBaseKit
//
//  Created by P36348 on 26/12/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import UIKit


public class TextFieldController: BaseController {
    
    var maximumLength: Int = 20
    
    public let textField: UITextField = {
        let tf = UITextField()
        tf.textColor = UIColor.pt.gray
        tf.tintColor = UIColor.pt.main
        tf.backgroundColor = UIColor.pt.white
        tf += 3.cornerRadiusCss
        tf.textAlignment = .left
        let leftGapView = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 15, height: 44)))
        tf.leftView = leftGapView
        tf.leftViewMode = .always
        tf.clearButtonMode = .always
        return tf
    }()
    
    let doneButton: UIButton = ViewFactory.createBarButton(title: PTBaseKit.Resource.textFieldDoneTitle.attributed([.color(UIColor.pt.main)]),
                                                           disabledTitle: PTBaseKit.Resource.textFieldDoneTitle.attributed([.color(UIColor.pt.lightGray)]))
    
    var doneAction: ((TextFieldController, String?)->Void)? = nil
    
    
    public override func performSetup() {
        super.performSetup()
        self.setupUI()
        self.bindObservable()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.textField.isEnabled {
            self.textField.becomeFirstResponder()
        }
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupUI() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.doneButton)
        
        self.view.addSubview(self.textField)
        
        self.textField.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(self.topOffset + 10)
            make.height.equalTo(44)
            make.leading.trailing.equalToSuperview()
        }
        
    }
    
    private func bindObservable() {
        self.textField.rx
            .controlEvent(UIControl.Event.editingChanged)
            .subscribe(onNext: { [unowned self] () in
                guard
                    let text = self.textField.text,
                    let count = self.textField.text?.count,
                    count >= self.maximumLength
                    else
                {return}
                self.textField.text = text.substring(with: text.startIndex..<text.index(text.startIndex, offsetBy: self.maximumLength))
                }, onError: nil)
            .disposed(by: self)
        
        self.doneButton.performWhenClick { [unowned self] in
            self.doneAction?(self, self.textField.text)
            }
            .disposed(by: self)
        
        self.textField.rx.text
            .map {$0 != nil && $0?.isEmpty == false}
            .bind(to: self.doneButton.rx.isEnabled)
            .disposed(by: self)
    }
}

extension TextFieldController {
    
    public func setup(title: String, text: String? = nil, placeHolder: String? = nil, maximumLength: Int = 20, doneBtnTitle: String? = nil, keyboardType: UIKeyboardType = .default) -> TextFieldController{
        self.title = title
        self.textField.text = text
        self.textField.placeholder = placeHolder
        self.textField.keyboardType = keyboardType
        self.maximumLength = maximumLength
        if let _doneBtnTitle = doneBtnTitle {
            self.doneButton.setAttributedTitle(_doneBtnTitle.attributed([.color(UIColor.pt.main)]), for: UIControl.State.normal)
            self.doneButton.setAttributedTitle(_doneBtnTitle.attributed([.color(UIColor.pt.lightGray)]), for: UIControl.State.disabled)
        }
        return self
    }
    
    public func performWhenClickDone(action: @escaping ((TextFieldController, String?)->Void)) -> TextFieldController{
        self.doneAction = action
        return self
    }
}

