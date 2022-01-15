//
//  StartWorkoutResistanceView.swift
//  Load
//
//  Created by Haresh Bhai on 29/11/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import GoogleMaps
import WebKit

class StartWorkoutResistanceView: UIView {

    @IBOutlet weak var btnPlayPause: UIButton!
    @IBOutlet weak var lblWeightWorkout: UILabel!
    @IBOutlet weak var lblDurationtRepsWorkout: UILabel!
    @IBOutlet weak var constantDurationRepearWorkoutCenterX: NSLayoutConstraint!
    
    @IBOutlet weak var sliderArea: UIView!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var vwNextWorkout: CustomView!
    @IBOutlet weak var btnEndWorkout: UIButton!
    @IBOutlet weak var lblExerciseName: UILabel!
    @IBOutlet weak var lblOriginalDuration: UILabel!
    @IBOutlet weak var lblX: UILabel!
    @IBOutlet weak var lblChangeableParameter: UILabel!
    @IBOutlet weak var btnChangeableParameter: UIButton!
    
    
    @IBOutlet weak var lblNext: UILabel!
    @IBOutlet weak var lblNextWorkout: UILabel!
    @IBOutlet weak var countdownTimer: SRCountdownTimer!
//    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var viewText: UIView!
    @IBOutlet weak var scrollHorizontal: UIScrollView!
    @IBOutlet weak var viewVideo: UIView!
    
    @IBOutlet weak var lblOppsNoVideoMsg: UILabel!
    @IBOutlet weak var lblClickHere: UILabel!
    
    @IBOutlet weak var lblLapsCompleted: UILabel!
    @IBOutlet weak var lblChangeableParameterValue: UILabel!
    @IBOutlet weak var lblTotalDuration: UILabel!
//    @IBOutlet weak var lblTotalSpeed: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var webViewVimeo: WKWebView!
    @IBOutlet weak var vwYoutubeVideo: UIView!
    
    //Constrarint
    
    @IBOutlet weak var constantWidthDurationReps: NSLayoutConstraint!
    @IBOutlet weak var constantTopCompleted: NSLayoutConstraint! // 13
    @IBOutlet weak var constantTopSwitchView: NSLayoutConstraint!  // 15
    @IBOutlet weak var constantTopPageControl: NSLayoutConstraint! //24
    @IBOutlet weak var constantTopRestStackView: NSLayoutConstraint! //23
    @IBOutlet weak var constantTopDetailsStackView: NSLayoutConstraint!  // 18
    @IBOutlet weak var constantTopCompleteVolume: NSLayoutConstraint!   //10
    @IBOutlet weak var constantTopTotalDuration: NSLayoutConstraint!   //10
    @IBOutlet weak var constantTopEnd: NSLayoutConstraint!   ///29
    
    @IBOutlet weak var constantTopImage: NSLayoutConstraint!   // 65
    @IBOutlet weak var constantTopOppsMsg: NSLayoutConstraint!   //13
    @IBOutlet weak var constantTopClickHere: NSLayoutConstraint!   //3
    @IBOutlet weak var constantTopAddButton: NSLayoutConstraint!  //10
    
    //MARK: - SetupUI
    
    func setupUI(theController:StartWorkoutResistanceVC) {
        self.layoutIfNeeded()
        self.setupFont()
    }
    
    func setupFont() {
        self.lblCount.setColor(color: .appthemeBlackColor)
        
        lblOppsNoVideoMsg.textColor = UIColor.appthemeBlackColorAlpha50
        lblOppsNoVideoMsg.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        lblOppsNoVideoMsg.text = getCommonString(key: "Opps_no_video_msg_key")
        
        lblClickHere.textColor = UIColor.appthemeBlackColor
        lblClickHere.font = themeFont(size: 13, fontname: .ProximaNovaRegular)
        lblClickHere.text = getCommonString(key: "Click_here_to_add_key")
        
        self.webViewVimeo.scrollView.bounces = false
        self.webViewVimeo.scrollView.alwaysBounceVertical = false
        self.webViewVimeo.scrollView.showsVerticalScrollIndicator = false
        self.webViewVimeo.contentMode = .scaleAspectFit
        self.webViewVimeo.isOpaque = false
        self.webViewVimeo.backgroundColor = UIColor.black
        self.webViewVimeo.scrollView.backgroundColor = UIColor.black
        self.webViewVimeo.configuration.mediaTypesRequiringUserActionForPlayback = .video
        
        self.btnNext.setTitleColor(.appthemeOffRedColor, for: .highlighted)
        self.btnNext.setImage(UIImage(named: "ic_next-1"), for: .highlighted)
        
        self.lblExerciseName.font = themeFont(size: 16, fontname: .ProximaNovaRegular)
        self.lblWeightWorkout.font = themeFont(size: 28, fontname: .ProximaNovaBold)
        self.lblDurationtRepsWorkout.font = themeFont(size: 28, fontname: .ProximaNovaBold)
        self.lblX.font = themeFont(size: 28, fontname: .ProximaNovaBold)
        self.lblCount.font = themeFont(size: 30, fontname: .ProximaNovaBold)
        self.lblOriginalDuration.font = themeFont(size: 16, fontname: .ProximaNovaRegular)
        self.lblChangeableParameter.font = themeFont(size: 14, fontname: .ProximaNovaRegular)
        
        self.lblTotalDuration.font = themeFont(size: 35, fontname: .ProximaNovaBold)
        self.lblChangeableParameterValue.font = themeFont(size: 35, fontname: .ProximaNovaBold)
        
        screenwiseConstantTopBottom()
        
        countDownTimerSetup()
    }
    
    func screenwiseConstantTopBottom(){
        
        self.constantTopCompleted.constant = (13/667) * self.safeAreaHeight
        
        self.constantTopSwitchView.constant = (15/667)  * self.safeAreaHeight
        self.constantTopPageControl.constant =  (24/667)  *  self.safeAreaHeight
        self.constantTopRestStackView.constant = (23/667)  *  self.safeAreaHeight
        
        self.constantTopDetailsStackView.constant = (18/667)  *  self.safeAreaHeight
        self.constantTopCompleteVolume.constant = (10/667)  *  self.safeAreaHeight
        self.constantTopTotalDuration.constant = (10/667)  *  self.safeAreaHeight
        
        self.constantTopEnd.constant = (29/667)  *  self.safeAreaHeight
        
        self.constantTopImage.constant = (65/667)  *  self.safeAreaHeight
        self.constantTopOppsMsg.constant = (13/667)  *  self.safeAreaHeight
        self.constantTopClickHere.constant = (3/667)  *  self.safeAreaHeight
        self.constantTopAddButton.constant = (10/667)  *  self.safeAreaHeight
        
    }

    func countDownTimerSetup(){
        self.lblCount.isHidden = false
        self.countdownTimer.isLabelHidden = true
        self.countdownTimer.labelTextColor = UIColor.appthemeRedColor
        self.countdownTimer.lineWidth = 7
    }

}
