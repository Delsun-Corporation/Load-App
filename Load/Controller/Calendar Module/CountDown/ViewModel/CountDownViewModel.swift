//
//  CountDownViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 21/12/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol CountDownViewDelegate: class {
    func CountDownViewFinish(tag:Int)
}

class CountDownViewModel: SRCountdownTimerDelegate {
    
    fileprivate weak var theController:CountDownVC!
    var timer: Timer?
    var timeCount:Int = 3
    var tag:Int = 0
    var trailingGradientColor:UIColor!


    weak var delegate:CountDownViewDelegate?
    var time = 0.5
    
    init(theController:CountDownVC) {
        self.theController = theController
    }
    
    func setupUI() {
        let view = (self.theController.view as? CountDownView)
        view?.lblCount.text = "\(self.timeCount)"
        
        trailingGradientColor = drawGradientColor(in: (view?.countdownTimer.bounds)!, colors: [
            UIColor(red:0.45, green:0.19, blue:0.6, alpha:1).cgColor,
            UIColor(red:0.78, green:0.2, blue:0.2, alpha:0.88).cgColor
        ])!

        self.startCountDownTimer(text: "3")
    }
    
    func startCountDownTimer(text:String) {
        self.timeCount = self.timeCount - 1
        let view = (self.theController.view as? CountDownView)
        view?.countdownTimer.layoutIfNeeded()
        view?.lblCount.isHidden = false
        view?.countdownTimer.isSolidLine = true
        view?.lblCount.text = text
        view?.countdownTimer.isLabelHidden = true
        view?.countdownTimer.labelFont = themeFont(size: 100, fontname: .ProximaNovaBold)
        view?.countdownTimer.labelTextColor = UIColor.appthemeRedColor
        view?.countdownTimer.timerFinishingText = "End"
        view?.countdownTimer.lineWidth = 7
//        view?.countdownTimer.lineColor = UIColor.clear
        view?.countdownTimer.start(beginingValue: 1, interval: 1)
        view?.countdownTimer.delegate = self

        view?.countdownTimer.trailLineColor = trailingGradientColor
        
        if text == "2"{
            view?.countdownTimer.lineDraw = false

//            view?.countdownTimer.isShowGradient = false
        }else{
            view?.countdownTimer.lineDraw = true

//            view?.countdownTimer.lineColor = UIColor.clear
//            view?.countdownTimer.trailLineColor = UIColor.appthemeRedColor
//            view?.countdownTimer.isShowGradient = true
        }
        
    }
    
    func timerDidEnd(sender: SRCountdownTimer, elapsedTime: TimeInterval) {
        print("Done")
        if self.timeCount == 0 {
            
            if let view = (self.theController.view as? CountDownView){
                view.countdownTimer.clearing = true
                view.countdownTimer.setNeedsDisplay()
            }
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.theController.dismiss(animated: false, completion: nil)
                self.delegate?.CountDownViewFinish(tag: self.tag)
            }
        }
        else {
            self.startCountDownTimer(text: "\(self.timeCount)")
        }
    }
    
    func drawGradientColor(in rect: CGRect, colors: [CGColor]) -> UIColor? {
        let currentContext = UIGraphicsGetCurrentContext()
        currentContext?.saveGState()
        defer { currentContext?.restoreGState()
        }

        let size = rect.size
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                        colors: colors as CFArray,
                                        locations: nil) else { return nil }

        let context = UIGraphicsGetCurrentContext()
        context?.clear(rect)
        context?.drawLinearGradient(gradient,
                                    start: CGPoint.zero,
                                    end: CGPoint(x: size.width, y: 0),
                                    options: [])
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let image = gradientImage else { return nil }
        return UIColor(patternImage: image)
    }


}
