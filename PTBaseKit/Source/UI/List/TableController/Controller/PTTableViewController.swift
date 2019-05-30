//
//  PTTableViewController.swift
//  PTBaseKit
//
//  Created by P36348 on 13/12/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import MJRefresh

public enum TableViewOptions {
    case automaticallyAdjustsScrollViewInsets(Bool)
    case allowMultiSelection(Bool)
    case sepratorStyle(UITableViewCell.SeparatorStyle)
}
public typealias CommonTableController = PTTableViewController

final public class PTTableViewController: BaseController, ListController {
    
    public typealias ListView = UITableView
    
    public var sectionViewModels: [TableSectionViewModel] = []
    
    public var selectItemAction: ((PTTableViewController, IndexPath) -> Void)?
    
    public var willSelectItemAction: ((PTTableViewController, IndexPath) -> IndexPath?)?
    
    fileprivate var reloadAction: ((PTTableViewController)->Void)? = nil
    
    fileprivate var loadMoreAction: ((PTTableViewController)->Void)? = nil
    
    fileprivate var tableDidCommitEditing: ((PTTableViewController, UITableViewCell.EditingStyle, IndexPath) -> Void)? = nil
    
    fileprivate var loadAutomaticlly: Bool = true
    
    fileprivate var backgroundColor: UIColor = UIColor.pt.background
    
    fileprivate var tableViewSetupAction: ((PTTableViewController) -> Void)? = nil
    
    // view
    
    public var listView: UITableView {
        return self.tableView
    }
    
    public let tableView: UITableView = UITableView(frame: CGRect.zero, style: UITableView.Style.grouped)
    
    fileprivate var separatorStyle: UITableViewCell.SeparatorStyle = .none
    
    public var header: UIView? = nil
    
    public var footer: UIView? = nil
    
    public var emptyTipsImage: UIImageView = UIImageView()
    
    public var emptyTipsLabel: UILabel = UILabel()
    
    public override func performPreSetup() {
        super.performPreSetup()
        self.setupUI()
        
        self.bindObservables()
    }
    
    @objc public override func performSetup() {
        super.performSetup()
        self.performReload()
    }
    
    @objc dynamic private func performReload() {
        if let header = self.tableView.mj_header, self.loadAutomaticlly {
            header.beginRefreshing()
        }
    }
    
    public func performReloadAction() {
        self.reloadAction?(self)
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func setupUI() {
        
        if let action = self.tableViewSetupAction {
            action(self)
        }
        
        self.view.backgroundColor = self.backgroundColor
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = self.separatorStyle
        self.tableView.backgroundColor = self.backgroundColor
        
        self.emptyTipsImage.alpha = 0
        self.emptyTipsLabel.alpha = 0
        
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
                make.bottom.equalToSuperview()//.offset(-kSafeAreInsets.bottom)
                make.height.equalTo(_footer.frame.height)
            })
        }
        
        self.view.insertSubview(self.tableView, at: 0)
        self.view += [self.emptyTipsImage, self.emptyTipsLabel]
        
        if self.emptyTipsImage.image == nil, self.emptyTipsLabel.attributedText == nil {
            _ = self.setupEmptyPlaceHolder(image: PTBaseKit.Resource.emptyImage, title: PTBaseKit.Resource.emptyTips)
        }
        
        self.tableView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            let top = self.header?.snp.bottom ?? self.view.snp.top
            let bottom = self.footer?.snp.top ?? self.view.snp.bottom
            make.top.equalTo(top)
            make.bottom.equalTo(bottom)
        }
        
        self.emptyTipsLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset((self.header?.frame.height ?? 0) / 2)
        }
        
        self.emptyTipsImage.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.emptyTipsLabel.snp.top).offset(-34)
        }
    }
    
    private func bindObservables() {
        if let _action = self.reloadAction {
            self.tableView.rx.pullToRefresh
                .subscribe(onNext: {[weak self] _ in
                    guard let weakSelf = self else {return}
                    _action(weakSelf)
                })
                .disposed(by: self)
        }
    }
}

extension PTTableViewController {
    fileprivate func setEmptyTipsHidden(_ hidden: Bool) {
        UIView.animate(withDuration: 0.25) {
            self.emptyTipsImage.alpha = hidden ? 0 : 1
            self.emptyTipsLabel.alpha = hidden ? 0 : 1
        }
    }
}

extension PTTableViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.sectionViewModels[indexPath.section].cellViewModels[indexPath.row].height
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard
            let identifier = self.sectionViewModels[section].header?.viewClass.description()
            else
        {return nil}
        guard
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier)
            else
        {
            tableView.register(self.sectionViewModels[section].header?.viewClass, forHeaderFooterViewReuseIdentifier: identifier)
            return tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier)
        }
        return view
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard
            let identifier = self.sectionViewModels[section].footer?.viewClass.description()
            else
        {return nil}
        guard
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier)
            else
        {
            tableView.register(self.sectionViewModels[section].footer?.viewClass, forHeaderFooterViewReuseIdentifier: identifier)
            return tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier)
        }
        return view
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.sectionViewModels[section].header?.height ?? 0.001
    }
    
    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard
            let viewModel = self.sectionViewModels[section].header,
            let header = view as? TableSectionHeaderFooter
            else
        {return}
        header.setup(with: viewModel)
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return self.sectionViewModels[section].footer?.height ?? 0.001
    }
    
    public func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        guard
            let viewModel = self.sectionViewModels[section].footer,
            let footer = view as? TableSectionHeaderFooter
            else
        {return}
        footer.setup(with: viewModel)
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? TableCell)?.setup(with: self.sectionViewModels[indexPath.section].cellViewModels[indexPath.row])
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectItemAction?(self, indexPath)
        self.sectionViewModels[indexPath.section].cellViewModels[indexPath.row].performWhenSelect?(tableView, indexPath)
    }
    
    public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let action = self.willSelectItemAction {
            return action(self, indexPath)
        }else {
            return indexPath
        }
    }
}

extension PTTableViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let viewModels = self.sectionViewModels[indexPath.section].cellViewModels
        
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: viewModels[indexPath.row].cellClass.description())
            else
        {
            tableView.register(viewModels[indexPath.row].cellClass, forCellReuseIdentifier: viewModels[indexPath.row].cellClass.description())
            let _cell = tableView.dequeueReusableCell(withIdentifier: viewModels[indexPath.row].cellClass.description(), for: indexPath)
            return _cell
        }
        return cell
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sectionViewModels[section].cellViewModels.count
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionViewModels.count
    }
}

extension PTTableViewController {
    
    public func close() {
        if self.navigationController != nil {
            self.navigationController?.popViewController(animated: true)
        }else {
            self.dismiss(animated: true, completion: {})
        }
    }
    
    public func performWhenWillSelectItem(action: ((PTTableViewController, IndexPath) -> IndexPath?)?) -> PTTableViewController {
        self.willSelectItemAction = action
        return self
    }
    
    public func performWhenReload(action: ((PTTableViewController)->Void)?) -> PTTableViewController {
        self.reloadAction = action
        return self
    }
    
    public func performWhenLoadMore(action: ((PTTableViewController)->Void)?) -> PTTableViewController {
        self.loadMoreAction = action
        return self
    }
    
    public func performWhenSelectItem(action: @escaping (PTTableViewController, IndexPath) -> Void) -> PTTableViewController {
        self.bindItemSelection(action: action)
        return self
    }
    
    public func bindItemSelection(action: @escaping (PTTableViewController, IndexPath) -> Void) {
        self.selectItemAction = action
    }
    
    public func setupHeader(_ header: UIView) -> PTTableViewController {
        self.header = header
        return self
    }
    
    public func setupFooter(_ footer: UIView) -> PTTableViewController {
        self.footer = footer
        return self
    }
    
    public func setBackgroungColor(_ color: UIColor) -> PTTableViewController {
        self.backgroundColor = color
        return self
    }
    
    public func setAutoLoading(_ flag: Bool) -> PTTableViewController {
        self.loadAutomaticlly = flag
        return self
    }
    
    public func setupEmptyPlaceHolder(image: UIImage?, title: NSAttributedString?) -> PTTableViewController {
        self.emptyTipsImage.image = image
        self.emptyTipsLabel.attributedText = title
        return self
    }
    
    public func setupTableView(with options: TableViewOptions ...) -> PTTableViewController {
        options.forEach { (option) in
            switch option {
            case .allowMultiSelection(let allow):
                self.tableView.allowsMultipleSelection = allow
            case .sepratorStyle(let style):
                self.separatorStyle = style
            case .automaticallyAdjustsScrollViewInsets(let adjust):
                if #available(iOS 11, *) {
                    self.tableView.contentInsetAdjustmentBehavior = adjust ? .always : .never
                }else {
                    self.automaticallyAdjustsScrollViewInsets = adjust
                }
            }
        }
        self.tableViewSetupAction = { controller in
            options.forEach { (option) in
                switch option {
                case .allowMultiSelection(let allow):
                    controller.tableView.allowsMultipleSelection = allow
                case .sepratorStyle(let style):
                    controller.separatorStyle = style
                case .automaticallyAdjustsScrollViewInsets(let adjust):
                    if #available(iOS 11, *) {
                        controller.tableView.contentInsetAdjustmentBehavior = adjust ? .always : .never
                    }else {
                        controller.automaticallyAdjustsScrollViewInsets = adjust
                    }
                }
            }
        }
        return self
    }
    
    public func setupData(cellViewModels: [TableCellViewModel]) {
        self.setupData(sectionViewModels: [DefaultTableSectionViewModel(header: nil, footer: nil, cellViewModels: cellViewModels)])
    }
    
    public func setupData(sectionViewModels: [TableSectionViewModel]) {
        self.sectionViewModels = sectionViewModels
    }
}

extension PTTableViewController {
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.tableDidCommitEditing?(self, editingStyle, indexPath)
    }
    
    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return self.sectionViewModels[indexPath.section].cellViewModels[indexPath.row].editActions
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return self.sectionViewModels[indexPath.section].cellViewModels[indexPath.row].canEdit
    }
}

extension PTTableViewController {
    
    public func reload(withCellViewModels viewModels: [TableCellViewModel], isLast: Bool = false) -> Void {
        let section = DefaultTableSectionViewModel(header: nil, footer: nil, cellViewModels: viewModels)
        self.reload(withSectionViewModels: viewModels.count == 0 ? [] : [section], isLast: isLast)
    }
    
    public func loadMore(withCellViewModels viewModels: [TableCellViewModel], isLast: Bool) -> Void {
        // MARK: 只插入到最后一行section, 不另外添加section, 为了兼容已经接入了的项目
        switch self.sectionViewModels.count {
        case 0: // error, not gonna happen
            fatalError()
        default: // one row, insert
            let originalLastSection = self.sectionViewModels.last!
            let section = DefaultTableSectionViewModel(header: originalLastSection.header,
                                                      footer: originalLastSection.footer,
                                                      cellViewModels: originalLastSection.cellViewModels + viewModels)
            self.sectionViewModels[self.sectionViewModels.count-1] = section
            if self.tableView.mj_footer.state == .refreshing {
                (viewModels.count == 0 || isLast) ? self.tableView.mj_footer.endRefreshingWithNoMoreData() : self.tableView.mj_footer.endRefreshing()
            }
            
            self.tableView.ptPerformBatchUpdates({ [weak self] in
                
                guard let strongSelf = self else {return}
                
                let indexPaths = (originalLastSection.cellViewModels.count..<section.cellViewModels.count)
                    .map({row in IndexPath(row: row, section: strongSelf.sectionViewModels.count-1)})
                
                strongSelf.tableView.insertRows(at: indexPaths, with: .automatic)
                
            })
        }
    }
    
    public func reload(withSectionViewModels viewModels: [TableSectionViewModel], isLast: Bool = false) -> Void {
        if
            self.tableView.mj_header?.state == .refreshing
        {
            self.tableView.mj_header.endRefreshing()
        }
        
        if
            let _action = self.loadMoreAction,
            self.tableView.mj_footer == nil,
            !isLast
        {
            self.tableView.rx.pullToLoadMore
                .subscribe(onNext: {[weak self] _ in
                    guard let weakSelf = self else {return}
                    _action(weakSelf)
                })
                .disposed(by: self)
        }
        
        if (self.tableView.mj_footer != nil) {
            isLast ? self.tableView.mj_footer.endRefreshingWithNoMoreData() : self.tableView.mj_footer.resetNoMoreData()
        }
        self.sectionViewModels = viewModels
        self.reloadTableView()
        self.setEmptyTipsHidden(viewModels.count != 0)
    }
    
    public func loadMore(withSectionViewModels viewModels: [TableSectionViewModel], isLast: Bool) -> Void {
        if self.tableView.mj_footer.state == .refreshing {
            (viewModels.count == 0 || isLast) ? self.tableView.mj_footer.endRefreshingWithNoMoreData() : self.tableView.mj_footer.endRefreshing()
        }
        
        let orignalCount = self.sectionViewModels.count
        self.sectionViewModels.append(contentsOf: viewModels)
        
        self.tableView.ptPerformBatchUpdates({ [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.tableView.insertSections(IndexSet(integersIn: orignalCount..<strongSelf.sectionViewModels.count), with: .automatic)
        })
    }
    
    private func reloadTableView() {
        self.tableView.performSelector(onMainThread: #selector(tableView.reloadData), with: nil, waitUntilDone: true, modes: [RunLoop.Mode.default.rawValue])
    }
}

public struct DefaultTableSectionViewModel: TableSectionViewModel {
    
    public var header: TableSectionHeaderFooterViewModel?
    
    public var footer: TableSectionHeaderFooterViewModel?
    
    public var cellViewModels: [TableCellViewModel]
    
    public init(header: TableSectionHeaderFooterViewModel? = nil, footer: TableSectionHeaderFooterViewModel? = nil, cellViewModels: [TableCellViewModel]) {
        self.header = header
        self.footer = footer
        self.cellViewModels = cellViewModels
    }
}
