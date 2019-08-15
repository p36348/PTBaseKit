//
//  DefaultTableCellNode.swift
//  PTBaseKit
//
//  Created by P36348 on 2018/5/3.
//  Copyright © 2018 P36348. All rights reserved.
//

import UIKit
import AsyncDisplayKit

/**
 * async display cell
 * layout using flex
 */
public class DefaultTableCellNode: ASCellNode, TableCellNode {
    
    var head: ASImageNode = ASImageNode()
    
    var title: ASTextNode = ASTextNode()
    
    var tail: ASButtonNode = ASButtonNode()
    
    var accessory: ASImageNode = ASImageNode()
    
    override init() {
        super.init()
        self.tail.addTarget(self, action: #selector(self.clickDetail(sender:)), forControlEvents: ASControlNodeEvent.touchUpInside)
        self.accessory.image = Resource.accessory
        
        self.addSubnode(self.head)
        self.addSubnode(self.title)
        self.addSubnode(self.tail)
        self.addSubnode(self.accessory)
    }
    
    
    public override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        var titleWidth: CGFloat = constrainedSize.max.width - contentInset.left - contentInset.right
        var children: [ASLayoutElement] = []
        if let _viewModel = self.viewModel as? DefaultTableCellNodeModel {

            var leadChildren: [ASLayoutElement] = []
            
            let titleSpec = ASAbsoluteLayoutSpec(children: [self.title])
            
            if let _head = _viewModel.head {
                leadChildren.append(self.head)
                titleWidth -= (_head.size.width + 10)
            }
            
            leadChildren.append(titleSpec)
            let headSpec = ASStackLayoutSpec(direction: .horizontal, spacing: 10, justifyContent: .start, alignItems: .center, children: leadChildren)
            children.append(headSpec)

            var tailChildren: [ASLayoutElement] = []

            if let _tail = _viewModel.tail {
                tailChildren.append(self.tail)
                switch _tail {
                case .attributedString(let attr):
                    titleWidth -= (attr.size().width)
                case .imageSource(let source):
                    titleWidth -= (source.targetSize.width)
                }
                titleWidth -= (10)
            }

            if _viewModel.accessorable {
                tailChildren.append(self.accessory)
                titleWidth -= (self.accessory.image?.size.width ?? 0)
                titleWidth -= (10)
            }

            let tailSpec = ASStackLayoutSpec(direction: .horizontal,
                                             spacing: 10,
                                             justifyContent: .end,
                                             alignItems: .center,
                                             children: tailChildren)

            children.append(tailSpec)
            // 由于纵横不确定, 需要指定宽度后计算高度
            titleSpec.style.preferredSize = CGSize(width: titleWidth, height: _viewModel.title.boundingRect(with: CGSize(width: titleWidth, height: constrainedSize.max.height), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil).height)
        }
        let stackSpec = ASStackLayoutSpec(direction: .horizontal, spacing: 10, justifyContent: .spaceBetween, alignItems: .center, flexWrap: .noWrap, alignContent: .center, children: children)
        return ASInsetLayoutSpec(insets: contentInset, child: stackSpec)
    }
    
    @objc func clickDetail(sender: Any) {
        (self.viewModel as? DefaultTableCellNodeModel)?.detailClick?()
    }
}

public class DefaultTableCellNodeModel: TableCellNodeModel {

    public lazy var cellNodeBlock: ASCellNodeBlock = {
        let node = DefaultTableCellNode()
        node.viewModel = self
        self.setup(for: node)
        return node
    }
    
    var head: UIImage?
    
    var title: NSAttributedString
    
    var tail: ButtonContentOptions?
    
    var detailClick: (()->Void)? = nil
    
    var accessorable: Bool
    
    init(head: UIImage? = nil,
         title: NSAttributedString,
         tail: ButtonContentOptions? = nil,
         accessorable: Bool = false) {
        
        self.head = head
        
        self.title = title
        
        self.tail = tail
        
        self.accessorable = accessorable
    }
    
    public func setup(for node: ASCellNode) {
        guard let _node = node as? DefaultTableCellNode else {return}
        _node.head.image = self.head
        _node.title.attributedText = self.title

        switch self.tail {
        case .imageSource(let source)?:
            break
        case .attributedString(let attr)?:
            _node.tail.setAttributedTitle(attr, for: UIControl.State.normal)
        default: break
        }
        _node.accessory.isHidden = !self.accessorable
        _node.tail.isUserInteractionEnabled = self.detailClick != nil
    }
}
