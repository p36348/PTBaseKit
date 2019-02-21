//
//  IGListViewController.swift
//  PTBaseKit
//
//  Created by P36348 on 18/02/2019.
//  Copyright © 2019 P36348. All rights reserved.
//

import Foundation
import IGListKit
import RxSwift
import RxCocoa
import MJRefresh

public protocol CollectionCell {
    var viewModel: CollectionCellViewModel? {get set}
    func setup(viewModel: CollectionCellViewModel)
}

public protocol CollectionCellViewModel {
    var cellClass: AnyClass {get}
    var size: CGSize {get}
    var performWhenSelect: ((IndexPath)->Void)? {get}
}

extension CollectionCellViewModel {
    public var performWhenSelect: ((IndexPath)->Void)? {
        return nil
    }
}


protocol CollectionSectionViewModel {
    var cellViewModels: [CollectionCellViewModel] {get}
}


protocol IGListSectionViewModel: ListDiffable {
    var header: IGListSectionHeaderFooterViewModel? {get}
    var footer: IGListSectionHeaderFooterViewModel? {get}
    var cellItems: [CollectionCellViewModel] {get}
    var sectionController: ListSectionController { get }
    var minimumLineSpacing: CGFloat {get}
    var minimumInteritemSpacing: CGFloat {get}
    var inset: UIEdgeInsets {get}
}

extension IGListSectionViewModel {
    var minimumLineSpacing: CGFloat {
        return 0
    }
    var minimumInteritemSpacing: CGFloat {
        return 0
    }
    var inset: UIEdgeInsets {
        return .zero
    }
    var header: IGListSectionHeaderFooterViewModel? {
        return nil
    }
    
    var footer: IGListSectionHeaderFooterViewModel? {
        return nil
    }
    
    var sectionController: ListSectionController {
        return DefaultIGListSectionController()
    }
}

protocol IGListSectionHeaderFooter: class {
    var viewModel: IGListSectionHeaderFooterViewModel? {get set}
    func setup(viewModel: IGListSectionHeaderFooterViewModel)
}

protocol IGListSectionHeaderFooterViewModel {
    var viewClass: AnyClass {get}
    var size: CGSize {get}
    var performWhenSelect: ((Int)->Void)? {get}
}

extension IGListSectionHeaderFooterViewModel {
    var performWhenSelect: ((Int)->Void)? {
        return nil
    }
}

typealias IGListUpdateParams = (items: [IGListSectionViewModel], isLast: Bool)

class IGListViewController: BaseController {
    
    // views
    
    lazy var collectionView: UICollectionView = {
        let _item = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        _item.backgroundColor = UIColor.tk.white
        return _item
    }()
    
    public var header: UIView? = nil
    
    public var footer: UIView? = nil
    
    // datas
    
    let layout = ListCollectionViewLayout(stickyHeaders: false, scrollDirection: .vertical, topContentInset: 0, stretchToEdge: false)
    
    let updater = ListReloadDataUpdater()
    
    lazy var adapter: ListAdapter = {
        let _adapter = ListAdapter(updater: self.updater, viewController: self)
        _adapter.collectionView = self.collectionView
        _adapter.dataSource = self
        return _adapter
    }()
    
    private var backgroundColor: UIColor = UIColor.tk.background
    
    var items: [IGListSectionViewModel] = []
    
    private var reloadAction: ((IGListViewController) -> Void)? = nil
    
    private var loadMoreAction: ((IGListViewController) -> Void)? = nil
    
    private var loadAutomaticlly: Bool = true
    
    deinit {
        self.collectionView.mj_header = nil
        self.collectionView.mj_footer = nil
    }
    
    override func performPreSetup() {
        super.performPreSetup()
        
        if let _header = self.header {
            self.view.addSubview(_header)
            _header.snp.makeConstraints({ (make) in
                var topOffset = self.navigationController?.navigationBar.bounds.height ?? 0
                topOffset += (UIApplication.shared.statusBarFrame.height)
                make.leading.trailing.equalToSuperview()
                make.top.equalToSuperview().offset(topOffset)
                make.height.equalTo(_header.frame.height)
            })
        }
        
        if let _footer = self.footer {
            self.view.addSubview(_footer)
            _footer.snp.makeConstraints({ (make) in
                make.leading.trailing.equalToSuperview()
                make.bottom.equalToSuperview().offset(-kSafeAreInsets.bottom)
                make.height.equalTo(_footer.frame.height)
            })
        }
        
        self.view.insertSubview(self.collectionView, at: 0)
        
        self.collectionView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            let top = self.header?.snp.bottom ?? self.view.snp.top
            let bottom = self.footer?.snp.top ?? self.view.snp.bottom
            make.top.equalTo(top)
            make.bottom.equalTo(bottom)
        }
        
        if let _ = self.reloadAction {
            self.collectionView.rx.pullToRefresh
                .subscribe(onNext: { [weak self] _ in
                    guard let weakSelf = self else {return}
                    weakSelf.reloadAction?(weakSelf)
                })
                .disposed(by: self)
        }
    }
    
    override func performSetup() {
        super.performSetup()
        
        if self.items.count != 0 {
            self.adapter.performUpdates(animated: true, completion: { [weak self] _ in
                self?.performFirstReload()
            })
        }else {
            self.performFirstReload()
        }
    }
    
    private func performFirstReload() {
        if let header = self.collectionView.mj_header, self.loadAutomaticlly {
            header.beginRefreshing()
        }
    }
    
    private func performReload() {
        if let action = self.reloadAction {
            action(self)
        }
    }
    
    private func performLoadMore() {
        if let action = self.loadMoreAction {
            action(self)
        }
    }
    
    func reload(items: [IGListSectionViewModel], isLast: Bool = true, finished: ((IGListViewController)->Void)? = nil) {
        if
            self.collectionView.mj_header?.state == .refreshing
        {
            self.collectionView.mj_header.endRefreshing()
        }
        
        if
            let _ = self.loadMoreAction,
            self.collectionView.mj_footer == nil,
            !isLast
        {
            self.collectionView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { [weak self] in
                guard let weakSelf = self else {return}
                weakSelf.loadMoreAction?(weakSelf)
            })
        }
        self.updateList(items: items, finished: finished)
    }
    
    func loadMore(items: [IGListSectionViewModel], isLast: Bool) {
        if self.collectionView.mj_footer.state == .refreshing {
            (items.count == 0 || isLast) ? self.collectionView.mj_footer.endRefreshingWithNoMoreData() : self.collectionView.mj_footer.endRefreshing()
        }
        let newItems = self.items + items
        self.updateList(items: newItems)
    }
    
    func reloadList() {
        self.adapter.reloadData(completion: nil)
    }
    
    private func updateList(items: [IGListSectionViewModel], finished: ((IGListViewController)->Void)? = nil) {
        self.items = items
        self.adapter.performUpdates(animated: true, completion: { [unowned self] _finished in
            finished?(self)
        })
    }
}


extension IGListViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return self.items
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        
        guard let item = object as? IGListSectionViewModel else
        {
            return ListSectionController()
        }
        return item.sectionController
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}


//MARK: - public APIs
extension IGListViewController {
    public func performOnReload(action: @escaping (IGListViewController) -> Void) -> IGListViewController {
        self.reloadAction = action
        return self
    }
    
    public func performOnLoadMore(action: @escaping (IGListViewController) -> Void) -> IGListViewController {
        self.loadMoreAction = action
        return self
    }
    
    public func setupHeader(_ header: UIView) -> IGListViewController {
        
        self.header = header
        
        return self
    }
    
    public func setupFooter(_ footer: UIView) -> IGListViewController {
        self.footer = footer
        return self
    }
    
    public func setBackgroungColor(_ color: UIColor) -> IGListViewController {
        self.backgroundColor = color
        return self
    }
    
    public func setAutoLoading(_ flag: Bool) -> IGListViewController {
        self.loadAutomaticlly = flag
        return self
    }
}


class DefaultIGListSectionController: ListSectionController, ListDisplayDelegate, ListSupplementaryViewSource {
    
    var viewModel: IGListSectionViewModel!
    
    override init() {
        super.init()
        self.displayDelegate = self
        self.supplementaryViewSource = self
    }
    
    override func didUpdate(to object: Any) {
        guard let _item = object as? IGListSectionViewModel else {return}
        self.viewModel = _item
        self.minimumLineSpacing = _item.minimumLineSpacing
        self.minimumInteritemSpacing = _item.minimumInteritemSpacing
        self.inset = _item.inset
    }
    
    override func numberOfItems() -> Int {
        return self.viewModel.cellItems.count
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        if viewModel.cellItems[index].size == .zero {
            return CGSize(width: collectionContext!.containerSize.width, height: 10)
        }else {
            return viewModel.cellItems[index].size
        }
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let item = self.viewModel.cellItems[index]
        return collectionContext!.dequeueReusableCell(of: item.cellClass, withReuseIdentifier: item.cellClass.description(), for: self, at: index)
    }
    
    func supportedElementKinds() -> [String] {
        var items: [String] = []
        if viewModel.header != nil {
            items.append(UICollectionView.elementKindSectionHeader)
        }
        if viewModel.footer != nil {
            items.append(UICollectionView.elementKindSectionFooter)
        }
        return items
    }
    
    func viewForSupplementaryElement(ofKind elementKind: String, at index: Int) -> UICollectionReusableView {
        switch elementKind {
        case UICollectionView.elementKindSectionHeader:
            let view = collectionContext!.dequeueReusableSupplementaryView(ofKind: elementKind, for: self, class: viewModel.header!.viewClass, at: index)
            (view as? IGListSectionHeaderFooter)?.setup(viewModel: self.viewModel.header!)
            return view
        case UICollectionView.elementKindSectionFooter:
            let view = collectionContext!.dequeueReusableSupplementaryView(ofKind: elementKind, for: self, class: viewModel.footer!.viewClass, at: index)
            (view as? IGListSectionHeaderFooter)?.setup(viewModel: self.viewModel.footer!)
            return view
        default:
            fatalError()
        }
    }
    
    func sizeForSupplementaryView(ofKind elementKind: String, at index: Int) -> CGSize {
        switch elementKind {
        case UICollectionView.elementKindSectionHeader:
            return viewModel.header!.size
        case UICollectionView.elementKindSectionFooter:
            return viewModel.footer!.size
        default:
            fatalError()
        }
    }
    
    func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController) {
        
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController) {
        
    }
    
    override func didSelectItem(at index: Int) {
        self.viewModel.cellItems[index].performWhenSelect?(IndexPath(row: index, section: self.section))
    }
    
    func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController, cell: UICollectionViewCell, at index: Int) {
        (cell as? CollectionCell)?.setup(viewModel: self.viewModel.cellItems[index])
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController, cell: UICollectionViewCell, at index: Int) {
        
    }
}
