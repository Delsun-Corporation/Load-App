//
//  checkmarkAnimation.swift
//  Load
//
//  Created by iMac on 07/10/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import Foundation

class checkmarkAnimation: UIView {

    var circleLayer: CAShapeLayer!
    var checkMarkLayer: CAShapeLayer!
    
    var timer: Timer?
    var timerCheck: Timer?
    
    var animationDuration = 0.5

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        self.backgroundColor = UIColor.clear
//
//        // Use UIBezierPath as an easy way to create the CGPath for the layer.
//        // The path should be the entire circle.
//        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: (frame.size.width - 10)/2, startAngle: CGFloat(-Double.pi / 2) , endAngle: CGFloat(Double.pi/2*3), clockwise: true)
//
//        // Setup the CAShapeLayer with the path, colors, and line width
//        circleLayer = CAShapeLayer()
//        circleLayer.path = circlePath.cgPath
//        circleLayer.fillColor = UIColor.clear.cgColor
//        circleLayer.strokeColor = UIColor.appthemeOffRedColor.cgColor
//        circleLayer.lineWidth = 1.2;
//
//        // Don't draw the circle initially
//        circleLayer.strokeEnd = 0.0
//
//        // Add the circleLayer to the view's layer's sublayers
//        layer.addSublayer(circleLayer)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func animateCircle() {
        // We want to animate the strokeEnd property of the circleLayer
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: (frame.size.width)/2, startAngle: CGFloat(-Double.pi / 2) , endAngle: CGFloat(Double.pi/2*3), clockwise: true)

        // Setup the CAShapeLayer with the path, colors, and line width
        circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor.appthemeOffRedColor.cgColor
        circleLayer.lineWidth = 1.0;

        // Don't draw the circle initially
        circleLayer.strokeEnd = 0.0

        // Add the circleLayer to the view's layer's sublayers
        layer.addSublayer(circleLayer)

        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        // Set the animation duration appropriately
        animation.duration = self.animationDuration
        
        // Animate from 0 (no circle) to 1 (full circle)
        animation.fromValue = 0
        animation.toValue = 1
        
        // Do a linear animation (i.e. the speed of the animation stays the same)
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        
        // Set the circleLayer's strokeEnd property to 1.0 now so that it's the
        // right value when the animation ends.
        circleLayer.strokeEnd = 1.0
        
        // Do the actual animation
        circleLayer.add(animation, forKey: "animateCircle")
        
        timer?.invalidate()
        timer = nil
        timer = Timer(timeInterval: self.animationDuration, target: self, selector: #selector(self.timerFired), userInfo: nil, repeats: false)

        RunLoop.main.add(timer!, forMode: .common)
        
    }
    
    @objc func timerFired(){
        print("end")
        checkMark()
    }
    
    func checkMark(){
        
        let checkMarkPath = UIBezierPath()
        
//        45--->need 11 X

//        checkMarkPath.move(to: CGPoint(x: 11, y: 22))
//        checkMarkPath.addLine(to: CGPoint(x: 19, y: 30))
//        checkMarkPath.addLine(to: CGPoint(x: 34, y: 15))
//        checkMarkPath.addLine(to: CGPoint(x: 34, y: 15))
//        checkMarkPath.addLine(to: CGPoint(x: 19, y: 30))
        
//        checkMarkPath.move(to: CGPoint(x: 11, y: 22))
//        checkMarkPath.addLine(to: CGPoint(x: 19, y: 30))
//        checkMarkPath.addLine(to: CGPoint(x: 34, y: 15))
//        checkMarkPath.addLine(to: CGPoint(x: 34, y: 15))
//        checkMarkPath.addLine(to: CGPoint(x: 19, y: 30))

//
        checkMarkPath.move(to: CGPoint(x: self.bounds.height / 4.0909 , y: self.bounds.height / 2.0454))
        checkMarkPath.addLine(to: CGPoint(x: self.bounds.height / 2.3684, y: self.bounds.height / 1.5))
        checkMarkPath.addLine(to: CGPoint(x: self.bounds.height / 1.3235, y: self.bounds.height / 3.0000))
        checkMarkPath.addLine(to: CGPoint(x: self.bounds.height / 1.3235, y: self.bounds.height / 3.0000))
        checkMarkPath.addLine(to: CGPoint(x: self.bounds.height / 2.3684, y: self.bounds.height / 1.5))

        checkMarkLayer = CAShapeLayer()
        checkMarkLayer.path = checkMarkPath.cgPath
        checkMarkLayer.fillColor = UIColor.clear.cgColor
        checkMarkLayer.strokeColor = UIColor.appthemeOffRedColor.cgColor
        checkMarkLayer.lineWidth = 1.2
        checkMarkLayer.strokeEnd = 0.0
        layer.addSublayer(checkMarkLayer)
        
//        checkMarkLayer.position = CGPoint(x: self.bounds.height / 1.3461, y: self.bounds.height / 3.1818)

        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        // Set the animation duration appropriately
        animation.duration = self.animationDuration

        // Animate from 0 (no circle) to 1 (full circle)
        animation.fromValue = 0
        animation.toValue = 1
        
        // Do a linear animation (i.e. the speed of the animation stays the same)
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)

        // Set the circleLayer's strokeEnd property to 1.0 now so that it's the
        // right value when the animation ends.
        checkMarkLayer.strokeEnd = 1.0
        
        // Do the actual animation
        checkMarkLayer.add(animation, forKey: "animateCheckmark")
        
        timerCheck?.invalidate()
        timerCheck = nil
        timerCheck = Timer(timeInterval: self.animationDuration, target: self, selector: #selector(self.timerCheckFired), userInfo: nil, repeats: false)

        RunLoop.main.add(timerCheck!, forMode: .common)

    }
    
    @objc func timerCheckFired(){
        print("Checkmark end")
        
        circleLayer.fillColor = UIColor.appthemeOffRedColor.cgColor
        checkMarkLayer.strokeColor = UIColor.white.cgColor
        
        self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        UIView.animate(withDuration: 0.4,
                                   delay:0.0,
                                   usingSpringWithDamping:0.40,
                                   initialSpringVelocity:0.2,
                                   options: .curveEaseOut,
                                   animations: {
                                    self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: {
            //Code to run after animating
            (value: Bool) in
            
        })

    }

    func removeAllAnimation(){
        
        if circleLayer == nil{
            return
        }
        
        if checkMarkLayer == nil{
            return
        }
        
        circleLayer.removeFromSuperlayer()
        circleLayer.removeAllAnimations()
        circleLayer.path = nil
       
        checkMarkLayer.removeFromSuperlayer()
        checkMarkLayer.removeAllAnimations()
        checkMarkLayer.path = nil
        
    }

}
