//
//  ChartView.swift
//  BellaBeatFirebase
//
//  Created by Marina Huber on 08.03.2021..
//  Copyright © 2021 Marina Huber. All rights reserved.
//

import UIKit
import AAInfographics
import SnapKit


class ChartView: UIView {
    
    private let iconView = UIImageView(frame: .zero)
    private let bgImageView = UIImageView(frame: .zero)
    private let roundView = UIView(frame: .zero)
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private var aaChartView = AAChartView()
    lazy private var mockData: [HeartRateAggregateItem] = self.generateMockData(24)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.text = "HEART RATE"
        self.titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        self.subTitleLabel.text = "Average \(setupDayAverage()) bpm"
        self.subTitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        self.iconView.contentMode = .scaleAspectFit
        self.bgImageView.contentMode = .scaleToFill
        self.bgImageView.alpha = 0.2
        self.iconView.image = UIImage(named: "heart.png")
        self.bgImageView.image = UIImage(named: "backgroundey.png")
        self.bgImageView.isHidden = true
        self.roundView.layer.cornerRadius = 19
        self.roundView.layer.borderWidth = 0.8
        self.roundView.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 7
        self.layer.masksToBounds = true
        self.setupViews()
        self.setupConstraints()
        self.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupViews() {
        self.addSubview(self.bgImageView)
        self.setupChartView()
        self.addSubview(self.roundView)
        self.addSubview(self.iconView)
        self.addSubview(self.titleLabel)
        self.addSubview(self.subTitleLabel)
    }
    
    private func setupConstraints() {
        self.roundView.snp.makeConstraints { (make) in
            make.center.equalTo(self.iconView.snp.center)
            make.height.width.equalTo(37)
        }
        
        self.iconView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(33) //from figma
            make.left.equalToSuperview().offset(28)
            make.height.width.equalTo(15)
        }
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(22)
            make.centerX.equalTo(self.snp.centerX)
            
        }
        self.subTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        self.aaChartView.snp.makeConstraints { (make) in
            make.top.equalTo(self.subTitleLabel.snp.bottom).offset(25)
            make.width.equalToSuperview().offset(-40)
            make.centerX.equalTo(self.snp.centerX)
            make.height.equalTo(220)
        }
        
        self.bgImageView.snp.makeConstraints { (make) in
            make.top.equalTo(aaChartView.snp.top).offset(-10)
            make.right.equalTo(aaChartView.snp.right).offset(-15)
            make.left.equalTo(aaChartView.snp.left).offset(35)
            make.bottom.equalTo(aaChartView.snp.bottom).offset(-40)
        }
    }
    
    private func setupChartView() {
        self.aaChartView.isClearBackgroundColor = true
        self.aaChartView.scrollEnabled = false
        self.addSubview(self.aaChartView)
        aaChartView.translatesAutoresizingMaskIntoConstraints = false
        aaChartView.scrollView.contentInsetAdjustmentBehavior = .never
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

    public func configureChart(maxValue: Double, lineColor: String, rangeColor: String, labels: [String]) {
        // data
        let dataAvg = mockData.map{ $0.avg }
        let dataMinMax = mockData.map{ [$0.min, $0.max] }
        //model
        let aaChartModel = AAChartModel()
            .colorsTheme([rangeColor]) // rangeColor
            .chartType(.columnrange)
            .animationType(.easeInQuint)
            .axesTextColor(AAColor.black)
            .xAxisVisible(true)
            .legendEnabled(false)
            .margin(top: 10.0, right: 10.0, bottom: 40.0, left: 30.0)
        //series
            .series([
                AASeriesElement()
                    .type(.line)
                    .color(lineColor) // lineColor
                    .lineWidth(0.8)
                    .enableMouseTracking(false)
                    .zIndex(1)
                    .data(dataAvg as [Any])
                    .marker(AAMarker()
                                .lineWidth(0.7)
                                .lineColor(AAColor.white)
                                .states(AAMarkerStates()
                                            .hover(AAMarkerHover()
                                                    .enabled(false)))
                    ),
                AASeriesElement()
                    .enableMouseTracking(false)
                    .zIndex(0)
                    .data(dataMinMax)
            ])
        
        let aaOptions = AAOptionsConstructor.configureChartOptions(aaChartModel)
        aaOptions.plotOptions?.columnrange(AAColumnrange()
                .borderRadius(5)
                .borderWidth(0)
                )
        // Y axis
        aaOptions.yAxis?
            .max(maxValue).min(0)
            .allowDecimals(false)
            .lineWidth(0)
            .gridLineWidth(0)
            .alternateGridColor("#F9F9FA")
            
            //add here cardiac plotBands
            .tickInterval(Float(maxValue/10.0))
        aaOptions.yAxis?.labels(AALabels()
                                    .x(-30)
                                    .align(AAChartAlignType.left.rawValue)
                                    .style(AAStyle()
                                            .color(AAColor.black)
                                            .fontWeight(AAChartFontWeightType.regular)
                                            .fontSize(13)
                                    )
                                )
        // X axis
        aaOptions.xAxis?
            .tickInterval(23)
            .gridLineWidth(1)
            .gridLineDashStyle(.shortDash)
            .labels(AALabels()
                                    .y(20)
                                    .x(-9)
                                    .align(AAChartAlignType.left.rawValue)
                                    .style(AAStyle()
                                            .color(AAColor.black)
                                            .fontWeight(AAChartFontWeightType.regular)
                                            .fontSize(13)))
            .categories(createXAxisLabels(labels))
        self.aaChartView.aa_drawChartWithChartOptions(aaOptions)
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
    
    func createXAxisLabels(_ labels: [String]) -> [String] {
        var array = [String]()
        array.append(labels.first ?? "")
        for _ in 0..<24 - 2  {
            array.append("")
        }
        array.append(labels.last ?? "")
//        for _ in 12..<24  {
//            array.append("")
//        }
//        print(array.count)
        return array
    }
    
    func setupDayAverage() -> Int {
        let filterNil = mockData.filter{ $0.avg != nil }
        let arrayAverage = filterNil.map{ $0.avg! }
        let addArrayAverage = arrayAverage.reduce(0, +)
        let dailyAverage = Int(addArrayAverage) % arrayAverage.count
        return dailyAverage
    }
}
