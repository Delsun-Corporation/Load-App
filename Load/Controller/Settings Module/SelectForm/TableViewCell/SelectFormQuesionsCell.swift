//
//  SelectFormQuesionsCell.swift
//  Load
//
//  Created by Haresh Bhai on 10/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol SelectFormCellDelegate: class {
    func SelectFormQuesionsFinish(isAgree:Bool)
    func SelectFormAutoSendFinish(isAuto:Bool)
    func SelectFromSetAsCompulsory(isAuto:Bool)
}

class SelectFormQuesionsCell: UITableViewCell {

    //MARK:- @IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblQuestions: UILabel!
    @IBOutlet weak var lblAns1: UILabel!
    @IBOutlet weak var lblAns2: UILabel!
    @IBOutlet weak var lblDescription: UILabel!

    @IBOutlet weak var btnAns1: UIButton!
    @IBOutlet weak var btnAns2: UIButton!

    //MARK:- Variables
    weak var delegate: SelectFormCellDelegate?
    
    //MARK:- Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI() {
        self.btnAns1.isUserInteractionEnabled = false
        self.btnAns2.isUserInteractionEnabled = false

        self.setupFont()
        self.lblTitle.text = "Physical Activity Readiness - Questionnaire"
        self.lblQuestions.text = "Please  read through the questions carefully and answer \"YES\" or \"No\" honestly.\n\nIf you have answered \"No\" to all questions you can be resonably sure that you are at low risk to participate in this exercise programme or event.\n\nIf you answer \"YES\" to any of the questions below, you are required to be evaluated ny your doctor on whether you ca participate in this exercise programme or event.\n\nPlease note that you are responsible for answerring the questions in this questionnaire correctly and without misrepresenting your actual physical condition.\n\n1.  Has your doctor ever said that you have a heart condition and that you shouls only do physical activity recommended by a doctor?\n\n2.   Do you feel pain in  your chest when you do physicalactivity?\n\n3.  In the past month, have you chest pain when you were not doing physical activity?\n\n4.  Do you lose your balance because of dizziness or do you ever lose consciousness?\n\n5.  Do you have a bone or joint problem (for example, back, knee aor hip) that could be made wrose by a change in your physical activity?\n\n6. Is your doctor currently prescribing durgs (for example, water pills) for your blood pressure or heart condition?\n\n7.  Do you know of any other reason why you should not do physical activity?"
        
        self.lblAns1.text = "I have answered \"No\"  to all the above questions."
        self.lblAns2.text = "I have answered \"Yes\" to One or more of the above questions"
        
        let formattedString = NSMutableAttributedString()
        formattedString
            .normal("By clicking on th response buttons above, you have read, understood and completed this quetionnaire to the best of your kowledge. you accept full responsibility for the answers given and agree to indemnify load App (its directors, employees, agents and servants) from any loss, injury (to the extent permitted by law) or claims that may be made against load app as a result of my participation in this exercise programme.\n\n")
            .bold("Please note: ")
            .normal("if your health changes so that you then answer \"Yes\" to any of the above questions, tell your fitness  or health professional . ask whether yould change your physical activity plan.")        
        self.lblDescription.attributedText = formattedString
    }
    
    func setupFont() {
        let image = UIImage(named: "ic_check_box_unselect")?.withRenderingMode(.alwaysTemplate)
        self.btnAns1.setImage(image, for: .normal)
        self.btnAns1.tintColor = UIColor.appthemeRedColor
        
        self.btnAns2.setImage(image, for: .normal)
        self.btnAns2.tintColor = UIColor.appthemeRedColor

        self.lblTitle.font = themeFont(size: 16, fontname: .ProximaNovaBold)
        self.lblQuestions.font = themeFont(size: 14, fontname: .ProximaNovaRegular)
        self.lblAns1.font = themeFont(size: 14, fontname: .ProximaNovaRegular)
        self.lblAns2.font = themeFont(size: 14, fontname: .ProximaNovaRegular)
        self.lblDescription.font = themeFont(size: 14, fontname: .ProximaNovaRegular)

        self.lblTitle.setColor(color: .appthemeBlackColor)
        self.lblQuestions.setColor(color: .appthemeBlackColor)
        self.lblAns1.setColor(color: .appthemeBlackColor)
        self.lblAns2.setColor(color: .appthemeBlackColor)
        self.lblDescription.setColor(color: .appthemeBlackColor)
    }
    
    @IBAction func btnAns1Clicked(_ sender: UIButton) {
        sender.isSelected = true
        self.btnAns2.isSelected = false
        self.delegate?.SelectFormQuesionsFinish(isAgree: false)
    }
    
    @IBAction func btnAns2Clicked(_ sender: UIButton) {
        sender.isSelected = true
        self.btnAns1.isSelected = false
        self.delegate?.SelectFormQuesionsFinish(isAgree: true)
    }
    
    func changeButton(isTrue:Bool) {
        if isTrue {
            self.btnAns1.isSelected = false
            self.btnAns2.isSelected = true
        }
        else {
            self.btnAns1.isSelected = true
            self.btnAns2.isSelected = false
        }
    }
}
