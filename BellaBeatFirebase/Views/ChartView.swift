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
    
    private var iconView = UIImageView(frame: .zero)
    private var bgImageView = UIImageView(frame: .zero)
    private var roundView = UIView(frame: .zero)
    private var titleLabel = UILabel()
    private var subTitleLabel = UILabel()
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
        self.bgImageView.image = UIImage(named: "background-image.png")
        self.roundView.layer.cornerRadius = 19
        self.roundView.layer.borderWidth = 0.8
        self.roundView.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 7
        self.layer.masksToBounds = true
        self.setupViews()
        self.setupConstraints()
        self.configureColumnrangeMixedLineChart()
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
            make.top.equalTo(self.subTitleLabel.snp.bottom).offset(40)
            make.width.equalToSuperview().offset(-40)
            make.centerX.equalTo(self.snp.centerX)
            make.height.equalTo(280)
        }
        
        self.bgImageView.snp.makeConstraints { (make) in
            make.top.equalTo(aaChartView.snp.top)
            make.right.equalTo(aaChartView.snp.right)
            make.left.equalTo(aaChartView.snp.left).offset(40)
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
    
    private func configureColumnrangeMixedLineChart() {
        let aaChartModel = AAChartModel()
            .colorsTheme(["#FFE5E5"])
            .chartType(.columnrange)
            .axesTextColor(AAColor.black)
            .xAxisVisible(true)
            .legendEnabled(false)
            .yAxisMin(40) //start showing data from 40bpm
            .margin(top: 10.0, right: 10.0, bottom: 40.0, left: 50.0)
            
            .series([
                AASeriesElement()
                    .type(.line)
                    .color("#FF0000")
                    .lineWidth(0.8)
                    .enableMouseTracking(false)
                    .zIndex(1)
                    .data(mockData.map{ $0.avg })
                    .marker(AAMarker()
                                .states(AAMarkerStates()
                                            .hover(AAMarkerHover()
                                                    .enabled(false)))
                    ),
                AASeriesElement()
                    .enableMouseTracking(false)
                    .zIndex(0)
                    .data(mockData.map{ [$0.min, $0.max] })
            ])
        
        let aaOptions = AAOptionsConstructor.configureChartOptions(aaChartModel)
        aaOptions.yAxis?
            .lineWidth(0)
            .tickInterval(20) //space between yaxis labels proportional to data
            .gridLineWidth(0)
        aaOptions.yAxis?.labels(AALabels()
                                    .x(-45)
                                    .align("left")
                                    .style(AAStyle()
                                            .color(AAColor.black)
                                            .fontWeight(AAChartFontWeightType.regular)
                                            .fontSize(13)))
        aaOptions.xAxis?.labels(AALabels()
                                    .step(2)
                                    .y(20)
                                    .x(-9)
                                    .align("left")
                                    .style(AAStyle()
                                            .color(AAColor.black)
                                            .fontWeight(AAChartFontWeightType.regular)
                                            .fontSize(13)))
        aaOptions.xAxis?.categories(createXAxisLabels(24))
        
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
        let min = Int.random(in: 50...100)
        let max = min + Int.random(in: 10...50)
        let avg = (max + min) / 2
        return HeartRateAggregateItem(max: max, min: min, avg: avg)
    }
    
    func createXAxisLabels(_ units: Int) -> [String] {
        var array = [String]()
        array.append("AM <br> 00:00")
        for _ in 0..<units - 3 {
            array.append("")
        }
        array.append("PM <br> 11:59")
        print(array.count)
        return array
    }
    
    func setupDayAverage() -> Int {
        let arrayAverage = mockData.map{ $0.avg }
        let addArrayAverage = arrayAverage.reduce(0, +)
        let dailyAverage = addArrayAverage / arrayAverage.count
        return dailyAverage
    }
}
