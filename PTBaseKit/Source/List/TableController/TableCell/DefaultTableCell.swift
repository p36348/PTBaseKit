//
//  DefaultTableCell.swift
//  PTBaseKit
//
//  Created by P36348 on 2018/5/2.
//  Copyright © 2018 P36348. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

/**
 满足实现thinker项目中90%以上列表需要的效果, 避免定义多个TableViewCell子类.
 -------------------------------------------------------------------------------------
 |<-padding->图片(可选)<- ->标题+内容(可多行)<- ->按钮(可选,可多行)<- ->箭头(可选)<-padding->|
 -------------------------------------------------------------------------------------
 */
/// frame layout cell
open class DefaultTableCell: UITableViewCell, TableCell {
    
    public var viewModel: TableCellViewModel?
    
    public var head: UIImageView = UIImageView()
    
    public var titleLabel: UILabel = {
        
        let label = UILabel()
        
        label.numberOfLines = 0
        
        return label
    }()
    
    public var tail: UIButton = UIButton()
    
    public var accessory: UIImageView = UIImageView(image: Resource.accessory)
    
    open func setup(with viewModel: TableCellViewModel) {
        
        guard let _viewModel = viewModel as? DefaultTableCellViewModel else {return}
        
        self.viewModel = _viewModel
        
        self.titleLabel.attributedText = _viewModel.title
        
        self.head.image = _viewModel.head
        
        switch _viewModel.tail {
        case .imageSource(let source)?:
            self.tail.setupImage(with: source)
            self.tail.setAttributedTitle(nil, for: UIControl.State.normal)
            self.tail.isHidden = false
        case .attributedString(let attr)?:
            self.tail.setImage(nil, for: UIControl.State.normal)
            self.tail.setAttributedTitle(attr, for: UIControl.State.normal)
            self.tail.isHidden = false
        default:
            self.tail.isHidden = true
        }
        
        self.tail.isUserInteractionEnabled = (self.viewModel as? DefaultTableCellViewModel)?.tailClicked != nil
        
        self.accessory.isHidden = !_viewModel.accessorable
        
        if let _css = _viewModel.backgroundCss {
            self.contentView += _css
        }
        
        self.head.frame = _viewModel.headFrame
        
        self.titleLabel.frame = _viewModel.titleFrame
        
        self.tail.frame = _viewModel.tailFrame
        
        self.accessory.frame = _viewModel.accessoryFrame
    }
    
    @objc dynamic private func clickDetail(_ sender: UIButton) {
        (self.viewModel as? DefaultTableCellViewModel)?.tailClicked?()
    }
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.tail.addTarget(self, action: #selector(clickDetail(_:)), for: UIControl.Event.touchUpInside)
        
        self.tail.contentHorizontalAlignment = .right
        
        self.tail.titleLabel?.numberOfLines = 0
        
        self.contentView += [self.titleLabel, self.head, self.accessory, self.tail]
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

public enum ButtonContentOptions {
    case imageSource(ImageSource)
    case attributedString(NSAttributedString)
}


/// cell height rule
///
/// - constraintToWidth: automatic calculate and constraint to width
/// - equalToHehgit: set to a const
public enum BoundsOptions {
    case fitsToWidth(CGFloat)
    case constant(CGSize)
}

private var accessorySize: CGSize {
    return Resource.accessory?.size ?? CGSize.zero
}

public struct DefaultTableCellViewModel: TableCellViewModel {
    
    public var cellClass: AnyClass = DefaultTableCell.self
    
    public var height: CGFloat
    
    private var width: CGFloat
    
    public var head: UIImage?
    
    public var headFrame: CGRect
    
    public var title: NSAttributedString
    
    public var titleFrame: CGRect
    
    public var tail: ButtonContentOptions?
    
    public var tailFrame: CGRect
    
    public var backgroundCss: UIViewCss?
    
    public var accessorable: Bool
    
    public var accessoryFrame: CGRect
    
    public var selected: (()->Void)? = nil
    
    public var tailClicked: (()->Void)? = nil
    
    public var performWhenSelect: ((UITableView, IndexPath) -> Void)? = nil
    
    public init (head: UIImage? = nil,
                 title:  NSAttributedString,
                 tail: ButtonContentOptions? = nil,
                 backgroundCss: UIViewCss? = nil,
                 accessorable: Bool = false,
                 performWhenSelect: ((UITableView, IndexPath) -> Void)? = nil,
                 boundsOption: BoundsOptions = .constant(CGSize(width: kScreenWidth, height: 45))) {
        
        self.head = head
        
        self.title = title
        
        self.tail = tail
        
        self.backgroundCss = backgroundCss
        
        self.accessorable = accessorable
        
        // MARK: calculate
        
        let hasHead = head != nil
        let hasTail = tail != nil
        let headWidth = head?.size.width ?? 0
        let _x = hasHead ? 15 + headWidth + 10 : 15
        
        var _tailSize: CGSize = .zero
        
        switch tail {
        case .imageSource(let source)?:
            _tailSize = source.targetSize
        case .attributedString(let attr)?:
            _tailSize = attr.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil).size
        default: break
        }
        
        let _titleTailPadding: CGFloat = 15 + (accessorable ? accessorySize.width + 10 : 0) + (hasTail ? _tailSize.width + 10 : 0)
        var _titleWidth: CGFloat
        switch boundsOption {
        case .constant(let size):
            self.height = size.height
            self.width = size.width
            _titleWidth = self.width - _x - _titleTailPadding
        case .fitsToWidth(let _width):
            self.width = _width
            _titleWidth = self.width - _x - _titleTailPadding
            let _titleHeight = title.boundingRect(with: CGSize(width: _titleWidth, height: CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil).height
            self.height = max(max(_tailSize.height, _titleHeight), head?.size.height ?? 0) + 20 // 上下间距10
        }
        self.titleFrame = CGRect(x: _x, y: 0, width: _titleWidth, height: self.height)
        
        if let _head = head {
            self.headFrame = CGRect(x: 15, y: (self.height - _head.size.height)/2, width: _head.size.width, height: _head.size.height)
        }else {
            self.headFrame = CGRect.zero
        }
        
        self.accessoryFrame = CGRect(origin: CGPoint(x: (self.width - accessorySize.width - 15), y: (self.height - accessorySize.height)/2), size: accessorySize)
        
        if hasTail {
            self.tailFrame = CGRect(x: self.width - _tailSize.width - 15 - (accessorable ? 10 + accessorySize.width : 0), y: (self.height - _tailSize.height)/2, width: _tailSize.width, height: _tailSize.height)
        } else {
            self.tailFrame = CGRect.zero
        }
        
        self.performWhenSelect = performWhenSelect
    }
}
