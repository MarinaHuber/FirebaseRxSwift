//
// MeasuringHeartRateView.swift
// BellabeatApp
//
// Created by Marina Huber on 3/16/21.
// Copyright © 2021 Bellabeat. All rights reserved.
//
import UIKit

class MeasuringHeartRateView: UIView {
    private var titleHeartRateLabel = UILabel(frame: .zero)
    private var heartMiddleLabel = UILabel(frame: .zero)
    private var heartRateImage = UIImageView(frame: .zero)
    private var heartInfoImage = UIImageView(frame: .zero)
    private var subTitleHeartRateLabel: UILabel = UILabel(frame: .zero)
    private var okButton = UIButton(frame: .zero)//OnboardingButton()
    private var dismissButton = UIButton(frame: .zero)
    private var animatingView = UIView(frame: .zero)
    var listOfNumbers = [Int]()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.setupUI()
        self.setupViews()
        self.setupConstraints()
        self.setOkButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.setShadow(color: .gray, offset: CGSize(width: 0, height: 3), opacity: 0.5)
        self.backgroundColor = .white
        self.heartMiddleLabel.font = UIFont.systemFont(ofSize: 40)
        self.heartMiddleLabel.textColor = .white
        
        self.heartInfoImage.contentMode = .scaleAspectFit
        self.heartRateImage.image = UIImage(named: "heart-1")
        self.heartRateImage.contentMode = .scaleAspectFit
        
        self.titleHeartRateLabel.text = "Measuring heart rate"
        self.titleHeartRateLabel.font = UIFont.systemFont(ofSize: 20)
        self.titleHeartRateLabel.textAlignment = .center
        self.titleHeartRateLabel.numberOfLines = 0
        
        self.subTitleHeartRateLabel.text = "Stay still for few seconds"
        self.subTitleHeartRateLabel.textAlignment = .center
        self.subTitleHeartRateLabel.numberOfLines = 0
        self.subTitleHeartRateLabel.font = UIFont.systemFont(ofSize: 16)
        self.subTitleHeartRateLabel.adjustsFontSizeToFitWidth = true
        self.subTitleHeartRateLabel.minimumScaleFactor = 0.5
        
        self.okButton.backgroundColor = .black
        self.okButton.alpha = 0
        self.dismissButton.setImage(UIImage(named: "icClose"), for: .normal)
    }
    
    func setShadow(color: UIColor, offset: CGSize, opacity: Float) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = 3
        self.setNeedsLayout()
      }
    
    private func showUIForIdleData() {
        self.heartInfoImage.alpha = 0
        self.heartMiddleLabel.alpha = 0
        self.animatingView.alpha = 1
        self.okButton.alpha = 0
        
    }
    
    private func showUIForLoadedData() {
        self.heartInfoImage.alpha = 1
        self.heartInfoImage.image = UIImage(named: "heart-measure")
        self.heartMiddleLabel.alpha = 1
        self.animatingView.alpha = 0
        self.okButton.alpha = 1
        self.subTitleHeartRateLabel.text = "A normal resting heart rate is between 60 and 100 beats per minute (bpm), depending on the person's physical condition and age."
    }
    

// MARK: - setup methods

     func transitionFromWaitingToPresentingData() {
        self.showUIForIdleData()
        let randomNumber = Int.random(in: 64...82)
        UIView.transition(with: self, duration: 3.0, options: .transitionCrossDissolve, animations: {
            self.showUIForLoadedData()
        }, completion: { _ in
            UIView.transition(with: self, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.titleHeartRateLabel.text = "Current heart rate"
            self.addHeartRate(bpm: randomNumber)
            })
        })
    }
    
    private func addHeartRate(bpm: Int) {
        self.listOfNumbers.append(bpm)
        if listOfNumbers.count > 30 {
            listOfNumbers.remove(at: 0)
        }
        let sum = listOfNumbers.reduce(0, +)
        let average = sum / listOfNumbers.count
        self.heartMiddleLabel.text = "\(average)"
    }
    
  private func setupViews() {
    self.addSubview(self.dismissButton)
    self.addSubview(self.titleHeartRateLabel)
    self.addSubview(self.animatingView)
    self.addSubview(self.heartInfoImage)
    self.addSubview(self.heartRateImage)
    self.addSubview(self.subTitleHeartRateLabel)
    self.addSubview(self.heartMiddleLabel)
    self.addSubview(self.okButton)
  }
  private func setupConstraints() {
    self.titleHeartRateLabel.snp.makeConstraints { (make) in
        make.top.equalToSuperview().offset(90)
        make.centerX.equalToSuperview()
        make.width.equalToSuperview().offset(-180)
    }
    
    self.heartRateImage.snp.makeConstraints { (make) in
        make.top.equalTo(self.titleHeartRateLabel.snp.bottom).offset(90)
        make.centerX.equalTo(self.titleHeartRateLabel.snp.centerX)
        make.height.width.equalTo(35)
    }
    self.heartInfoImage.snp.makeConstraints { (make) in
        make.top.equalTo(self.titleHeartRateLabel.snp.bottom).offset(50)
        make.centerX.equalTo(self.titleHeartRateLabel.snp.centerX)
        make.height.width.equalTo(120)
       // make.width.equalTo(150)
    }
    
    self.heartMiddleLabel.snp.makeConstraints { (make) in
        make.center.equalTo(self.heartRateImage.snp.center)
    }
    
    self.animatingView.snp.makeConstraints { (make) in
        make.center.equalTo(self.heartRateImage.snp.center)
        make.height.width.equalTo(180)
    }
    
    self.subTitleHeartRateLabel.snp.makeConstraints { (make) in
        make.top.equalTo(self.heartInfoImage.snp.bottom).offset(70)
        make.width.equalToSuperview().offset(-80)
        make.centerX.equalTo(self.heartInfoImage.snp.centerX)
    }
    
    self.okButton.snp.makeConstraints { (make) in
        make.centerX.equalTo(self.safeAreaLayoutGuide.snp.centerX)
        make.width.equalTo(self.safeAreaLayoutGuide.snp.width).offset(-30)
        make.height.equalTo(55)
        make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-30)
    }
    self.dismissButton.snp.makeConstraints { (make) in
        make.right.equalTo(self.safeAreaLayoutGuide.snp.right).offset(-15)
        make.height.width.equalTo(35)
        make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(15)
    }
  }
    
    func setOkButton() {
        self.okButton.layer.cornerRadius = 27
        self.okButton.tintColor = .white
        self.okButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        self.okButton.setTitle("OK", for: .normal)
    }
    
    private func setUpAnimations() {
            self.animatingView.scaleAnimtation()
        

    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setUpAnimations()
    }
}

extension UIView {
    func scaleAnimtation() {
        let outerCircleLayer = CAShapeLayer()
        self.layer.addSublayer(outerCircleLayer)

        outerCircleLayer.borderColor = UIColor(hexString: "#FF8BA1").cgColor
        outerCircleLayer.borderWidth = 4
        outerCircleLayer.cornerRadius = 90
        outerCircleLayer.fillColor = UIColor.white.cgColor
        
        outerCircleLayer.path = UIBezierPath(ovalIn: self.bounds).cgPath
        outerCircleLayer.frame = self.bounds
        
        let anim = CABasicAnimation(keyPath: "transform.scale")
        anim.fromValue = 1
        anim.toValue =  0.5
        anim.timingFunction = CAMediaTimingFunction(name: .easeIn)
        anim.duration = 1.2

        anim.autoreverses = true
        anim.repeatCount = .infinity
        
        outerCircleLayer.add(anim, forKey: nil)
    }
}


extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
