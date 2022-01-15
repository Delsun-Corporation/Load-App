//
//  RPMSelectionVc.swift
//  Load
//
//  Created by iMac on 25/04/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import RangeSeekSlider

class RPESelectionVc: UIViewController {
    
    //MARK:- Variables
    lazy var mainView: RPESelectionView = { [unowned self] in
        return self.view as! RPESelectionView
        }()
    
    lazy var mainModelView: RPESelectionViewModel = {
        return RPESelectionViewModel(theController: self)
    }()
    
    var previousStepMinValue : CGFloat?
    //MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mainView.setupUI(theController:self)
        self.mainView.setupSlider(theController:self)
//
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(sliderTapped(gestureRecognizer:)))
//        mainView.customSlider.addGestureRecognizer(tapGestureRecognizer)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.mainModelView.setupNavigationbar(title: getCommonString(key: "Rate_your_workout_key"))
    }
    
    @IBAction func sliderDidEndSliding(_ sender: UISlider) {

//        print("touch up inside new value : \(sender.value)")
//
//        let value = sender.value.rounded()

//        let roundedValue = round(sender.value / 1) * 1
//        print("touch up inside Slider scroll value : \(Float(roundedValue))")

//        if Int(roundedValue) <= 1{
//            self.mainModelView.selectedRPESliderValue = Int(1)
//        }else{
//            self.mainModelView.selectedRPESliderValue = Int(roundedValue.rounded())
//        }

//        self.mainView.customSlider.layoutIfNeeded()
//        self.mainView.customSlider.layoutSubviews()
//
//        print("touch up inside setValue Passed : \(self.mainModelView.selectedRPESliderValue)")
//        self.mainView.customSlider.setValue(value, animated: true)
//        self.mainView.tblRPMDetails.reloadData()
//
    }
    
    @IBAction func sliderValueChanges(_ sender: UISlider) {
        
        print("Main Value : \(sender.value)")
        print("value : \(sender.value.rounded())")
        let value = sender.value.rounded()
        
//        if Int(roundedValue) <= 1{
//            self.mainModelView.selectedRPESliderValue = Int(1)
//        }else{
//            self.mainModelView.selectedRPESliderValue = Int(value)
//        }
        self.mainModelView.selectedRPESliderValue = Int(value)
        
        self.mainView.customSlider.layoutIfNeeded()
        self.mainView.customSlider.layoutSubviews()

        if let previousStepMinValue = previousStepMinValue, previousStepMinValue != CGFloat(value) {
            setVibration()
        }
        previousStepMinValue = CGFloat(value)
        
        self.mainView.customSlider.setValue(value, animated: false)
        
        self.mainView.tblRPMDetails.reloadData()

    }
    
    @IBAction func btnSaveTapped(_ sender: UIButton) {
        self.mainModelView.saveSummaryCardiolog()
    }
    
}


//MARK: - Slider Method
extension RPESelectionVc{
    
    @objc func sliderTapped(gestureRecognizer: UIGestureRecognizer) {
        
        let pointTapped: CGPoint = gestureRecognizer.location(in: self.view)
        let positionOfSlider: CGPoint = mainView.customSlider.bounds.origin
        let widthOfSlider: CGFloat = mainView.customSlider.frame.size.width
         
        let newValue = ((pointTapped.x - positionOfSlider.x) * CGFloat(mainView.customSlider.maximumValue) / widthOfSlider)
        let roundedValue = round(newValue / 1) * 1
        
//        if Int(roundedValue) <= 1{
//            self.mainModelView.selectedRPESliderValue = Int(1)
//        }else{
//            self.mainModelView.selectedRPESliderValue = Int(roundedValue.rounded())
//        }
        
        print("setValue Passed : \(self.mainModelView.selectedRPESliderValue)")
        
        self.mainModelView.selectedRPESliderValue = Int(roundedValue)

        self.mainView.customSlider.layoutIfNeeded()
        self.mainView.customSlider.layoutSubviews()
        setVibration()

        mainView.customSlider.setValue(Float(roundedValue), animated: true)
        self.mainView.tblRPMDetails.reloadData()
    }

}


extension RPESelectionVc: RangeSeekSliderDelegate {
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        print("Standard slider updated. Min Value: \(minValue) Max Value: \(maxValue)")
        self.mainModelView.selectedRPESliderValue = Int(maxValue)
        self.mainView.tblRPMDetails.reloadData()
    }
    
    func didStartTouches(in slider: RangeSeekSlider) {
        
        print("did start touches:\(slider.selectedMaxValue)")
    }
    
    func didEndTouches(in slider: RangeSeekSlider) {
        print("did end touches")
    }
}
