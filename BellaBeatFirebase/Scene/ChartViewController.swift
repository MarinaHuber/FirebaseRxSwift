//
//  ChartViewController.swift
//  BellaBeatFirebase
//
//  Created by Marina Huber on 04.03.2021..
//  Copyright © 2021 Marina Huber. All rights reserved.
//

import UIKit
import AAInfographics
import SnapKit

public struct HeartRateAggregateItem {
    let max: Double?
    let min: Double?
    let avg: Double?
}

class ChartViewController: UIViewController, AAChartViewDelegate {
    
    private let chartViewDay = ChartView(frame: .zero)
    private let chartViewWeek = ChartViewWeek(frame: .zero)
    private let chartViewMonth = RespiratoryChartView(frame: .zero)
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private var rangeColor  = "#FFE5E5"
    private var lineColor  = "#FF0000"
    private var rangeColorResting  = "#D6FF32"
    private var lineColorResting  = "#0DE2B5"
    private var xAxisLabelsResting: [String] = ["S", "M", "T", "W", "T", "F", "S"]
    private var xAxisLabels: [String] = ["12 AM", "24 PM"]
    lazy private var mockData: [HeartRateAggregateItem] = self.generateMockData(24)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGray6
        self.scrollView.showsVerticalScrollIndicator = true
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.contentView)
        self.contentView.addSubview(self.chartViewDay)
        self.contentView.addSubview(self.chartViewWeek)
        self.contentView.addSubview(self.chartViewMonth)
        chartViewDay.configureChart(maxValue: roundToTens(calculateMaxValue()), lineColor: lineColor, rangeColor: rangeColor, labels: createXAxisLabels(xAxisLabels))

        
        self.scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.contentView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        self.chartViewDay.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.width.equalTo(contentView.snp.width).offset(-20)
            make.centerX.equalTo(contentView.snp.centerX)
            make.height.equalTo(330)
        }
        
        self.chartViewWeek.snp.makeConstraints { (make) in
            make.top.equalTo(chartViewDay.snp.bottom).offset(20)
            make.width.equalToSuperview().offset(-20)
            make.centerX.equalTo(contentView.snp.centerX)
            make.height.equalTo(330)
        }
        
        self.chartViewMonth.snp.makeConstraints { (make) in
            make.top.equalTo(chartViewWeek.snp.bottom).offset(20)
            make.centerX.equalTo(contentView.snp.centerX)
            make.height.equalTo(330)
            make.width.equalTo(contentView.snp.width).offset(-20)
            
            make.bottom.equalTo(contentView.snp.bottom)
        }
    }
    
    func roundToTens(_ x : Double) -> Double {
        return 10 * Double((x / 10.0).rounded())
    }
    
    func calculateMaxValue() -> Double {
        var array = [Double]()
        _ =  mockData.map {
            let maxNum = $0.max ?? 0
            array.append(maxNum)
        }
        return array.max()!
    }
    
    func createXAxisLabels(_ labels: [String]) -> [String] {
        var array = [String]()
        array.append(labels.first ?? "")
        for _ in 0..<12 - 1  {
            array.append("")
        }
        array.append(labels.last ?? "")
        for _ in 12..<24  {
            array.append("")
        }
        print(array.count)
        return array
    }
    
    func generateMockData(_ units: Int) -> [HeartRateAggregateItem] {
        var graphField = [HeartRateAggregateItem]()
        for _ in 0..<units {
            graphField.append(self.generateRandomHeartRateAggregareItem())
        }
        return graphField
    }
    
    func generateRandomHeartRateAggregareItem() -> HeartRateAggregateItem {
        let shouldBeNil = Int.random(in: 0...5) % 3 == 0
        if shouldBeNil {
            return HeartRateAggregateItem(max: nil, min: nil, avg: nil)
        }
        let min = Double.random(in: 50...200)
        let max = min + Double.random(in: 10...50)
        let avg = (max + min) / 2
        return HeartRateAggregateItem(max: max, min: min, avg: avg)
    }

    func refreshChartWithChartConfiguration() {}

}
