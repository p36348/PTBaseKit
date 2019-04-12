//
//  TipsController.swift
//  PTBaseKit
//
//  Created by P36348 on 11/01/2018.
//  Copyright © 2018 P36348. All rights reserved.
//

import UIKit


public class TipsController: BaseController {
    
    fileprivate var padding: CGFloat = 15
    
    fileprivate let wrapper: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.pt.white
        view += 5.cornerRadiusCss
        return view
    }()
    
    fileprivate let contentLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    fileprivate let imageView: UIImageView = UIImageView()
    
    fileprivate let confirmBtn: UIButton = ViewFactory.createRoundButton(radius: 3)
    
    fileprivate let dismissBtn: UIButton = ViewFactory.createBarButton(with: #imageLiteral(resourceName: "shut_down_icon"))
    
    // data
    
    fileprivate var confirmAction: (()->Void)? = nil

    override public func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI() {
        self.view.backgroundColor = UIColor.pt.black.withAlphaComponent(0.6)
        
        self.wrapper += [self.contentLabel, self.dismissBtn, self.confirmBtn]
        self.view += [self.wrapper, self.imageView]
        
        self.wrapper.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(280)
            let imageHeight: CGFloat = (self.imageView.image?.size.height ?? 0)/2
            let attr: NSAttributedString? = self.contentLabel.attributedText
            let contentSize = attr?.boundingRect(with: CGSize(width: Double(280 - self.padding*2), height: Double(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil).size
            let contentHeight: CGFloat = contentSize?.height ?? 0
            let height: CGFloat = 35 + 17 + 25 + imageHeight + 11 + contentHeight
            make.height.equalTo(height)
        }
        
        self.imageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(self.wrapper.snp.top)
        }
        
        self.dismissBtn.performWhenClick {
            self.dismiss(animated: true, completion: nil)
            }.disposed(by: self)
        
        self.dismissBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
        }
        
        self.contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.imageView.snp.bottom).offset(11)
            make.leading.equalToSuperview().offset(self.padding)
            make.trailing.equalToSuperview().offset(-self.padding)
        }
        
        _ = self.confirmBtn.performWhenClick {
            self.dismiss(animated: true, completion: {
                self.confirmAction?()
            })
        }
        
        self.confirmBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            if let _attr = self.confirmBtn.titleLabel?.attributedText {
                make.size.equalTo(CGSize(width: _attr.size().width + 48, height: 35))
            }
            make.bottom.equalToSuperview().offset(-20)
        }
    }
}

extension UIViewController {
    public func presentTipsController(image: UIImage?, content: NSAttributedString?, confirmTitle: NSAttributedString?, contentPadding: CGFloat = 15, confirmAction: (()->Void)? = nil) -> TipsController{
        let controller = TipsController()
        controller.modalPresentationStyle = .overCurrentContext
        controller.modalTransitionStyle = .crossDissolve
        controller.padding = contentPadding
        controller.imageView.image = image
        controller.contentLabel.attributedText = content
        controller.contentLabel.numberOfLines = 0
        controller.confirmAction = confirmAction
        controller.confirmBtn.setAttributedTitle(confirmTitle, for: UIControl.State.normal)
        self.present(controller, animated: true, completion: nil)
        return controller
    }
}
