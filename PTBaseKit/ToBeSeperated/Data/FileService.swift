//
//  FileService.swift
//  UserProfileModule
//
//  Created by P36348 on 02/01/2018.
//  Copyright © 2018 P36348. All rights reserved.
//

import Foundation
import RxSwift
import Kingfisher

public struct SanBoxPath {
    
    public static var home: String = NSHomeDirectory()
    
    public static var documents: String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
    
    public static var caches: String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
    
    public static var library: String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
    
    public static var temporary: String = NSTemporaryDirectory()
    
    public static var images: String = documents.appending("/Images")
    
    public static var uploadImages: String = images.appending("/UploadImages")
}

public class FileService {
    
    public static let shared: FileService = FileService()
    
    private var fileManager: FileManager = FileManager.default
    
    private let operationQueue: OperationQueue = {
        let _queue = OperationQueue()
        
        _queue.maxConcurrentOperationCount = 1
        _queue.qualityOfService = .utility
        
        return _queue
    }()
    
    public func create(data: Data, path: String, fileName: String, completion: @escaping (String, Error?) -> Void) {
        
        self.operationQueue.addOperation {
            DispatchQueue.global().async {
                
                if !self.fileManager.fileExists(atPath: path) {
                    do {
                        try self.fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
                    }catch {
                        completion(path + "/" + fileName, error)
                    }
                }
                
                var _error: Error?
                
                if !self.fileManager.createFile(atPath: path + "/" + fileName, contents: data, attributes: nil) {
                    _error = NSError(domain: "Faild to creat file at path:" + path, code: 0, userInfo: nil)
                }
                
                DispatchQueue.main.async {
                    completion(path + "/" + fileName, _error)
                }
            }
        }
    }
    
    public func create(image: UIImage, fileName: String) -> Observable<String> {
        guard
            let _data = image.jpegData(compressionQuality: 0.7) // PNG: UIImagePNGRepresentation(image)
            else
        {
            return Observable.error(NSError(domain: "Faild to convert" + image.description + "to data", code: 0 , userInfo: nil))
        }
        return Observable.create({ [weak self] (observer) -> Disposable in
            self?.create(data: _data, path: SanBoxPath.images, fileName: fileName, completion: { (path, error) in
                if let _error = error {
                    observer.onError(_error)
                }else {
                    observer.onNext(path)
                }
            })
            return Disposables.create()
        })
    }
    
    public func imageData(fileName: String) -> Data? {
        let path = SanBoxPath.images + "/" + fileName
        self.fileManager.fileExists(atPath: path)
        return self.fileManager.contents(atPath: path)
    }
    
    private var isCalculating: Bool = false
    
    
    public func clean() -> Observable<String> {
        return Observable.combineLatest([self.cleanCustomImages(), self.cleanImageCache()]).map({ (values) -> String in
            return values.joined(separator: "/n")
        })
    }
    
    private func cleanCustomImages() -> Observable<String> {
        return self.cleanData(at: SanBoxPath.uploadImages)
    }
    
    private func cleanImageCache() -> Observable<String> {
        return Observable<String>.create { (observer) -> Disposable in
            KingfisherManager.shared.cache.clearDiskCache(completion: {
                observer.onNext("Network Images Clean")
                observer.onCompleted()
            })
            return Disposables.create()
        }
    }
    
    public func cleanData(at path: String) -> Observable<String>{
        return Observable<String>.create { (observer) -> Disposable in
            if self.fileManager.fileExists(atPath: path) {
                do {
                    try self.fileManager.removeItem(atPath: path)
                    try self.fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
                }catch {
                    observer.onError(error)
                    observer.onCompleted()
                }
            }
            observer.onNext("Locale User Image Data Clean")
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    public func calculateCacheSize() -> Observable<UInt64> {
        return Observable.combineLatest(self.calculateSize(path: SanBoxPath.images), self.calculateImageCacheSize()).map{ return $0 + $1 }
    }
    
    public func calculateSize(path: String) -> Observable<UInt64> {
        
        return Observable<UInt64>.create { [unowned self] (observer) -> Disposable in
            
            if self.isCalculating {
                observer.onError(NSError(domain: "Already Calculating", code: -1, userInfo: nil))
                observer.onCompleted()
            }else {
                self.isCalculating = true
                
                DispatchQueue.main.async {
                    self.isCalculating = false
                    observer.onNext(0)
                    observer.onCompleted()
                }
            }
            
            return Disposables.create()
        }
    }
    
    public func calculateImageCacheSize() -> Observable<UInt64> {
        return Observable<UInt64>.create { (observer) -> Disposable in
            KingfisherManager.shared.cache.calculateDiskCacheSize(completion: { (size) in
                observer.onNext(UInt64(size))
            })
            return Disposables.create()
        }
    }
}
