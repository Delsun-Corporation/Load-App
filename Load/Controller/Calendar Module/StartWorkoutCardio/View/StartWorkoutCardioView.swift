//
//  StartWorkoutCardioView.swift
//  Load
//
//  Created by Haresh Bhai on 30/11/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import GoogleMaps

class StartWorkoutCardioView: UIView {
    
    @IBOutlet weak var vwPause : UIView!
    @IBOutlet weak var lblPause : UILabel!
    @IBOutlet weak var constantVwPauseHeaderHeight: NSLayoutConstraint!
    
    @IBOutlet weak var lblWorkout: UILabel!
    @IBOutlet weak var sliderArea: UIView!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var lblNext: UILabel!
    @IBOutlet weak var vwNextWorkout: CustomView!
    @IBOutlet weak var lblNextWorkout: UILabel!
    @IBOutlet weak var countdownTimer: SRCountdownTimer!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var viewText: UIView!
    @IBOutlet weak var btnPlayPause: UIButton!
    @IBOutlet weak var vwCounterAndText: UIView!
    
    @IBOutlet weak var heightLblTotalTimeAndDuration: NSLayoutConstraint!
    @IBOutlet weak var imgDropDown: UIImageView!
    @IBOutlet weak var imgActivity: UIImageView!
    @IBOutlet weak var lblTotalTimeAndDistance: UILabel!
    @IBOutlet weak var lblLapsCompleted: UILabel!
    @IBOutlet weak var lblTotalDistance: UILabel!
    @IBOutlet weak var lblTotalDuration: UILabel!
//    @IBOutlet weak var lblTotalSpeed: UILabel!
    @IBOutlet weak var lblChangableParameter: UILabel!
    @IBOutlet weak var lblChangeableParameterValue: UILabel!
    
    @IBOutlet weak var btnMap: UIButton!
    @IBOutlet weak var vwRepeat: CustomView!
    @IBOutlet weak var btnRepeat: UIButton!
    @IBOutlet weak var btnEndWokrout: UIButton!
    @IBOutlet weak var vwEndWorkout: CustomView!
    
    
    @IBOutlet weak var widthOfLblCount: NSLayoutConstraint!
    
    //AllViews constraint
    
    @IBOutlet weak var constantTopCompleted: NSLayoutConstraint!
    @IBOutlet weak var constantTopSwitchView: NSLayoutConstraint!
    @IBOutlet weak var constantTopVwNext: NSLayoutConstraint!
    @IBOutlet weak var constantTopTotalDistance: NSLayoutConstraint!
    @IBOutlet weak var constantTopTotalDistanceValue: NSLayoutConstraint!
    @IBOutlet weak var constantTopTotalDuration: NSLayoutConstraint!
    @IBOutlet weak var constantTopTotalDurationValue: NSLayoutConstraint!
    @IBOutlet weak var constantTopBetween2View: NSLayoutConstraint!
    @IBOutlet weak var constantTopSpeedPace: NSLayoutConstraint!
    @IBOutlet weak var constantTopSpeedPaceValue: NSLayoutConstraint!
    @IBOutlet weak var constantTopHeartRate: NSLayoutConstraint!
    @IBOutlet weak var constantTopHeartValue: NSLayoutConstraint!
    @IBOutlet weak var constantTop2Button: NSLayoutConstraint!
    @IBOutlet weak var constantHeightStackViewTotalDurationValue: NSLayoutConstraint!
    
//    @IBOutlet weak var lblNextWorkout: UILabel!

    //MARK: - setupUI
    func setupUI(theController:StartWorkoutCardioVC) {
        self.layoutIfNeeded()
        self.setupFont()
    }
    
    func setupFont() {
        self.lblPause.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblPause.layer.shadowColor = UIColor.appthemeBlackColorAlpha50.cgColor
        self.lblPause.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.lblPause.layer.shadowOpacity = 1
        self.lblPause.layer.shadowRadius = 3
        self.lblPause.text = getCommonString(key: "Pause_key")
        self.lblPause.textColor = UIColor.white
        self.lblPause.layer.masksToBounds = false
        
        self.lblCount.setColor(color: .appthemeBlackColor)
        self.lblCount.font = themeFont(size: 40, fontname: .ProximaNovaBold)
        self.lblWorkout.font = themeFont(size: 16, fontname: .ProximaNovaRegular)
        self.lblTotalTimeAndDistance.font = themeFont(size: 18, fontname: .ProximaNovaRegular)

        self.lblTotalDuration.font = themeFont(size: 35, fontname: .ProximaNovaBold)
        
        self.btnRepeat.setTitle(str: getCommonString(key: "Repeat_key"))
        self.btnRepeat.setColor(color: .black)
        self.vwRepeat.borderColors = UIColor.black
        self.btnRepeat.titleLabel?.font = themeFont(size: 14, fontname: .ProximaNovaRegular)
        self.btnRepeat.isUserInteractionEnabled = false
        
        self.btnNext.titleLabel?.font = themeFont(size: 14, fontname: .ProximaNovaRegular)
        
        self.btnEndWokrout.titleLabel?.font = themeFont(size: 14, fontname: .ProximaNovaRegular)
        self.btnEndWokrout.setTitleColor(.appthemeOffRedColor, for: .normal)
        
        self.vwEndWorkout.setShadowToView()
        
//        let image = UIImage.imageWithColor(color: .appthemeOffRedColor)
//        
//        self.btnEndWokrout.setBackgroundImage(image, for: .highlighted)
//        self.btnEndWokrout.setTitleColor(.white, for: .highlighted)
//        
//        self.btnRepeat.setBackgroundImage(image, for: .highlighted)
//        self.btnRepeat.setTitleColor(.white, for: .highlighted)
//        
//        self.btnNext.setBackgroundImage(image, for: .highlighted)
        self.btnNext.setTitleColor(.appthemeOffRedColor, for: .highlighted)
        self.btnNext.setImage(UIImage(named: "ic_next-1"), for: .highlighted)

        self.btnNext.setImage(UIImage(named: ""), for: .normal)
        
//        var newConstraint = NSLayoutConstraint()
//
//        if DEVICE_TYPE.SCREEN_MAX_LENGTH <= 667{
//            newConstraint = prapotionalWidthTotalDuration.constraintWithMultiplier(0.10)
//        }else if DEVICE_TYPE.IS_IPHONE_6P{
//            newConstraint = prapotionalWidthTotalDuration.constraintWithMultiplier(0.13)
//        }
//        else{
//            newConstraint = prapotionalWidthTotalDuration.constraintWithMultiplier(0.13)
//        }

//        self.removeConstraint(prapotionalWidthTotalDuration)
//        self.addConstraint(newConstraint)
//        self.layoutIfNeeded()
//        prapotionalWidthTotalDuration = newConstraint
//
//        print("constnat:\(prapotionalWidthTotalDuration.constant)")

        countDownTimerSetup()
        
    }
    
    override func layoutSubviews() {
        if UIScreen.main.bounds.size.height != 568 {
            screenwiseConstantTopBottom()
        }
    }
    
    func countDownTimerSetup(){
        self.lblCount.isHidden = false
        self.countdownTimer.isLabelHidden = true
        self.countdownTimer.labelFont = themeFont(size: 100, fontname: .ProximaNovaBold)
        self.countdownTimer.labelTextColor = UIColor.appthemeRedColor
        self.countdownTimer.timerFinishingText = "End"
        self.countdownTimer.lineWidth = 7
    }
    
    func screenwiseConstantTopBottom(){
        
        self.constantTopCompleted.constant = (13/667) * self.safeAreaHeight
        
        self.constantTopSwitchView.constant = (15/667)  * self.safeAreaHeight
        self.constantTopVwNext.constant =  (15.5/667)  *  self.safeAreaHeight
        self.constantTopTotalDistance.constant = (10/667)  *  self.safeAreaHeight
        self.constantTopTotalDistanceValue.constant = (2/667)  *  self.safeAreaHeight
        self.constantTopTotalDuration.constant = (7/667)  *  self.safeAreaHeight
        self.constantTopTotalDurationValue.constant = (2/667)  *  self.safeAreaHeight

        self.constantTopBetween2View.constant = (9/667)  *  self.safeAreaHeight

        self.constantTopSpeedPace.constant = (10/667)  *  self.safeAreaHeight
        self.constantTopSpeedPaceValue.constant = (2/667)  *  self.safeAreaHeight

        self.constantTopHeartRate.constant = (10/667)  *  self.safeAreaHeight
        self.constantTopHeartValue.constant = (2/667)  *  self.safeAreaHeight

        self.constantTop2Button.constant = (2/667)  *  self.safeAreaHeight
        
        self.constantHeightStackViewTotalDurationValue.constant = (41/667)  *  self.safeAreaHeight
    }
    
}


