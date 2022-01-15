//
//  ChartView.swift
//  Load
//
//  Created by Haresh Bhai on 01/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol LibraryChartViewDelegate:class {
    func LibraryChartViewFinish(isNext:Bool)
}

class LibraryChartView: UIView {

    //MARK:- @IBOutlet
    @IBOutlet weak var chartView: BasicBarChart!
    @IBOutlet weak var lblX: UILabel!
    @IBOutlet weak var lblY: UILabel!
    @IBOutlet weak var imgArrowLeft: UIImageView!
    
    //MARK:- Variables
    private let numEntry = 7
    var model: [GraphDetailsModelClass]?
    weak var delegate: LibraryChartViewDelegate?
    var selectedDate:Date = Date()
    
    //MARK:- Functions
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "LibraryChartView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    func setupUI(model: [GraphDetailsModelClass]?, selectedDate: Date) {
        imgArrowLeft.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        self.selectedDate = selectedDate
        self.model = model
        self.setupFont()
        self.setFrame()
        self.newChart()
    }
    
    func setFrame() {
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 300)
    }
    
    func setupFont() {
        self.lblX.font = themeFont(size: 14, fontname: .ProximaNovaBold)
        self.lblY.font = themeFont(size: 11, fontname: .ProximaNovaRegular)
        
        self.lblX.setColor(color: .appthemeBlackColor)
        self.lblY.setColor(color: .appThemeDarkGrayColor)
        
//        self.lblX.text = getCommonString(key: "Performance_Graph_key")
//        self.lblY.text = getCommonString(key: "Total_Volume_key")
        //MARK: - Yash Changes
        
        self.lblX.text = getCommonString(key: "Tota_Load_-_Volume_key")
        self.lblY.text = getCommonString(key: "Kg_key")
        
        //MARK: - Both Side arrow is Hidden from Storyboard
        
    }

    func newChart() {
        chartView.isSubViewShow = false
        let dataEntries = self.createDataEntries(model: self.model)
        self.chartView.isShowPopUP = false
        self.chartView.updateDataEntries(dataEntries: dataEntries, animated: true)
    }
    
    func createDataEntries(model: [GraphDetailsModelClass]?) -> [DataEntry] {
        let colors = [#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)]
        var result: [DataEntry] = []
        for i in 0..<self.selectedDate.count() {
            var isInserted: Bool = false
            for data in model ?? [] {
                let value = ((data.totalVolume?.intValue ?? 0) % 90)// + 10
                let height: Float = Float(value) / 100.0
                
                let formatter = DateFormatter()
                formatter.dateFormat = "d"
                let date = data.date?.convertDateFormater()
                //            date.addTimeInterval(TimeInterval(24*60*60*i))
                let strDate = formatter.string(from: date!)
                if strDate == ("\(i + 1)") {
                    isInserted = true
                    result.append(DataEntry(color: colors.first!, height: height, textValue: "\(value)", title: strDate, SubTitle: ""))
                }
            }
            if !isInserted {
                result.append(DataEntry(color: colors.first!, height: 0, textValue: "\(0)", title: "\(i + 1)", SubTitle: ""))
            }
        }
        return result
    }
    
    func generateRandomDataEntries() -> [DataEntry] {
        let colors = [#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)]
        var result: [DataEntry] = []
        for i in 0..<numEntry {
            let value = (arc4random() % 90) + 10
            let height: Float = Float(value) / 100.0
            
            let formatter = DateFormatter()
            formatter.dateFormat = "d"
            var date = Date()
            date.addTimeInterval(TimeInterval(24*60*60*i))
            result.append(DataEntry(color: colors[i % colors.count], height: height, textValue: "\(value)", title: formatter.string(from: date), SubTitle: ""))
        }
        return result
    }
    
    @IBAction func btnPreviousClicked(_ sender: Any) {
        self.delegate?.LibraryChartViewFinish(isNext: false)
    }
    
    @IBAction func btnNextClicked(_ sender: Any) {
        self.delegate?.LibraryChartViewFinish(isNext: true)
    }
    
    
}
