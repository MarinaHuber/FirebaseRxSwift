//
//  RespiratoryChartView.swift
//  BellaBeatFirebase
//
//  Created by Marina Huber on 06.04.2021..
//  Copyright © 2021 Marina Huber. All rights reserved.
//

import UIKit
import AAInfographics
import SnapKit

class RespiratoryChartView: UIView {
    private var iconView = UIImageView(frame: .zero)
    private var bgImageView = UIImageView(frame: .zero)
    private var roundView = UIView(frame: .zero)
    private var titleLabel = UILabel()
    private var subTitleLabel = UILabel()
    private var aaChartView = AAChartView()
    lazy private var mockData: [HeartRateAggregateItem] = self.generateMockData(30)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.text = "RESPIRATORY HEART RATE"
        self.titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        self.subTitleLabel.text = "explanation"
        self.subTitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        self.iconView.contentMode = .scaleAspectFit
        self.bgImageView.contentMode = .scaleToFill
        self.bgImageView.alpha = 0.2
        self.iconView.image = UIImage(named: "Vector.png")
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
    
    private func setupChartView() {
        self.aaChartView.isClearBackgroundColor = true
        self.aaChartView.scrollEnabled = false
        self.addSubview(self.aaChartView)
        aaChartView.translatesAutoresizingMaskIntoConstraints = false
        aaChartView.scrollView.contentInsetAdjustmentBehavior = .never
    }
    
    private func setupConstraints() {
        roundView.snp.makeConstraints { (make) in
            make.center.equalTo(self.iconView.snp.center)
            make.height.width.equalTo(37)
        }
        
        iconView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(33) //from figma
            make.left.equalToSuperview().offset(28)
            make.height.width.equalTo(15)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(22)
            make.centerX.equalTo(self.snp.centerX)
            
        }
        subTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(2)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        aaChartView.snp.makeConstraints { (make) in
            make.top.equalTo(self.subTitleLabel.snp.bottom).offset(25)
            make.width.equalToSuperview().offset(-40)
            make.centerX.equalTo(self.snp.centerX)
            make.height.equalTo(220)
        }
    }
    
    func generateMockData(_ units: Int) -> [HeartRateAggregateItem] {
        var graphField = [HeartRateAggregateItem]()
        for _ in 0..<units {
            graphField.append(self.generateRandomHeartRateAggregareItem())
        }
        return graphField
    }
    
    func generateRandomHeartRateAggregareItem() -> HeartRateAggregateItem {
        let min = Double.random(in: 50...200)
        let max = min + Double.random(in: 10...50)
        let avg = (max + min) / 2
        return HeartRateAggregateItem(max: max, min: min, avg: avg)
    }
    
    private func configureColumnrangeMixedLineChart() {
        let aaChartModel = AAChartModel()
            .chartType(.columnrange)
            .axesTextColor(AAColor.black)
            .xAxisVisible(true)
            .legendEnabled(false)
            .margin(top: 10.0, right: 10.0, bottom: 40.0, left: 40.0)
            
            .series([
                AASeriesElement()
                    .type(.line)
                    .color("#5F95E7")
                    .lineWidth(0.8)
                    .enableMouseTracking(false)
                    .zIndex(1)
                    .data(mockData.map{ $0.avg ?? 0 })
                    .marker(AAMarker()
                                .lineWidth(0.5)
                                .lineColor(AAColor.white)
                                .states(AAMarkerStates()
                                            .hover(AAMarkerHover()
                                                    .enabled(false)))
                    ),
                
                AASeriesElement()
                    .enableMouseTracking(false)
                    .zIndex(0)
                    .data(mockData.map{ [$0.min, $0.max] })
                    .color(AAColor.rgbaColor(95, 149, 231, 0.1))
            ])
        
        let aaOptions = AAOptionsConstructor.configureChartOptions(aaChartModel)
        aaOptions.yAxis?
            .max(roundToTens(calculateMaxValue())).min(0)
            .allowDecimals(false)
            .lineWidth(0)
            .gridLineWidth(0)
            .alternateGridColor("#F9F9FA")
            .tickInterval(Float(roundToTens(calculateMaxValue())/10.0))
        aaOptions.yAxis?.labels(AALabels()
                                    .x(-35)
                                    .align("left")
                                    .style(AAStyle()
                                            .color(AAColor.black)
                                            .fontWeight(AAChartFontWeightType.regular)
                                            .fontSize(13)))
        aaOptions.xAxis?
            .gridLineWidth(0)
            .tickInterval(24)
            .gridLineWidth(1)
            .gridLineDashStyle(.shortDash)
        aaOptions.xAxis?.labels(AALabels()
                                    .y(20)
                                    .align("center")
                                    .style(AAStyle()
                                            .color(AAColor.black)
                                            .fontWeight(AAChartFontWeightType.regular)
                                            .fontSize(13)))
        aaOptions.xAxis?.categories(["AM", "PM"])
        
        aaOptions.plotOptions?.columnrange(AAColumnrange()
                                            .borderRadius(5)
                                            .borderWidth(0))
        
        self.aaChartView.aa_drawChartWithChartOptions(aaOptions)
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
        return array.max() ?? 0
    }
}
