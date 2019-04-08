//
//  MapController.swift
//  PTBaseKit
//
//  Created by P36348 on 21/05/2018.
//  Copyright © 2018 P36348. All rights reserved.
//

import UIKit
import CoreLocation

func createMapController() -> UIViewController {
    let controller = BaseController()
    
    let mapAdapter: MapAdapter = createDefaultMapAdapter()
    
    mapAdapter
        .didUpdateUserLocation
        .take(1)
        .subscribe(onNext: { $0.adapter.moveCenter(to: $0.location) })
        .disposed(by: controller)
    
    
    mapAdapter
        .didTapAtLocation
        .subscribe(onNext: { $0.adapter.moveCenter(to: $0.location) })
        .disposed(by: controller)
    
    mapAdapter
        .didIdleAtLocation
        .subscribe()
        .disposed(by: controller)
    
    controller.rx.viewDidLoad
        .subscribe(onNext: { (_controller) in
            _controller.view.addSubview(mapAdapter.map.viewValue)
            mapAdapter.map.viewValue.snp.makeConstraints {$0.edges.equalToSuperview()}
        })
        .disposed(by: controller)
    
    controller.rx.viewDidAppear
        .subscribe(onNext: { (_controller) in
            mapAdapter.enable(false)
        })
        .disposed(by: controller)
    
    controller.rx.viewDidDisappear
        .subscribe(onNext: { (_controller) in
            mapAdapter.enable(true)
        })
        .disposed(by: controller)
    
    return controller
}

func createDefaultMapAdapter() -> MapAdapter {
    return GoogleMapsAdapter(googleApiKey: "AIzaSyC7MlLSfn5vv6xj0au2G4ceRPa8UFfHm00",
                             defaultLocation: CLLocationCoordinate2D(latitude: 1.420612, longitude: 103.862463))
}

private class MapController: BaseController {
    
    let mapAdapter: MapAdapter
    
    public init(mapAdapter: MapAdapter) {
        self.mapAdapter = mapAdapter
        super.init(nibName: nil, bundle: nil)
    }
    
    public convenience init() {
        self.init(mapAdapter: createDefaultMapAdapter())
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    override func performSetup() {
        
        self.view.addSubview(self.mapAdapter.map.viewValue)
        self.mapAdapter.map.viewValue.snp.makeConstraints {$0.edges.equalToSuperview()}
        
        self.mapAdapter.enable(true)
        
        self.addMapObservers()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.mapAdapter.enable(false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.mapAdapter.enable(true)
    }
    
    func addMapObservers() {
        self.mapAdapter
            .didUpdateUserLocation
            .take(1)
            .subscribe(onNext: { $0.adapter.moveCenter(to: $0.location) })
            .disposed(by: self)
        
        
        self.mapAdapter
            .didTapAtLocation
            .subscribe(onNext: { $0.adapter.moveCenter(to: $0.location) })
            .disposed(by: self)
        
        self.mapAdapter
            .didIdleAtLocation
            .subscribe()
            .disposed(by: self)
        
//        self.mapAdapter.didTapAnnotation = { _ in true }
    }
}

