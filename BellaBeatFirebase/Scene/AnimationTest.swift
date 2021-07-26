//
//  AnimationTest.swift
//  BellaBeatFirebase
//
//  Created by Marina Huber on 16.03.2021..
//  Copyright © 2021 Marina Huber. All rights reserved.
//

import UIKit
import SnapKit
//import BellabeatCommon
//import BellabeatModel
//import BellabeatBluetoothApi


class AnimationTest: UIViewController {
    private let measureView = MeasuringHeartRateView()
    private var graphSegmentedControl = UISegmentedControl()
    
//    init(commonFactory: CommonFactory, leafDeviceService: LeafDeviceService) {
//        self.leafApi = commonFactory.getLeafAPIHelper()
//        self.leafDeviceService = leafDeviceService
//
//        super.init(nibName: nil, bundle: .main)
//    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGraphSegmentedControl()
        self.view.addSubview(self.graphSegmentedControl)
        self.view.addSubview(self.measureView)
        view.backgroundColor = .white
        
        self.graphSegmentedControl.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-30)
            make.height.equalTo(35)
        }
        
        self.measureView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(80)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-30)
            make.width.equalToSuperview().offset(-60)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.measureView.transitionFromWaitingToPresentingData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.measureView.layer.cornerRadius = 10
    }
    
    private func setupGraphSegmentedControl() {
        let items = ["Heart rate", "Speed", "Pace"]
        self.graphSegmentedControl = UISegmentedControl(items: items)
        self.graphSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
//        self.graphSegmentedControl.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        self.graphSegmentedControl.selectedSegmentIndex = 0
//        self.graphSegmentedControl.backgroundColor = .blue
//        self.graphSegmentedControl.tintColor = .white
        self.graphSegmentedControl.addTarget(self, action: #selector(graphDidChange(_:)), for: .valueChanged)
    
    }
    
    @objc func graphDidChange(_ segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            break
        case 1:
            break
        case 2:
            break
        default: break
            
        }
    }
}
