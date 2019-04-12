//
//  ViewController.swift
//  PTBaseKit
//
//  Created by P36348 on 2018/4/25.
//  Copyright © 2018 P36348. All rights reserved.
//

import UIKit
import RxSwift


class ViewController: BaseController {
    
    override func performSetup() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

private func testCss() {
    // old method
    let label: UILabel = UILabel()
    label += 13.customFont
    label += UIColor.pt.main.textColorCss
    label += "custom label"
    
    // new method
    let customLabel: UILabel = UILabel() + 13.customFont.css + UIColor.pt.main.textColorCss + "custom label".css
    
    customLabel.sizeToFit()
    
    // MARK: image source + css
    
    let imageURLStr: String = "https://static.chiphell.com/forum/201804/23/034030hpfx7el7tz1u8oej.jpg"
    
    let image: UIImage = UIImage()
    
    let imageData: Data = Data()
    
    let imageView: UIImageView = UIImageView() + imageURLStr.imageSourceCss
    
    let button: UIButton = UIButton() + imageURLStr.imageSourceCss
    
    imageView + image.imageSourceCss
    
    imageView + imageData.imageSourceCss
    
    button + imageSource(with: imageURLStr, placeHolder: imageData, css: nil, targetSize: CGSize(width: 48, height: 48)).imageSourceCss
}


