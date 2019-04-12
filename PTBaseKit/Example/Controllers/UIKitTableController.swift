//
//  UIKitTableController.swift
//  PTBaseKit
//
//  Created by P36348 on 01/08/2018.
//  Copyright © 2018 P36348. All rights reserved.
//

import UIKit
import RxSwift


func createTableController() -> UIViewController {
    let table = PTTableViewController()
        .setBackgroungColor(UIColor.pt.background)
        .setAutoLoading(false)
        .setupHeader(UILabel(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 44)) + "Header for table".css)
        .setupFooter(UILabel(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 44)) + "Footer for table".css)
        .setupTableView(with: .sepratorStyle(.singleLine), .allowMultiSelection(true), .automaticallyAdjustsScrollViewInsets(false))
        .setupEmptyPlaceHolder(image: UIImage(named: "empty_tips"), title: "No data yet".attributed())
        .performWhenReload { (_table) in
            Observable.just(fakeFetchData())
                .subscribeOn(ConcurrentDispatchQueueScheduler(qos: DispatchQoS.default))
                .observeOn(MainScheduler.asyncInstance)
                .subscribe(onNext: { _table.reload(withSectionViewModels: $0) })
                .disposed(by: _table)
        }
        .performWhenLoadMore { (_table) in
            Observable.just(fakeFetchData())
                .subscribeOn(ConcurrentDispatchQueueScheduler(qos: DispatchQoS.default))
                .observeOn(MainScheduler.asyncInstance)
                .subscribe(onNext: { _table.loadMore(withSectionViewModels: $0, isLast: true) })
                .disposed(by: _table)
    }
    
    return table
    
}

func new_createTableController() -> UIViewController {
    
    let table = PTTableViewController()
    
    table.rx
        .bindRefresh(toGenerator: fakeViewModelRefreshGenerator)
        .disposed(by: table)
    
    table.rx
        .bindLoadMore(toGenerator: fakeViewModelLoadMoreGenerator)
        .disposed(by: table)

    table.rx.updateError
        .subscribe(onNext: { err in
            print("update Error:", err)
        })
        .disposed(by: table)
    
    return table
        .setBackgroungColor(UIColor.pt.background)
        .setupTableView(with: .sepratorStyle(.singleLine), .allowMultiSelection(true), .automaticallyAdjustsScrollViewInsets(false))
        .setupEmptyPlaceHolder(image: UIImage(named: "empty_tips"), title: "No data yet".attributed())
}

private func fakeViewModelRefreshGenerator(_ listController: PTTableViewController) -> Observable<(viewModels: [TableSectionViewModel], isLast: Bool)> {
    return Observable.of((viewModels: fakeFetchData(), isLast: false)).subscribeOn(ConcurrentDispatchQueueScheduler(qos: DispatchQoS.default))
}

private func fakeViewModelLoadMoreGenerator(_ listController: PTTableViewController) -> Observable<(viewModels: [TableSectionViewModel], isLast: Bool)> {
   return Observable.of((viewModels: fakeFetchData(), isLast: true)).subscribeOn(ConcurrentDispatchQueueScheduler(qos: DispatchQoS.default))
}

private func fakeFetchData() -> [TableSectionViewModel] {
    let numberOfSection = 5
    return (0..<numberOfSection).map { _ in DefaultTableSectionViewModel(header: DefaultTableSectionHeaderFooterViewModel(),
                                                                        footer: DefaultTableSectionHeaderFooterViewModel(),
                                                                        cellViewModels: createCellViewModels()) }
}

private func createCellViewModels() -> [TableCellViewModel] {
    return (0...Int(arc4random_uniform(4))).map(createViewModel)
}

private func createViewModel(index: Int) -> TableCellViewModel {
    let imageIndex = Int(arc4random_uniform(4))
    var viewModel = DefaultTableCellViewModel(head: images[imageIndex],
                                              title: cellTitles[Int(arc4random_uniform(4))].appending(subTitles[Int(arc4random_uniform(4))]),
                                              tail: genButtonContentOptions(),
                                              accessorable: index%2 == 1,
                                              boundsOption: .fitsToWidth(kScreenWidth))
    viewModel.tailClicked = {_ = UIApplication.shared.keyWindow?.rootViewController?.presentAlert(title: "cell tail button clicked", message: "", force: true)}
    viewModel.performWhenSelect = {(table, indexpath) in table.deselectRow(at: indexpath, animated: true)}
    return viewModel
}

var images: [UIImage?] {
    return [#imageLiteral(resourceName: "test_img"), nil, #imageLiteral(resourceName: "test_img").scale(to: CGSize(width: 35, height: 35)), #imageLiteral(resourceName: "test_img").scale(to: CGSize(width: 50, height: 50))]
}

private func genButtonContentOptions() -> ButtonContentOptions {
    if arc4random_uniform(2) == 1 {
        return .imageSource(imageSource(with: testPicUrls[Int(arc4random_uniform(15))], css: UIColor.pt.gray.bgCss + (45/2).cornerRadiusCss, targetSize: CGSize(width: 45, height: 45)))
    }else {
        return .attributedString("click me".attributed([.font(17.customMediumFont), .textColor(UIColor.pt.main)]))
    }
}


var cellTitles: [NSMutableAttributedString] {
    return ["long long long long long long long long long long long long long long long long cell title aligent natural".attributed([.paragraphStyle(lineSpacing: nil, alignment: .natural)]),
            "cell title aligent center".attributed([.paragraphStyle(lineSpacing: nil, alignment: .center)]),
            "cell title aligent right".attributed([.paragraphStyle(lineSpacing: nil, alignment: .right)]),
            "cell title red".attributed([.textColor(UIColor.pt.noticeRed), .paragraphStyle(lineSpacing: nil, alignment: .natural)])]
}

var subTitles: [NSMutableAttributedString] {
    return ["\nsub title aligent natural".attributed([.paragraphStyle(lineSpacing: nil, alignment: .natural)]),
            "\nsub title aligent center".attributed([.paragraphStyle(lineSpacing: nil, alignment: .center)]),
            "\nsub title aligent right".attributed([.paragraphStyle(lineSpacing: nil, alignment: .right)]),
            "\nlong long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long sub title ".attributed([.textColor(UIColor.pt.lightGray), .paragraphStyle(lineSpacing: nil, alignment: .natural)])]
}

private let testPicUrls: [String] = [
    "https://hypebeast.imgix.net/https%3A%2F%2Fhk.hypebeast.com%2Ffiles%2F2018%2F04%2Fsupreme-rimowa-spring-summer-2018-street-style-1.jpg?auto=compress%2Cformat&fit=clip&ixlib=php-1.1.0&q=90&w=3510&s=b9f6fe4d02da6defbbde24cda0e4ff7b",
    "https://hypebeast.imgix.net/https%3A%2F%2Fhk.hypebeast.com%2Ffiles%2F2018%2F04%2Fsupreme-rimowa-spring-summer-2018-street-style-2.jpg?auto=compress%2Cformat&fit=clip&ixlib=php-1.1.0&q=90&w=3510&s=7c8e24841bf82a0ac3a05bd539f8385f",
    "https://hypebeast.imgix.net/https%3A%2F%2Fhk.hypebeast.com%2Ffiles%2F2018%2F04%2Fsupreme-rimowa-spring-summer-2018-street-style-3.jpg?auto=compress%2Cformat&fit=clip&ixlib=php-1.1.0&q=90&w=3510&s=b68cdacffd1240d61d4549cf211b642f",
    "https://hypebeast.imgix.net/https%3A%2F%2Fhk.hypebeast.com%2Ffiles%2F2018%2F04%2Fsupreme-rimowa-spring-summer-2018-street-style-4.jpg?auto=compress%2Cformat&fit=clip&ixlib=php-1.1.0&q=90&w=3510&s=240968fc6d38fa5fc4162d2fef021fac",
    "https://hypebeast.imgix.net/https%3A%2F%2Fhk.hypebeast.com%2Ffiles%2F2018%2F04%2Fsupreme-rimowa-spring-summer-2018-street-style-5.jpg?auto=compress%2Cformat&fit=clip&ixlib=php-1.1.0&q=90&w=3510&s=9ec027822dd98f4ff513f1935f1d9be3",
    "https://hypebeast.imgix.net/https%3A%2F%2Fhk.hypebeast.com%2Ffiles%2F2018%2F04%2Fsupreme-rimowa-spring-summer-2018-street-style-6.jpg?auto=compress%2Cformat&fit=clip&ixlib=php-1.1.0&q=90&w=3510&s=fc5ac476b1067a9503a7f1141099eefd",
    "https://hypebeast.imgix.net/https%3A%2F%2Fhk.hypebeast.com%2Ffiles%2F2018%2F04%2Fsupreme-rimowa-spring-summer-2018-street-style-7.jpg?auto=compress%2Cformat&fit=clip&ixlib=php-1.1.0&q=90&w=3510&s=1e87461d5f5e999ec777523141e63349",
    "https://hypebeast.imgix.net/https%3A%2F%2Fhk.hypebeast.com%2Ffiles%2F2018%2F04%2Fsupreme-rimowa-spring-summer-2018-street-style-8.jpg?auto=compress%2Cformat&fit=clip&ixlib=php-1.1.0&q=90&w=3510&s=0dcc804f28bb996ae8e704b95d9e95c6",
    "https://hypebeast.imgix.net/https%3A%2F%2Fhk.hypebeast.com%2Ffiles%2F2018%2F04%2Fsupreme-rimowa-spring-summer-2018-street-style-9.jpg?auto=compress%2Cformat&fit=clip&ixlib=php-1.1.0&q=90&w=3510&s=ea25e3e0827201668a2fa3eed1d004a7",
    "https://hypebeast.imgix.net/https%3A%2F%2Fhk.hypebeast.com%2Ffiles%2F2018%2F04%2Fsupreme-rimowa-spring-summer-2018-street-style-10.jpg?auto=compress%2Cformat&fit=clip&ixlib=php-1.1.0&q=90&w=3510&s=189d7e5f34f0af946f7986c62f3fa94f",
    "https://hypebeast.imgix.net/https%3A%2F%2Fhk.hypebeast.com%2Ffiles%2F2018%2F04%2Fsupreme-rimowa-spring-summer-2018-street-style-12.jpg?auto=compress%2Cformat&fit=clip&ixlib=php-1.1.0&q=90&w=3510&s=53377a59dd167d252787022c5df4656b",
    "https://hypebeast.imgix.net/https%3A%2F%2Fhk.hypebeast.com%2Ffiles%2F2018%2F04%2Fsupreme-rimowa-spring-summer-2018-street-style-012.jpg?auto=compress%2Cformat&fit=clip&ixlib=php-1.1.0&q=90&w=3510&s=6df3d68e9681b0714924377a97d31845",
    "https://hypebeast.imgix.net/https%3A%2F%2Fhk.hypebeast.com%2Ffiles%2F2018%2F04%2Fsupreme-rimowa-spring-summer-2018-street-style-13.jpg?auto=compress%2Cformat&fit=clip&ixlib=php-1.1.0&q=90&w=3510&s=a1730532c4621f1c9faaf2e814af1010",
    "https://hypebeast.imgix.net/https%3A%2F%2Fhk.hypebeast.com%2Ffiles%2F2018%2F04%2Fsupreme-rimowa-spring-summer-2018-street-style-14.jpg?auto=compress%2Cformat&fit=clip&ixlib=php-1.1.0&q=90&w=3510&s=df369d7bb4a39a3c3bb04500df23a0c0",
    "https://hypebeast.imgix.net/https%3A%2F%2Fhk.hypebeast.com%2Ffiles%2F2018%2F04%2Fsupreme-rimowa-spring-summer-2018-street-style-15.jpg?auto=compress%2Cformat&fit=clip&ixlib=php-1.1.0&q=90&w=3510&s=01a783a4e5b2e8e83e5f650559499de8"]
