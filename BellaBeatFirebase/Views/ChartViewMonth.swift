//
//  ChartViewMonth.swift
//  BellaBeatFirebase
//
//  Created by Marina Huber on 11.03.2021..
//  Copyright © 2021 Marina Huber. All rights reserved.
//

import UIKit
import AAInfographics
import SnapKit

class ChartViewMonth: UIView {
    private var iconView = UIImageView(frame: .zero)
    private var roundView = UIView(frame: .zero)
    private var titleLabel = UILabel()
    private var subTitleLabel = UILabel()
    private var infoButton = UIButton(type: .infoLight)
    private var aaChartView = AAChartView()
    lazy private var mockData: [HeartRateAggregateItem] = self.generateMockData(10)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.titleLabel.text = "cardiac coherence".uppercased()
        self.titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        self.subTitleLabel.text = "heart rate and respiration sync"
        self.subTitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        self.infoButton.setImage(UIImage(named: "black_info"), for: .normal)
        self.infoButton.imageView?.contentMode = .scaleAspectFit
        self.iconView.contentMode = .scaleAspectFit
        self.iconView.image = UIImage(named: "heart.png")
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
        self.setupChartView()
        self.addSubview(self.roundView)
        self.addSubview(self.iconView)
        self.addSubview(self.infoButton)
        self.addSubview(self.titleLabel)
        self.addSubview(self.subTitleLabel)
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
        
        infoButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(18)
            make.right.equalToSuperview().offset(-15)
            make.height.width.equalTo(25)
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
            make.top.equalTo(self.subTitleLabel.snp.bottom).offset(40)
            make.width.equalToSuperview().offset(-40)
            make.centerX.equalTo(self.snp.centerX)
            make.height.equalTo(220)
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
            .chartType(.line)
            .animationType(.easeInOutQuad)
            .markerSymbolStyle(.borderBlank)
            .axesTextColor(AAColor.black)
            .xAxisVisible(true)
            .legendEnabled(false)
            .markerRadius(6)
            .margin(top: 10.0, right: 10.0, bottom: 40.0, left: 30.0)
            .series([
                AASeriesElement()
                    .lineWidth(2)
                    .color("#0DE2B5")
                    .data(mockData.map{ $0.avg ?? 0 }) // change like heart rate
                    .enableMouseTracking(false)
                    .marker(AAMarker()
                               .fillColor("#AB69FF")
                               .lineWidth(20)
                               .lineColor(AAColor.rgbaColor(171, 105, 255, 0.2))
                               .states(AAMarkerStates()
                                            .hover(AAMarkerHover()
                                                    .enabled(false)))
                    )
            ])
        
        let aaOptions = AAOptionsConstructor.configureChartOptions(aaChartModel)
        aaOptions.yAxis?
            .lineWidth(0)
           // .tickInterval(Float(maxValue/10.0))
            .gridLineWidth(0)
            .plotBands([
                AAPlotBandsElement()
                    .from(60)
                    .to(110)
                    .color(AAColor.rgbaColor(171, 105, 255, 0.1))
                    .outerRadius("105%")
                    .thickness("5%")
            ])
        aaOptions.yAxis?.labels(AALabels()
                                    .x(-45)
                                    .align("left")
                                    .style(AAStyle()
                                            .color(AAColor.black)
                                            .fontWeight(AAChartFontWeightType.regular)
                                            .fontSize(13)))
        aaOptions.xAxis?.labels(AALabels()
                                    .y(20)
                                    .align("center")
                                    .style(AAStyle()
                                            .color(AAColor.black)
                                            .fontWeight(AAChartFontWeightType.regular)
                                            .fontSize(13)))

        aaOptions.xAxis?
            .gridLineWidth(0)
            .tickInterval(24)//change to maxvalue / 10
            .gridLineWidth(1)
            .gridLineDashStyle(.shortDash)
        aaOptions.xAxis?.labels(AALabels()
                                    .y(20)
                                    .align("center")
                                    .style(AAStyle()
                                            .color(AAColor.black)
                                            .fontWeight(AAChartFontWeightType.regular)
                                            .fontSize(13)))
        aaOptions.xAxis?.categories(["AM", "PM"]) // isto kao u heart rate chartview
        
        self.aaChartView.aa_drawChartWithChartOptions(aaOptions)
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
        let min = Double.random(in: 50...100)
        let max = min + Double.random(in: 10...50)
        let avg = (max + min) / 2
        return HeartRateAggregateItem(max: max, min: min, avg: avg)
    }
    
}
