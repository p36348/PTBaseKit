//
//  IndexController.swift
//  PTBaseKit
//
//  Created by P36348 on 21/08/2018.
//  Copyright © 2018 P36348. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class IndexController: BaseController {
    
    lazy var segmented: UISegmentedControl = {
        let item = UISegmentedControl(items: ["UIKitTable", "ASDKTable", "GoogleMaps", "Utils", "Web"])
        item.tintColor = UIColor.clear
        item.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.tk.main], for: UIControl.State.normal)
        item.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.tk.main, NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue], for: UIControl.State.selected)
        item.selectedSegmentIndex = 0
        return item
    }()
    
    var uikitTable: UIViewController = createTableController()
    
    var asdkTable: CustomTableNodeController = CustomTableNodeController()
    
    var map: UIViewController = createMapController()
    
    var utils: UtilsController = UtilsController()
    
    lazy var web: WebURLController = WebURLController()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func performPreSetup() {
        self.navigationItem.titleView = self.segmented
    }
    
    override func performSetup() {
        
        uikitTable.rx
            .controlEvent(with: .viewDidLoad)
            .subscribe(onNext: { controller in
                print("uikitTable view did load")
            })
            .disposed(by: self)
        
        self.setup(controller: self.uikitTable, segmentIndex: 0)
        self.setup(controller: self.asdkTable, segmentIndex: 1)
        self.setup(controller: self.map, segmentIndex: 2)
        self.setup(controller: self.utils, segmentIndex: 3)
        self.setup(controller: self.web, segmentIndex: 4)
        
        self.web.rx_submit.subscribe(onNext: { [weak self] in self?.navigateWeb(url: $0) }).disposed(by: self)
    }
    
    private func navigateWeb(url: String) {
        self.navigationController?.pushViewController(WebController().setupURL(URL(string: url)), animated: true)
    }
    
    private func setup(controller: UIViewController, segmentIndex: Int) {
        // 添加到背景上
        self.view.addSubview(controller.view)
        controller.view.snp.makeConstraints{$0.edges.equalToSuperview()}
        // 把显示与否绑定到对应的index上
        self.segmented.rx.value.map { $0 != segmentIndex }.bind(to: controller.view.rx.isHidden).disposed(by: self)
    }
}
