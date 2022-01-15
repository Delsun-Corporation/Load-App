//
//  ChartView.swift
//  Load
//
//  Created by Haresh Bhai on 01/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class ChartView: UIView {

    @IBOutlet weak var chartView: BasicBarChart!
    private var numEntry = 20

    @IBOutlet weak var lblValue1: UILabel!
    @IBOutlet weak var lblValue2: UILabel!
    
    @IBOutlet weak var lblDate: UILabel!    
    @IBOutlet weak var lblRPE: UILabel!
    
    var typeValue: Int = 0
    var dateValue: String = ""

    class func instanceFromNib() -> UIView {
        return UINib(nibName: "ChartView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    func newChart() {
        var dataEntries: [DataEntry] =  []
        
        if typeValue == 0 {
            self.lblDate.text = "Date"
            self.lblRPE.text = "RPE"
            self.lblRPE.isHidden = false
            dataEntries = self.generateRandomDataEntries()
        }
        else if typeValue == 1 {
            self.lblDate.text = dateValue
            self.lblRPE.text = "Date"
            self.lblRPE.isHidden = false
            dataEntries = self.getWeeksNumbers()
        }
        else if typeValue == 2 {
            self.lblDate.text = "Month"
            self.lblRPE.isHidden = true
            dataEntries = getMonthNumbers()
        }
        else if typeValue == 3 {
            self.lblDate.text = "Year"
            self.lblRPE.isHidden = true
            dataEntries = getYearNumbers()
        }
        
        var data:[String] = []
        for v1 in dataEntries {
            data.append(v1.textValue)
        }
        
        self.lblValue1.text = "\((Int(data.max() ?? "0")! / 3) * 2)kg"
        self.lblValue2.text = "\(Int(data.max() ?? "0")! / 3)kg"
        self.chartView.updateDataEntries(dataEntries: dataEntries, animated: true)
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
            result.append(DataEntry(color: colors[i % colors.count], height: height, textValue: "\(value)", title: formatter.string(from: date), SubTitle: formatter.string(from: date)))
        }
        return result
    }
    
    func getWeeksNumbers() -> [DataEntry] {
        let numEntry = numberOfWeeksInMonth(Date())

        let colors = [#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)]
        var result: [DataEntry] = []
        for i in 0..<numEntry {
            let value = (arc4random() % 90) + 10
            let height: Float = Float(value) / 100.0
            result.append(DataEntry(color: colors[i % colors.count], height: height, textValue: "\(value)", title: "Week \(i + 1)", SubTitle: "29-4"))
        }
        return result
    }
    
    func getMonthNumbers() -> [DataEntry] {
        let numEntry = Calendar.current.shortMonthSymbols
        let colors = [#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)]
        var result: [DataEntry] = []
        for i in 0..<numEntry.count {
            let value = (arc4random() % 90) + 10
            let height: Float = Float(value) / 100.0
            result.append(DataEntry(color: colors[i % colors.count], height: height, textValue: "\(value)", title: numEntry[i], SubTitle: ""))
        }
        return result
    }
    
    func getYearNumbers() -> [DataEntry] {
        let numEntry = ["2016", "2017", "2018", "2019", "2020", "2021", "2022"]
        let colors = [#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)]
        var result: [DataEntry] = []
        for i in 0..<numEntry.count {
            let value = (arc4random() % 90) + 10
            let height: Float = Float(value) / 100.0
            result.append(DataEntry(color: colors[i % colors.count], height: height, textValue: "\(value)", title: numEntry[i], SubTitle: ""))
        }
        return result
    }
    
    func numberOfWeeksInMonth(_ date: Date) -> Int {
         var calendar = Calendar(identifier: .gregorian)
         calendar.firstWeekday = 1
         let weekRange = calendar.range(of: .weekOfMonth,
                                        in: .month,
                                        for: date)
         return weekRange!.count
    }
    
}
