# PTBaseKit

Thinker系列项目通用模块，适用于Thinker开发的iOS客户端全系列项目。

## CssKit

用运算符"+"、"+="把CssKit对象添加给UIKit组件，

### 传统UILabel赋值的做法:

 ```swift
 let customLabel: UILabel = UILabel()
 label.font = 13.customFont
 label.textColor = UIColor.tk.main
 label.text = "custom label"
 ```

### 使用CssKit给UILabel赋值的做法:

 ```swift
 let customLabel: UILabel = UILabel() + 13.customFont.css + UIColor.tk.main.textColorCss + "custom label".css
 ```

## BaseController

作为项目所有界面控制器的基类，有以下主要作用：

- 部分情景下，一个界面会有较多UI元素，某些旧设备在navigate或者present的过程中会有些许卡顿，BaseController把`viewDidLoad`函数做了拆分，分别是`performPreSetup`和`performPreSetup`，其中前者在`viewDidLoad`函数中同步调用，而后者则是通过**RunLoop**特性延迟了调用，调用时机就是界面转场动画完结之时。
- 为了方便配合***RxSwift***框架使用，集成了用于管理`DisposeBag`的功能：
  - 函数`disposed(by controller: BaseController, identifier: String = BaseController.DisposeIdentifiers.default)`
    - 把Observable的销毁绑定到`BaseController`上，在***deinit***的时候，BaseController内部会自己销毁绑定的订阅
  - 函数`func dispose(identifier: String = BaseController.DisposeIdentifiers.default)`
    - 当部分订阅需要提前手动销毁时，调用此函数。

## TableController

 TableController是针对列表功能抽象出来的协议, 与之关联的还有TableCell, TableSectionViewModel和TableCellViewModel协议. 整体上是一个MVVM的设计, 把TableCell的适配从Controller分离出来, TableController专注于Table的加载动作, TableCellViewModel用于中转Model->Cell的数据以及持有Cell的一些交互回调, 而TableCell则提供更新函数.

## CommonTableController

 thinker vc开发项目中的列表页面几乎都是`CommonTableController`类, 它遵守`TableController`协议. 通过TableView和RJRefresh组合成基本的上下拉加载逻辑, 而内部处理和UITableViewCell有关的操作都是面向TableCell以及TableCellViewModel协议的, 所以它与TableViewCell的实现以及适配不存在耦合. 

  - 使用者需要创建一个列表界面的时候可以直接使用`CommonTableController`, 它提供的接口可以应付大部分使用场景. 这样有利于避免创建多个ViewController带来的维护高成本和低代码复用.
  - 专注`SectionViewModel/TableCellViewModel`的产生和变化, 它们以数组的形式传入`CommonTableController`, 根据数组中元素顺序的不同, `CommonTableController`的显示内容就会有相应变化.
  - 它的 数据加载逻辑/组件加载逻辑/组件刷新逻辑 都通过了(作者本人)验证.
  - 提供简单的配置函数来给使用者对页面的顶部和底部添加UI组件, 以及数据为空时候的UI提示.

 UIKitTableController.swift文件中有一个调用`CommonTableController`的例子:

 ```swift
 CommonTableController()
        .setupTableView(with: .sepratorStyle(.singleLine))
        .performWhenReload { (_table) in
            // 进入global队列获取数据, 并回到主线程结束刷新动画, 更新列表
            DispatchQueue.global()
                .rx_async(with: ())
                .flatMap { Observable.just(fakeFetchData()) }
                .flatMap { DispatchQueue.main.rx_async(with: $0) }
                .subscribe(onNext: { _table.reload(withSectionViewModels: $0) })
                .disposed(by: _table)
        }
        .performWhenLoadMore { (_table) in
            DispatchQueue.global()
                .rx_async(with: ())
                .flatMap { Observable.just(fakeFetchData()) }
                .flatMap { DispatchQueue.main.rx_async(with: $0) }
                .subscribe(onNext: { _table.loadMore(withSectionViewModels: $0, isLast: true) })
                .disposed(by: _table)
    }
 ```
 其中`performWhenReload`和`performWhenLoadMore`分别用于传入加载操作, 需要调用者自己结束加载. 回调闭包中有一个参数正是`CommonTableController`本身.例子中使用了`RxSwift`三方框架配合展示了这个加载过程, `fakeFetchData`替代了项目中的网络请求以及Model->ViewModel的操作, 实际上thinker的项目中就是按照这个方式实现, 实现这一步操作的是各个业务模块对应的`Service`.

## CommonTableCell

  `CommonTableCell`是在`TableController`协议基础上实现的一个UITableViewCell子类, 根据thinker项目总结而来. 
  - 它已经几乎兼容thinker目前所有列表的显示需要, 订单, 用户信息, 活动, 设置, 消息等.
  - 只需要传入不同的参数来创建ViewModel, 并传入`CommonTableController`, 就可以得到各种自适应高度的界面, 这个高度是其`ViewModel`初始化的时候实现的, 并不需要使用者自己计算.
  - 使用了比较好理解的fram计算来实现layout. 这样除了提供不错的滑动性能, 也让使用者根据项目变更的情况较快修改, 比起ASDK这种滑动性能极佳可是又难上手的框架, 或者直接使用`SnapKit`来牺牲性能要来得好.

  为了遵守高内聚低耦合, 在使用的时候应该把Model->ViewModel这一步操作抽出, 不要添加`init`函数到`CommonTableCell`的ViewModel代码中, 用例里面由于没有业务Model, 只是写了一个单独函数产生ViewModel:
  ```swift
  private func createCellViewModels() -> [TableCellViewModel] {
    return
        (0...Int(arc4random_uniform(4)))
            .map { index -> TableCellViewModel in
                let imageIndex = Int(arc4random_uniform(4))
                // let cellHiehgt = (images[imageIndex]?.size.height ?? 45) + 20
                var viewModel = CommonTableCellViewModel(head: images[imageIndex],
                                                              title: cellTitles[Int(arc4random_uniform(4))].appending(subTitles[Int(arc4random_uniform(4))]),
                                                              tail: genButtonContentOptions(),
                                                              accessorable: index%2 == 1,
                                                              boundsOption: .fitsToWidth(kScreenWidth)) // .constant(CGSize(width: kScreenWidth, height: cellHiehgt))
                viewModel.tailClicked = {_ = UIApplication.shared.keyWindow?.rootViewController?.presentAlert(title: "cell tail button clicked", message: "", force: true)}
                viewModel.performWhenSelect = {(table, indexpath) in table.deselectRow(at: indexpath, animated: true)}
                return viewModel
    }
}
  ```

  实际操作可以是这样:

  ```swift
 class SomeModel {
    ...
    ...
    ...
}

extension SomeModel {
    func toCommonTableCellViewModel() -> CommonTableCellViewModel {
        
        // 实行self -> CommonTableCellViewModel的转换
        
        let head = ...
        
        let title = ...
        
        let tail = ...
        
        let background = ...
        
        let accessorable = ...
        
        let boundsOption = ...
        
        return CommonTableCellViewModel(head: head,
                                        title: title,
                                        tail: tail,
                                        backgroundCss: background,
                                        accessorable: accessorable,
                                        boundsOption: boundsOption)
    }
}
  ```
  并且每个Model对ViewModel的转换, 最好都是在子线程中完成, 就像用例里的一样.

## Reactive extensions

RxSwift框架的核心类型，Thinker项目中大量使用了该框架，此模块对`Reactive`做了一些常用的封装：

- UIViewController
  - `func controlEvent(with lifeCycleEvent: UIViewController.LifeCycleEvent) -> ControlEvent<Base>`
    - 返回控制器生命周期的事件回调
- UIScrollView+MJRefresh
  - `pullToRefresh`
    - 下拉刷新事件
  - `pullToLoadMore`
    - 上拉加载事件
  - `refreshing`
    - 刷新状态