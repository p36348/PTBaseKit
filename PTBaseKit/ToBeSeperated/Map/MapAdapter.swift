//
//  MapAdapter.swift
//  PTBaseKit
//
//  Created by P36348 on 21/05/2018.
//  Copyright © 2018 P36348. All rights reserved.
//

import Foundation
import RxSwift
import CoreLocation

public enum MapOverlayOption {
    case circle(location: CLLocationCoordinate2D, radius: Double), polygon(locations: [CLLocationCoordinate2D])
}

public typealias AnnotationOption = (location: CLLocationCoordinate2D, view: UIView, identifier: String)

/// 为了兼容不同地图, 抽象出的适配器
public protocol MapAdapter {
    
    // MARK: props
    
    var map: Map {get}
    
    var centerLocation: CLLocationCoordinate2D {get}
    
    var userLocation: CLLocationCoordinate2D? {get}
    
    var didTapAnnotation: ((adapter: MapAdapter, identifier: String, location: CLLocationCoordinate2D)) -> Bool {get set}
    
    var didTapAtLocation: PublishSubject<(adapter: MapAdapter, location: CLLocationCoordinate2D)> {get}
    
    var didIdleAtLocation: PublishSubject<(adapter: MapAdapter, location: CLLocationCoordinate2D)> {get}
    
    var didUpdateUserLocation: PublishSubject<(adapter: MapAdapter, location: CLLocationCoordinate2D)> {get}
    
    // MARK: functions
    
    func enable(_ flag: Bool)
    
    func moveCenter(to location: CLLocationCoordinate2D)
    
    func clear()
    
    // MARK: annotation
    
    func addAnnotations(_ annotations: [(location: CLLocationCoordinate2D, view: MapAnnotationViewSource, tapEnable: Bool, identifier: String)])
    
    func addAnnotation(location: CLLocationCoordinate2D, view: MapAnnotationViewSource, tapEnable: Bool, identifier: String)
    
    func updateAnnotation(with option: (view: MapAnnotationViewSource, tapEnable: Bool), identifier: String)
    
    func removeAnnotation(for identifier: String)
    
    func removeAllAnnotations()
    
    // MARK: line
    
    func addPolyLine(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D)
    
    func removePolyLine(at index: Int)
    
    func removeAllPolyLines()
    
    // MARK: path
    
    func fetchPathInfo(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Observable<(adapter: MapAdapter, duration: Double, distance: UInt, polyLineSource: MapPolyLineSource)>
    
    func addPath(with polyLineSource: MapPolyLineSource, fromView: MapAnnotationViewSource, toView: MapAnnotationViewSource)
    
    func addPath(fromOption: AnnotationOption, toOption: AnnotationOption)
    
    func removeAllPaths()
    
    // MARK: overlay
    
    func addOverlay(_ option: MapOverlayOption)
    
    func removeOverlay(at index: Int)
    
    func removeAllOverlays()
    
    // MARK: location
    
    func locationOfAnnotaion(for identifier: String) -> CLLocationCoordinate2D?
    
}

public protocol Map {
    var viewValue: UIView {get}
}

public protocol MapAnnotationViewSource {
    
}

public protocol MapAnnotation {
    var location: CLLocationCoordinate2D {get}
    
    var title: String? {get}
    
    var view: MapAnnotationViewSource? {get}
}


public protocol MapPolyLineSource {
    
}
