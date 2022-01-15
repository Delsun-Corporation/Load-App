//
//  SelectLocationProgramViewModel.swift
//  Load
//
//  Created by Yash on 16/04/21.
//  Copyright © 2021 Haresh Bhai. All rights reserved.
//

import Foundation

protocol delegateSelectLocationProgram {
    func pedometerDistancePace(distance:Double ,Pace:Double)
    func passDataOfParticularLapWithPolyline(strPolyline:String ,lapDistance:Double)
    func netElevationGain(elevationGain:Double)
    func clickOnPauseOrNot(isPause:Bool)
    func indoorParticularLapForReset(distance:Double)
    func passpedometerDate(startDate: Date)
}

class SelectLocationProgramViewModel {
    
//    var handlerForPassPedometerDistancePace : (Double,Double?) -> Void = { _,_ in}
//    var handlerForPassPedometerDate : (Date) -> Void = { _ in}
//    var handlerForPassDataOfParticularLapWithPolyline : (String, Double) -> Void = { _ , _ in}
//    var handlerNetElevationGain : (Double) -> Void = { _ in}
    
    //MARK: - Variable
    fileprivate weak var theController:SelectLocationProgramVc!

    init(theController:SelectLocationProgramVc) {
        self.theController = theController
    }

    var exerciseArray:[WeekWiseWorkoutLapsDetails] = []
    var isSelectIndoor = false
    weak var delegate:StartWorkoutDelegate?
    var delegateForSelectLocationProgram:delegateSelectLocationProgram?
    var isRunAutoPause = false
    var trainingProgramId: String = ""

    var handlerActivitySelectionName:(String) -> Void = {_ in}
    var handlerStopActivityUpdate : () -> Void = {}
    var handlerPauseOrNot : (Bool) -> Void = {_ in}
    var handlerFinishWorkoutOnEndClick : (UIImage?) -> Void = {_ in}
    
    
    //MARK: - setup navigation bar
    
    func setupNavigationbar(title:String) {
        self.theController.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        self.theController.navigationController?.setColor()
        self.theController.navigationItem.hidesBackButton = true
        
        if let vwnav = ViewNav.instanceFromNib() as? ViewNav {

            var hightOfView = 0
            if UIScreen.main.bounds.height >= 812 {
                hightOfView = 20
                vwnav.topClose.constant = 50
            }
            else {
                hightOfView = 0
                vwnav.topClose.constant = 40
            }
            
            vwnav.frame = CGRect(x: 0, y: 0, width: self.theController.navigationController?.navigationBar.frame.width ?? 320, height: vwnav.frame.height + CGFloat(hightOfView))
            
            let myMutableString = NSMutableAttributedString()
            
            let dict = [NSAttributedString.Key.font: themeFont(size: 20, fontname: .ProximaNovaBold)]
            myMutableString.append(NSAttributedString(string: title, attributes: dict))
            vwnav.lblTitle.attributedText = myMutableString
            
            vwnav.tag = 1000
            vwnav.delegate = self
            self.theController.navigationController?.view.addSubview(vwnav)
        }
    }
    

}

extension SelectLocationProgramViewModel: CustomNavigationDelegate {
    
    func CustomNavigationClose() {
//        self.delegateTrainingProgram?.dismissTrainigProgram()
        self.theController.dismiss(animated: true, completion: nil)
    }
}
