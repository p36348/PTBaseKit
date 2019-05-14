//
//  ShareController.swift
//  PTBaseKit
//
//  Created by P36348 on 28/03/2018.
//  Copyright © 2018 ThinkerVC. All rights reserved.
//

import UIKit


private let kItemWidth: CGFloat = 50

private let kLineSpecing: CGFloat = 39

public class ShareController: BaseController {
    
    let titleLabel: UILabel = UILabel()
    
    private var layout: UICollectionViewFlowLayout {return self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout}
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = kLineSpecing
        layout.itemSize = CGSize(width: kItemWidth, height: kItemWidth + 19 + 5)
        collection.delegate = self
        collection.dataSource = self
        collection.register(ShareItemCell.self, forCellWithReuseIdentifier: ShareItemCell.description())
        collection.backgroundColor = UIColor.pt.white
        return collection
    }()
    
    let wrapper: UIView = UIView()
    
    let cancelBtn: UIButton = UIButton()
    
    fileprivate var items: [ShareItemCellViewModel] = []
    
    convenience public init(items: [ShareItemCellViewModel]) {
        self.init()
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
        self.items = items
        let wrapperLength: CGFloat = kScreenWidth - 20
        switch items.count {
        case 1, 2, 3, 4:
            self.layout.sectionInset = UIEdgeInsets(top: 0, left: (wrapperLength - CGFloat(items.count)*kItemWidth - CGFloat(items.count-1)*kLineSpecing)/2, bottom: 0, right: 0)
        default :
            self.layout.sectionInset = UIEdgeInsets(top: 0, left: (wrapperLength - CGFloat(4)*kItemWidth - CGFloat(3)*kLineSpecing)/2, bottom: 0, right: 0)
        }
    }
    
    override public func performPreSetup() {
        self.view.backgroundColor = UIColor.pt.black.withAlphaComponent(0.6)
        
        self.view += [self.wrapper, self.cancelBtn]
        
        self.wrapper += [self.titleLabel, self.collectionView]
        self.wrapper.backgroundColor = UIColor.pt.white
        self.wrapper += 12.cornerRadiusCss
        
        self.titleLabel.attributedText = "分享到".attributed([.font(14.customRegularFont), .color(UIColor.pt.gray)])
        
        self.cancelBtn.setAttributedTitle("取消".attributed([.font(20.customRegularFont), .color(UIColor.pt.main)]), for: UIControl.State.normal)
        self.cancelBtn.backgroundColor = UIColor.white
        self.cancelBtn += 12.cornerRadiusCss
        self.cancelBtn.performWhenClick { [weak self] in
            self?.dismiss(animated: true, completion: nil)
            }.disposed(by: self)
        
        self.wrapper.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalTo(self.cancelBtn.snp.top).offset(-8)
            make.height.equalTo(139)
        }
        
        self.titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(15)
        }
        
        self.collectionView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.titleLabel.snp.bottom).offset(5)
        }
        
        self.cancelBtn.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.wrapper)
            make.height.equalTo(57)
            make.bottom.equalToSuperview().offset(-kSafeAreInsets.bottom - 9)
        }
    }
    
    override public func performSetup() {
        
    }
}

extension ShareController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: ShareItemCell.description(), for: indexPath)
    }
}

extension ShareController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? ShareItemCell)?.setup(with: self.items[indexPath.row])
    }
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.items[indexPath.row].clicked?()
        self.dismiss(animated: true, completion: nil)
    }
}

private class ShareItemCell: UICollectionViewCell {
    let customImage: UIImageView = UIImageView()
    let titleLabel: UILabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView += [self.customImage, self.titleLabel]
        
        self.customImage.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
        }
        
        self.titleLabel.snp.makeConstraints { (make) in
            make.centerX.bottom.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with viewModel: ShareItemCellViewModel) {
        self.customImage.setupImage(with: viewModel.imageSource)
        self.titleLabel.attributedText = viewModel.title
    }
}

public class ShareItemCellViewModel {
    var clicked: (()->Void)? = nil
    var imageSource: ImageSource? = nil
    var title: NSAttributedString? = nil
    
    public init(clicked: (()->Void)?, imageSource: ImageSource?, title: NSAttributedString?) {
        self.title = title
        self.clicked = clicked
        self.imageSource = imageSource
    }
}

