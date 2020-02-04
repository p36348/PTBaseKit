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
import SwiftyJSON


class IndexController: BaseController {
    
    lazy var segmented: UISegmentedControl = {
        let item = UISegmentedControl(items: ["UIKitTable", "IGList", "Map", "Web"])
        item.tintColor = UIColor.clear
        item.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.pt.main], for: UIControl.State.normal)
        item.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.pt.main, NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue], for: UIControl.State.selected)
        item.selectedSegmentIndex = 0
        return item
    }()
    
    var uikitTable: UIViewController = new_createTableController()
        
    var igList: UIViewController = createIGListViewController()
    
    var map: UIViewController = createMapController()
    
    // var utils: UtilsController = UtilsController()
    
    lazy var web: WebURLController = WebURLController()
    
    // var webDelegate: WebDelegate = WebDelegate()

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
        self.setup(controller: self.igList, segmentIndex: 1)
        self.setup(controller: self.map, segmentIndex: 2)
        // self.setup(controller: self.utils, segmentIndex: 3)
        self.setup(controller: self.web, segmentIndex: 3)
        
        self.web.rx_submit.subscribe(onNext: { [weak self] in self?.navigateWeb(url: $0) }).disposed(by: self)
    }
    
    private func navigateWeb(url: String) {
        let customJson: JSON = ["token": "I am token!!!!"]
        let jsSCript = "window.duckCustomJson = \(customJson.rawString()!)"
        
        let destination: WebController
        if #available(iOS 13, *) {
            let urlHandler = URLSchemeHandler(scheme: "ptbasekit", startHandler: { value in
                
            })
            destination = WebController(url: URL(string: url), header: nil, jsScript: [jsSCript], urlSchemeHandlers: [urlHandler])
            
        }else if #available(iOS 11, *) {
            destination = WebController(url: URL(string: url), header: nil, jsScript: jsSCript)
        }
        else {
            destination = WebController(url: URL(string: url), header: nil, jsScript: jsSCript)
        }
        // destination.webView.navigationDelegate = webDelegate
        self.navigationController?.pushViewController(destination, animated: true)
    }
    
    private func setup(controller: UIViewController, segmentIndex: Int) {
        // 添加到背景上
        self.view.addSubview(controller.view)
        controller.view.snp.makeConstraints{$0.edges.equalToSuperview()}
        // 把显示与否绑定到对应的index上
        self.segmented.rx.value.map { $0 != segmentIndex }.bind(to: controller.view.rx.isHidden).disposed(by: self)
    }
    
}

import WebKit

class WebDelegate: NSObject, WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let params = "\"I am token!!!\""
        webView.evaluateJavaScript("getDuckAppData(\(params))") { (val, error) in
            
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if
            let response = navigationResponse.response as? HTTPURLResponse,
            let headers = response.allHeaderFields as? [String : String],
            let url = response.url
        {
            HTTPCookie.cookies(withResponseHeaderFields: headers, for: url)
            HTTPCookieStorage.shared.cookies(for: url)
            HTTPCookieStorage.shared.cookies
            
            if #available(iOS 11.0, *) {
                webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { (cookies) in
                    //
                    cookies.filter { $0.commentURL?.absoluteString == url.absoluteString }
                }
                
            }
        }
        
        let url = URL(string: "https://www.jianshu.com")!
        
        if let cookie = HTTPCookie(properties: [HTTPCookiePropertyKey.commentURL: url]) {
            
            HTTPCookieStorage.shared.setCookie(cookie)
            HTTPCookieStorage.shared.setCookies([cookie], for: url, mainDocumentURL: url)
            
            if #available(iOS 11.0, *) {
                webView.configuration.websiteDataStore.httpCookieStore.setCookie(cookie, completionHandler: nil)
            }
        }
        
        decisionHandler(.allow)
    }
}


func createIGListViewController() -> UIViewController {
    let viewController = IGListViewController()
    viewController.rx.bindRefresh(toGenerator: reloadIGListViewModels).disposed(by: viewController)
    viewController.rx.bindLoadMore(toGenerator: loadMoreIGListViewModels).disposed(by: viewController)
    return viewController
}

func reloadIGListViewModels(for viewController: IGListViewController) -> Observable<(viewModels: [IGListSectionViewModel], isLast: Bool)> {
    return Observable.of((viewModels: fakeFetchData(), isLast: false)).subscribeOn(ConcurrentDispatchQueueScheduler(qos: DispatchQoS.default))
}

func loadMoreIGListViewModels(for viewController: IGListViewController) -> Observable<(viewModels: [IGListSectionViewModel], isLast: Bool)> {
    return Observable.of((viewModels: fakeFetchData(), isLast: true)).subscribeOn(ConcurrentDispatchQueueScheduler(qos: DispatchQoS.default))
}

private func fakeFetchData() -> [IGListSectionViewModel] {
    let numberOfSection = 5
    return (0..<numberOfSection).map { DefaultIGSectionViewModel(index: $0, cellItems: createCellViewModels()) }
}

private func createCellViewModels() -> [DefaultCollectionCellViewModel] {
    return (0...Int(arc4random_uniform(200))).map(createViewModel)
}

private func createViewModel(index: Int) -> DefaultCollectionCellViewModel {
    return DefaultCollectionCellViewModel(title: "\(index)")
}

import IGListKit

class DefaultIGSectionViewModel: IGListSectionViewModel {
    var cellItems: [ReusableCellViewModel]
    
    let identifier: String
    
    init(index: Int, cellItems: [ReusableCellViewModel]) {
        identifier = "\(index)"
        self.cellItems = cellItems
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let _object = object as? DefaultIGSectionViewModel else {return false}
        return _object.identifier == identifier
    }
    
    
}

class DefaultCollectionCell: UICollectionViewCell, ReusableCell {
    
    var viewModel: ReusableCellViewModel?
    
    let label: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        label.snp.makeConstraints {$0.edges.equalToSuperview()}
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(viewModel: ReusableCellViewModel) {
        guard let _viewModel = viewModel as? DefaultCollectionCellViewModel else {return}
        label.attributedText = _viewModel.title
    }
}

class DefaultCollectionCellViewModel: ReusableCellViewModel {
    var cellClass: AnyClass = DefaultCollectionCell.self
    
    var size: CGSize
    
    let title: NSAttributedString
    
    init(title: String) {
        let fontSize = Int(arc4random_uniform(50)) + 5
        self.title = title.attributed([.font(fontSize.customMediumFont)])
        self.size =
            self.title.boundingRect(
                with: CGSize(width: CGFloat.greatestFiniteMagnitude,
                             height: CGFloat.greatestFiniteMagnitude),
                options: .usesLineFragmentOrigin,
                context: nil)
                .size
    }
}
