/*
 MIT License

 Copyright (c) 2017 Ruslan Serebriakov <rsrbk1@gmail.com>

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import UIKit

@objc public protocol SRCountdownTimerDelegate: class {
    @objc optional func timerDidUpdateCounterValue(sender: SRCountdownTimer, newValue: Int)
    @objc optional func timerDidStart(sender: SRCountdownTimer)
    @objc optional func timerDidPause(sender: SRCountdownTimer)
    @objc optional func timerDidResume(sender: SRCountdownTimer)
    @objc optional func timerDidEnd(sender: SRCountdownTimer, elapsedTime: TimeInterval)
}

public class SRCountdownTimer: UIView {
    @IBInspectable public var lineDraw: Bool = false
    @IBInspectable public var clearing = false
    @IBInspectable public var isSolidLine = false

    
    @IBInspectable public var lineWidth: CGFloat = 20.0
    @IBInspectable public var lineColor: UIColor = .black
    @IBInspectable public var trailLineColor: UIColor = UIColor.black
//        .withAlphaComponent(0.5)
    
    @IBInspectable public var isLabelHidden: Bool = false
    @IBInspectable public var labelFont: UIFont?
    @IBInspectable public var labelTextColor: UIColor?
    @IBInspectable public var timerFinishingText: String?

    public weak var delegate: SRCountdownTimerDelegate?
    
    // use minutes and seconds for presentation
    public var useMinutesAndSecondsRepresentation = false
    public var moveClockWise = true

    private var timer: Timer?
    private var beginingValue: Int = 1
    private var totalTime: TimeInterval = 1
    var elapsedTime: TimeInterval = 1
    private var interval: TimeInterval = 1 // Interval which is set by a user
    private let fireInterval: TimeInterval = 0.01 // ~60 FPS
    var isShowGradient: Bool = false
    
    private lazy var counterLabel: UILabel = {
        let label = UILabel()
        self.addSubview(label)

        label.textAlignment = .center
        label.frame = self.bounds
        if let font = self.labelFont {
            label.font = font
        }
        if let color = self.labelTextColor {
            label.textColor = color
        }

        return label
    }()
    private var currentCounterValue: Int = 0 {
        didSet {
            if !isLabelHidden {
                if let text = timerFinishingText, currentCounterValue == 0 {
                    counterLabel.text = text
                } else {
                    if useMinutesAndSecondsRepresentation {
                        counterLabel.text = getMinutesAndSeconds(remainingSeconds: currentCounterValue)
                    } else {
                        counterLabel.text = "\(currentCounterValue)"
                    }
                }
            }

            delegate?.timerDidUpdateCounterValue?(sender: self, newValue: currentCounterValue)
        }
    }

    // MARK: Inits
    override public init(frame: CGRect) {
        if frame.width != frame.height {
            fatalError("Please use a rectangle frame for SRCountdownTimer")
        }

        super.init(frame: frame)

        layer.cornerRadius = frame.width / 2
        clipsToBounds = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let context = UIGraphicsGetCurrentContext()
        
        if !isSolidLine{
            context?.setLineDash(phase: 0, lengths: [])
            self.isSolidLine = false
        }else{
            context?.clear(bounds)
            context?.setLineDash(phase: 1, lengths: [1])
        }
        
        let radius = (rect.width - lineWidth) / 2
        var currentAngle : CGFloat!
        
        if moveClockWise {
            currentAngle = CGFloat((.pi * 2 * elapsedTime) / totalTime)
        } else {
            currentAngle = CGFloat(-(.pi * 2 * elapsedTime) / totalTime)
        }
        
        //set clearing for remove black shape while finish rest
        
        guard !clearing else {
            context?.clear(bounds)
            //            context?.setFillColor(backgroundColor?.cgColor ?? UIColor.clear.cgColor)
            context?.setFillColor(UIColor.clear.cgColor)
            context?.fill(bounds)
            clearing = false
            return
        }
        
        context?.setLineWidth(lineWidth)
        if self.lineDraw
        {
            // Trail line
            context?.beginPath()
            
            context?.addArc(
                center: CGPoint(x: rect.midX, y:rect.midY),
                radius: radius,
                startAngle: -.pi / 2,
                endAngle: (currentAngle - .pi / 2),
                clockwise: self.lineDraw)
            
            context?.setStrokeColor(trailLineColor.cgColor)
            context?.strokePath()
        }
        else
        {
            // Trail line
            context?.beginPath()
            
            context?.addArc(
                center: CGPoint(x: rect.midX, y:rect.midY),
                radius: radius,
                startAngle: -.pi / 2,
                endAngle: (currentAngle - .pi / 2),
                clockwise: self.lineDraw)
            
            context?.setStrokeColor(trailLineColor.cgColor)
            context?.strokePath()
        }
    }
    
    
    func drawGradientColor(in rect: CGRect, colors: [CGColor]) -> UIColor? {
        let currentContext = UIGraphicsGetCurrentContext()
        currentContext?.saveGState()
        defer { currentContext?.restoreGState() }

        let size = rect.size
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                        colors: colors as CFArray,
                                        locations: nil) else { return nil }

        let context = UIGraphicsGetCurrentContext()
        context?.drawLinearGradient(gradient,
                                    start: CGPoint.zero,
                                    end: CGPoint(x: size.width, y: 0),
                                    options: [])
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let image = gradientImage else { return nil }
        return UIColor(patternImage: image)
    }
    // MARK: Public methods
    /**
     * Starts the timer and the animation. If timer was previously runned, it'll invalidate it.
     * - Parameters:
     *   - beginingValue: Value to start countdown from.
     *   - interval: Interval between reducing the counter(1 second by default)
     */
    public func start(beginingValue: Int, interval: TimeInterval = 1) {
        self.beginingValue = beginingValue
        self.interval = interval

        totalTime = TimeInterval(beginingValue) * interval
        elapsedTime = 0
        currentCounterValue = beginingValue

        timer?.invalidate()
        timer = Timer(timeInterval: fireInterval, target: self, selector: #selector(SRCountdownTimer.timerFired(_:)), userInfo: nil, repeats: true)

        RunLoop.main.add(timer!, forMode: .common)

        delegate?.timerDidStart?(sender: self)
    }
    
    func resumeTimer(elapsedTime : TimeInterval,beginingValue: Int, interval: TimeInterval = 1) {
        self.beginingValue = beginingValue
        self.interval = interval

        totalTime = TimeInterval(beginingValue) * interval
        self.elapsedTime = elapsedTime
        currentCounterValue = beginingValue

        timer?.invalidate()
        timer = Timer(timeInterval: fireInterval, target: self, selector: #selector(SRCountdownTimer.timerFired(_:)), userInfo: nil, repeats: true)

        RunLoop.main.add(timer!, forMode: .common)

        delegate?.timerDidStart?(sender: self)
    }

    /**
     * Pauses the timer with saving the current state
     */
    public func pause() {
        timer?.fireDate = Date.distantFuture
        delegate?.timerDidPause?(sender: self)
    }

    /**
     * Resumes the timer from the current state
     */
    public func resume() {
        timer?.fireDate = Date()
        delegate?.timerDidResume?(sender: self)
    }

    /**
     * Reset the timer
     */
    public func reset() {
        self.currentCounterValue = 0
        timer?.invalidate()
        self.elapsedTime = 0
        setNeedsDisplay()
    }
    
    /**
     * End the timer
     */
    public func end(isShow:Bool = true) {
        self.currentCounterValue = 0
        timer?.invalidate()
        if isShow {
            delegate?.timerDidEnd?(sender: self, elapsedTime: elapsedTime)
        }
    }
    
    /**
     * Calculate value in minutes and seconds and return it as String
     */
    private func getMinutesAndSeconds(remainingSeconds: Int) -> (String) {
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds - minutes * 60
        let secondString = seconds < 10 ? "0" + seconds.description : seconds.description
        return minutes.description + ":" + secondString
    }

    // MARK: Private methods
    @objc private func timerFired(_ timer: Timer) {
        elapsedTime += fireInterval

        if elapsedTime <= totalTime {
            setNeedsDisplay()

            let computedCounterValue = beginingValue - Int(elapsedTime / interval)
            if computedCounterValue != currentCounterValue {
                currentCounterValue = computedCounterValue
            }
        } else {
            end()
        }
    }
}



class GradientLabel: UILabel {
    var gradientColors: [CGColor] = []

    override func drawText(in rect: CGRect) {
        if let gradientColor = drawGradientColor(in: rect, colors: gradientColors) {
            self.textColor = gradientColor
        }
        super.drawText(in: rect)
    }

    private func drawGradientColor(in rect: CGRect, colors: [CGColor]) -> UIColor? {
        let currentContext = UIGraphicsGetCurrentContext()
        currentContext?.saveGState()
        defer { currentContext?.restoreGState() }

        let size = rect.size
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                        colors: colors as CFArray,
                                        locations: nil) else { return nil }

        let context = UIGraphicsGetCurrentContext()
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
