//
//  BasicBarChart.swift
//  BarChart
//
//  Created by Nguyen Vu Nhat Minh on 19/8/17.
//  Copyright © 2017 Nguyen Vu Nhat Minh. All rights reserved.
//

import UIKit

class BasicBarChart: UIView {
    
    var isSubViewShow:Bool = true

    /// contain all layers of the chart
    private let mainLayer: CALayer = CALayer()
    
    /// contain mainLayer to support scrolling
    private let scrollView: UIScrollView = UIScrollView()
    
    /// A flag to indicate whether or not to animate the bar chart when its data entries changed
    private var animated = false
    
    /// Responsible for compute all positions and frames of all elements represent on the bar chart
    private let presenter = BasicBarChartPresenter(barWidth: 12, space: (UIScreen.main.bounds.width - 140) / 7)
    
    private var barEntriesTop: [CGRect] = []
    private var selectedBar: Int = -1
    var isShowPopUP:Bool = true

    /// An array of bar entries. Each BasicBarEntry contain information about line segments, curved line segments, positions and frames of all elements on a bar.
    private var barEntries: [BasicBarEntry] = [] {
        didSet {
            mainLayer.sublayers?.forEach({$0.removeFromSuperlayer()})
            
            scrollView.contentSize = CGSize(width: presenter.computeContentWidth(), height: self.frame.size.height)
            mainLayer.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
            
            showHorizontalLines()
            self.barEntriesTop.removeAll()
            for i in 0..<barEntries.count {
                showEntry(index: i, entry: barEntries[i], animated: animated, oldEntry: (i < oldValue.count ? oldValue[i] : nil))
            }
        }
    }
    
    func updateDataEntries(dataEntries: [DataEntry], animated: Bool) {
        self.animated = animated
        self.presenter.dataEntries = dataEntries
        self.barEntries = self.presenter.computeBarEntries(viewHeight: self.frame.height)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        scrollView.layer.addSublayer(mainLayer)
        self.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateDataEntries(dataEntries: presenter.dataEntries, animated: false)
    }
    
    private func showEntry(index: Int, entry: BasicBarEntry, animated: Bool, oldEntry: BasicBarEntry?) {
        
        let cgColor = entry.data.color.cgColor
        // Show the main bar
        self.barEntriesTop.append(entry.barFrame)
        mainLayer.addRectangleLayer(frame: entry.barFrame, color: cgColor, animated: animated, oldFrame: oldEntry?.barFrame)
        if isShowPopUP {
            self.scrollView.addSubview(self.addActionLayer(frame: entry.barFrame, index: index))
        }
        // Show an Int value above the bar
        mainLayer.addTextLayer(frame: entry.textValueFrame, color: cgColor, fontSize: 11, text: entry.data.textValue, animated: animated, oldFrame: oldEntry?.textValueFrame)

        let colorLightGray = UIColor.appthemeBlackColor.cgColor
        // Show a title below the bar
        mainLayer.addTextLayer(frame: entry.bottomTitleFrame, color: colorLightGray, fontSize: 11, text: entry.data.title, animated: animated, oldFrame: oldEntry?.bottomTitleFrame)
        
        if self.isSubViewShow {
//            let colorBlack = UIColor.black.cgColor
            mainLayer.addTextLayer(frame: entry.bottomSubTitleFrame, color: colorLightGray, fontSize: 11, text: entry.data.SubTitle, animated: animated, oldFrame: oldEntry?.bottomTitleFrame)
        }
    }
        
    func addActionLayer(frame: CGRect, index:Int) -> UIButton {
        let actionButton = UIButton()
        actionButton.setTitle("", for: .normal)
        actionButton.frame = frame
        actionButton.tag = index
        actionButton.addTarget(self, action: #selector(pressed(sender:)), for: .touchUpInside)
        return actionButton
    }
    
    @objc func pressed(sender: UIButton!) {
        print("Taped!!")
        let subViews = self.scrollView.subviews
        for subview in subViews{
            if (subview.tag == 1200) {
                subview.removeFromSuperview()
            }
        }
        if self.selectedBar == sender.tag {
            self.selectedBar = -1
            return
        }
        self.selectedBar = sender.tag
        let top = (self.barEntriesTop[sender.tag].origin.y - 65) > 0 ? (self.barEntriesTop[sender.tag].origin.y - 65) : 0
        let xValue = (self.barEntriesTop[sender.tag].origin.x - 84) > 0 ? (self.barEntriesTop[sender.tag].origin.x - 84) : 0
        
        let view: ChartTotalWorkoutView = ChartTotalWorkoutView.instanceFromNib() as! ChartTotalWorkoutView
        view.setupUI(x: xValue, y: top)
        self.scrollView.addSubview(view)

//        let testFrame : CGRect = CGRect(x: xValue, y: top, width: 180, height: 65) //84 -> 90 - 6
//        let testView : UIView = UIView(frame: testFrame)
//        testView.backgroundColor = UIColor.white
//        testView.tag = 1200
//        testView.layer.borderColor = UIColor.red.cgColor
//        testView.layer.borderWidth = 2
//        self.scrollView.addSubview(testView)
    }
    
    private func showHorizontalLines() {
        self.layer.sublayers?.forEach({
            if $0 is CAShapeLayer {
                $0.removeFromSuperlayer()
            }
        })
        let lines = presenter.computeHorizontalLines(viewHeight: self.frame.height)
        lines.forEach { (line) in
            mainLayer.addLineLayer(lineSegment: line.segment, color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).cgColor, width: line.width, isDashed: line.isDashed, animated: false, oldSegment: nil)
        }
    }    
}
