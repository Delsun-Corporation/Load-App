//
//  CalendarCell.swift
//  Load
//
//  Created by Haresh Bhai on 30/05/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class CheckAvailibilityCalendarCell: UITableViewCell {

    var model: CalendarModelClass?
    
    @IBOutlet weak var lblNO1: UILabel!
    @IBOutlet weak var lblNO2: UILabel!
    @IBOutlet weak var lblNO3: UILabel!
    @IBOutlet weak var lblNO4: UILabel!
    @IBOutlet weak var lblNO5: UILabel!
    @IBOutlet weak var lblNO6: UILabel!
    @IBOutlet weak var lblNO7: UILabel!
    
    @IBOutlet weak var btnNo1: UIButton!
    @IBOutlet weak var btnNo2: UIButton!
    @IBOutlet weak var btnNo3: UIButton!
    @IBOutlet weak var btnNo4: UIButton!
    @IBOutlet weak var btnNo5: UIButton!
    @IBOutlet weak var btnNo6: UIButton!
    @IBOutlet weak var btnNo7: UIButton!

    @IBOutlet weak var line1: CustomView!
    @IBOutlet weak var line2: CustomView!
    @IBOutlet weak var line3: CustomView!
    @IBOutlet weak var line4: CustomView!
    @IBOutlet weak var line5: CustomView!
    @IBOutlet weak var line6: CustomView!
    @IBOutlet weak var line7: CustomView!
    
    weak var delegate: CalendarSelectionProtocol?
    var expandedSection:Int = -1
    var expandedRow:Int = -1
    var clientBookedDatesArray: ClientBookedDatesModelClass?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupData(data: CalendarModelClass, section: Int, row:Int) {
        self.expandedSection = section
        self.expandedRow = row
        self.setupFont()
        self.model = data
        
        btnNo1.tag = self.tag * 7
        btnNo2.tag = (self.tag * 7) + 1
        btnNo3.tag = (self.tag * 7) + 2
        btnNo4.tag = (self.tag * 7) + 3
        btnNo5.tag = (self.tag * 7) + 4
        btnNo6.tag = (self.tag * 7) + 5
        btnNo7.tag = (self.tag * 7) + 6
        
        self.showLine(view: self.line1, date: self.model!.date![self.tag * 7])
        self.showLine(view: self.line2, date: self.model!.date![(self.tag * 7) + 1])
        self.showLine(view: self.line3, date: self.model!.date![(self.tag * 7) + 2])
        self.showLine(view: self.line4, date: self.model!.date![(self.tag * 7) + 3])
        self.showLine(view: self.line5, date: self.model!.date![(self.tag * 7) + 4])
        self.showLine(view: self.line6, date: self.model!.date![(self.tag * 7) + 5])
        self.showLine(view: self.line7, date: self.model!.date![(self.tag * 7) + 6])

        self.lblNO1.text = "\(self.model!.no![self.tag * 7])"
        self.lblNO2.text = "\(self.model!.no![(self.tag * 7) + 1])"
        self.lblNO3.text = "\(self.model!.no![(self.tag * 7) + 2])"
        self.lblNO4.text = "\(self.model!.no![(self.tag * 7) + 3])"
        self.lblNO5.text = "\(self.model!.no![(self.tag * 7) + 4])"
        self.lblNO6.text = "\(self.model!.no![(self.tag * 7) + 5])"
        self.lblNO7.text = "\(self.model!.no![(self.tag * 7) + 6])"
        self.makeCircle()
        self.setColor()
        self.makeSelectedCircleRed()
        
        self.makeRounded(label: self.lblNO1)
        self.makeRounded(label: self.lblNO2)
        self.makeRounded(label: self.lblNO3)
        self.makeRounded(label: self.lblNO4)
        self.makeRounded(label: self.lblNO5)
        self.makeRounded(label: self.lblNO6)
        self.makeRounded(label: self.lblNO7)
    }
    
    func showLine(view: CustomView, date: String) {
        let data = self.clientBookedDatesArray?.list?.filter({ (data) -> Bool in
            return (data.selectedDate?.contains(date))!
        })
        if data?.count != 0 {
            view.isHidden = false
        }
        else {
            view.isHidden = true
        }
    }
    
    func makeCircleLabel(label: UILabel) {
        label.layer.borderColor = UIColor.appthemeRedColor.cgColor
        label.layer.borderWidth = 2
        label.layer.cornerRadius = label.bounds.height / 2
    }
    
    func setupFont() {
        self.lblNO1.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblNO2.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblNO3.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblNO4.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblNO5.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblNO6.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblNO7.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        
        self.lblNO1.setColor(color: .appthemeBlackColor)
        self.lblNO2.setColor(color: .appthemeBlackColor)
        self.lblNO3.setColor(color: .appthemeBlackColor)
        self.lblNO4.setColor(color: .appthemeBlackColor)
        self.lblNO5.setColor(color: .appthemeBlackColor)
        self.lblNO6.setColor(color: .appthemeBlackColor)
        self.lblNO7.setColor(color: .appthemeBlackColor)
    }
    
    func makeRounded(label: UILabel) {
        label.layer.cornerRadius = label.bounds.width / 2
        label.clipsToBounds = true
    }
    
    func makeSelectedCircleRed() {
        if self.tag == self.expandedSection {
            if expandedRow == 0 {
                self.makeCircleColor(label: self.lblNO1)
            }
            else if expandedRow == 1 {
                self.makeCircleColor(label: self.lblNO2)
            }
            else if expandedRow == 2 {
                self.makeCircleColor(label: self.lblNO3)
            }
            else if expandedRow == 3 {
                self.makeCircleColor(label: self.lblNO4)
            }
            else if expandedRow == 4 {
                self.makeCircleColor(label: self.lblNO5)
            }
            else if expandedRow == 5 {
                self.makeCircleColor(label: self.lblNO6)
            }
            else if expandedRow == 6 {
                self.makeCircleColor(label: self.lblNO7)
            }
        }
    }
    
    func makeCircle() {
        let date = Date().toString(dateFormat: "yyyy-MM-dd")
        self.lblNO1.backgroundColor = .clear
        self.lblNO2.backgroundColor = .clear
        self.lblNO3.backgroundColor = .clear
        self.lblNO4.backgroundColor = .clear
        self.lblNO5.backgroundColor = .clear
        self.lblNO6.backgroundColor = .clear
        self.lblNO7.backgroundColor = .clear
       
        self.lblNO1.layer.borderWidth = 0
        self.lblNO2.layer.borderWidth = 0
        self.lblNO3.layer.borderWidth = 0
        self.lblNO4.layer.borderWidth = 0
        self.lblNO5.layer.borderWidth = 0
        self.lblNO6.layer.borderWidth = 0
        self.lblNO7.layer.borderWidth = 0

        if date == "\(self.model!.date![self.tag * 7])" {
            self.makeCircleLabel(label: self.lblNO1)
        }
        
        if date == "\(self.model!.date![(self.tag * 7) + 1])" {
            self.makeCircleLabel(label: self.lblNO2)
        }
        
        if date == "\(self.model!.date![(self.tag * 7) + 2])" {
            self.makeCircleLabel(label: self.lblNO3)
        }
        
        if date == "\(self.model!.date![(self.tag * 7) + 3])" {
            self.makeCircleLabel(label: self.lblNO4)
        }
        
        if date == "\(self.model!.date![(self.tag * 7) + 4])" {
            self.makeCircleLabel(label: self.lblNO5)
        }
        
        if date == "\(self.model!.date![(self.tag * 7) + 5])" {
            self.makeCircleLabel(label: self.lblNO6)
        }
        
        if date == "\(self.model!.date![(self.tag * 7) + 6])" {
            self.makeCircleLabel(label: self.lblNO7)
        }
    }
    
    func setColor() {
        self.makeTextBlack()
        self.btnNo1.isUserInteractionEnabled = true
        self.btnNo2.isUserInteractionEnabled = true
        self.btnNo3.isUserInteractionEnabled = true
        self.btnNo4.isUserInteractionEnabled = true
        self.btnNo5.isUserInteractionEnabled = true
        self.btnNo6.isUserInteractionEnabled = true
        self.btnNo7.isUserInteractionEnabled = true

        if self.tag == 0 || self.tag == 4 || self.tag == 5 {
            if self.tag == 0 {
                if Int(self.lblNO1.text!)! >= 15 {
                    self.lblNO1.textColor = .gray
                    self.lblNO1.layer.borderColor = UIColor.clear.cgColor
                    self.btnNo1.isUserInteractionEnabled = false
                    self.line1.isHidden = true
                }
                
                if Int(self.lblNO2.text!)! >= 15 {
                    self.lblNO2.textColor = .gray
                    self.lblNO2.layer.borderColor = UIColor.clear.cgColor
                    self.btnNo2.isUserInteractionEnabled = false
                    self.line2.isHidden = true
                }
                
                if Int(self.lblNO3.text!)! >= 15 {
                    self.lblNO3.textColor = .gray
                    self.lblNO3.layer.borderColor = UIColor.clear.cgColor
                    self.btnNo3.isUserInteractionEnabled = false
                    self.line3.isHidden = true
                }
                
                if Int(self.lblNO4.text!)! >= 15 {
                    self.lblNO4.textColor = .gray
                    self.lblNO4.layer.borderColor = UIColor.clear.cgColor
                    self.btnNo4.isUserInteractionEnabled = false
                    self.line4.isHidden = true
                }
                
                if Int(self.lblNO5.text!)! >= 15 {
                    self.lblNO5.textColor = .gray
                    self.lblNO5.layer.borderColor = UIColor.clear.cgColor
                    self.btnNo5.isUserInteractionEnabled = false
                    self.line5.isHidden = true
                }
                
                if Int(self.lblNO6.text!)! >= 15 {
                    self.lblNO6.textColor = .gray
                    self.lblNO6.layer.borderColor = UIColor.clear.cgColor
                    self.btnNo6.isUserInteractionEnabled = false
                    self.line6.isHidden = true
                }
                
                if Int(self.lblNO7.text!)! >= 15 {
                    self.lblNO7.textColor = .gray
                    self.lblNO7.layer.borderColor = UIColor.clear.cgColor
                    self.btnNo7.isUserInteractionEnabled = false
                    self.line7.isHidden = true
                }
            }
            else {
                if Int(self.lblNO1.text!)! <= 15 {
                    self.lblNO1.textColor = .gray
                    self.lblNO1.layer.borderColor = UIColor.clear.cgColor
                    self.btnNo1.isUserInteractionEnabled = false
                    self.line1.isHidden = true
                }
                
                if Int(self.lblNO2.text!)! <= 15 {
                    self.lblNO2.textColor = .gray
                    self.lblNO2.layer.borderColor = UIColor.clear.cgColor
                    self.btnNo2.isUserInteractionEnabled = false
                    self.line2.isHidden = true
                }
                
                if Int(self.lblNO3.text!)! <= 15 {
                    self.lblNO3.textColor = .gray
                    self.lblNO3.layer.borderColor = UIColor.clear.cgColor
                    self.btnNo3.isUserInteractionEnabled = false
                    self.line3.isHidden = true
                }
                
                if Int(self.lblNO4.text!)! <= 15 {
                    self.lblNO4.textColor = .gray
                    self.lblNO4.layer.borderColor = UIColor.clear.cgColor
                    self.btnNo4.isUserInteractionEnabled = false
                    self.line4.isHidden = true
                }
                
                if Int(self.lblNO5.text!)! <= 15 {
                    self.lblNO5.textColor = .gray
                    self.lblNO5.layer.borderColor = UIColor.clear.cgColor
                    self.btnNo5.isUserInteractionEnabled = false
                    self.line5.isHidden = true
                }
                
                if Int(self.lblNO6.text!)! <= 15 {
                    self.lblNO6.textColor = .gray
                    self.lblNO6.layer.borderColor = UIColor.clear.cgColor
                    self.btnNo6.isUserInteractionEnabled = false
                    self.line6.isHidden = true
                }
                
                if Int(self.lblNO7.text!)! <= 15 {
                    self.lblNO7.textColor = .gray
                    self.lblNO7.layer.borderColor = UIColor.clear.cgColor
                    self.btnNo7.isUserInteractionEnabled = false
                    self.line7.isHidden = true
                }
            }
        }
    }
    
    func makeCircleColor(label: UILabel) {
        label.backgroundColor = UIColor.appthemeRedColor
        label.textColor = .white
    }    
    
    func makeTextBlack() {
        self.lblNO1.textColor = .black
        self.lblNO2.textColor = .black
        self.lblNO3.textColor = .black
        self.lblNO4.textColor = .black
        self.lblNO5.textColor = .black
        self.lblNO6.textColor = .black
        self.lblNO7.textColor = .black
    }
    
    @IBAction func btnNo1Clicked(_ sender: UIButton) {
        self.delegate?.CalendarSelection(section: self.tag, row: 0, index: sender.tag, date: self.model!.date![sender.tag], no: self.model!.no![sender.tag])
    }
    
    @IBAction func btnNo2Clicked(_ sender: UIButton) {
        self.delegate?.CalendarSelection(section: self.tag, row: 1, index: sender.tag, date: self.model!.date![sender.tag], no: self.model!.no![sender.tag])
    }
    
    @IBAction func btnNo3Clicked(_ sender: UIButton) {
        self.delegate?.CalendarSelection(section: self.tag, row: 2, index: sender.tag, date: self.model!.date![sender.tag], no: self.model!.no![sender.tag])
    }
    
    @IBAction func btnNo4Clicked(_ sender: UIButton) {
        self.delegate?.CalendarSelection(section: self.tag, row: 3, index: sender.tag, date: self.model!.date![sender.tag], no: self.model!.no![sender.tag])
    }
    
    @IBAction func btnNo5Clicked(_ sender: UIButton) {
        self.delegate?.CalendarSelection(section: self.tag, row: 4, index: sender.tag, date: self.model!.date![sender.tag], no: self.model!.no![sender.tag])
    }
    
    @IBAction func btnNo6Clicked(_ sender: UIButton) {
        self.delegate?.CalendarSelection(section: self.tag, row: 5, index: sender.tag, date: self.model!.date![sender.tag], no: self.model!.no![sender.tag])
    }
    
    @IBAction func btnNo7Clicked(_ sender: UIButton) {
        self.delegate?.CalendarSelection(section: self.tag, row: 6, index: sender.tag, date: self.model!.date![sender.tag], no: self.model!.no![sender.tag])
    }
}
