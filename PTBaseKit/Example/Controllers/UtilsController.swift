//
//  UtilsController.swift
//  PTBaseKit
//
//  Created by P36348 on 22/08/2018.
//  Copyright © 2018 P36348. All rights reserved.
//

import UIKit
import RxSwift

class UtilsController: BaseController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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

private func testFoundation() {
    // MARK: user default
    // old
    let _ = UserDefaults.standard.object(forKey: "hello") as? Int64
    // new
    let _ = Int64.objectUserDefaults(forKey: "hello")
    
    // MARK: Attributed String
    // old
    let _ = {
        let attrHeadString  = NSMutableAttributedString(string: "test attr")
        let attrMidString   = NSAttributedString(string: "test attr")
        let attrTrailString = NSAttributedString(string: "test attr")
        
        attrHeadString.append(attrMidString)
        attrHeadString.append(attrTrailString)
    }
    // new
    let _ = { () -> NSAttributedString in
        let attrHeadString  = "test attr".attributed()
        let attrMidString   = "mid".attributed()
        let attrTrailString = "trail".attributed()
        
        return attrHeadString + attrMidString + attrTrailString
    }
}

private let queue: DispatchQueue = DispatchQueue(label: "test.async.fake.download",
                                                 qos: DispatchQoS.default,
                                                 attributes: DispatchQueue.Attributes.concurrent,
                                                 target: nil)

private let semaphore: DispatchSemaphore = DispatchSemaphore(value: 2)

private func testAsync() {
    (0...9).forEach { (index) in
        queue.async {
            semaphore.wait()
            print("sleep at index:", index)
            Thread.sleep(forTimeInterval: 5)
            print("index:", index, "semaphore:", semaphore.signal(), "thread:", Thread.current)
        }
    }
}

private var disposeBag: DisposeBag = DisposeBag()

private let loopQueue: OperationQueue = OperationQueue()

private func testLoopOperation() {
    rx_createLoopOperation(gap: 5, name: "test.loop.operation.in.??.queue")
        .subscribe(onNext: { (_) in
            print("loop called")
        })
        .disposed(by: disposeBag)
    
    rx_createLoopOperation(gap: 5, name: "test.loop.operation.in.queue", queue: loopQueue)
        .subscribe(onNext: { (_) in
            print("loop called")
        })
        .disposed(by: disposeBag)
    
    DispatchQueue.global()
        .rx_async(with: ())
        .flatMap {rx_createLoopOperation(gap: 5, name: "test.loop.operation.in.global.queue")}
        .subscribe(onNext: { (_) in
            print("loop called")
        })
        .disposed(by: disposeBag)
}
