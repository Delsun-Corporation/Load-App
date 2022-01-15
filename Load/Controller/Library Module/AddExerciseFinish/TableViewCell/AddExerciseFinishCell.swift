//
//  AddExerciseFinishCell.swift
//  Load
//
//  Created by Haresh Bhai on 13/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol AddExerciseFinishDelegate:class {
    func AddExerciseFinishDidFinish(tag:Int, data: String)
    func AddExerciseFinish(tag:Int, data: String)
}

class AddExerciseFinishCell: UITableViewCell, UITextFieldDelegate {
    
    // MARK: @IBOutlet
    @IBOutlet weak var lblRM: UILabel!
    @IBOutlet weak var txtKG: UITextField!
    
    // MARK: Variables
    weak var delegate:AddExerciseFinishDelegate?
    
    // MARK: Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        self.txtKG.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupUI(index: IndexPath, repetitionMax: RepetitionMaxModelClass, theController: AddExerciseFinishVC) {
        self.setupFont()
        self.tag = index.row
        self.delegate = theController
        self.lblRM.text = repetitionMax.name
        self.txtKG.text = repetitionMax.estWeight?.stringValue == "0" ? "" : "\(repetitionMax.estWeight?.doubleValue.rounded(toPlaces: 1) ?? 0)".replace(target: ".0", withString: "")
    }
    
    func setupUpdatedUI(index: IndexPath, repetitionMax: RepetitionMax, theController: AddExerciseFinishVC) {
        self.setupFont()
        self.tag = index.row
        self.delegate = theController
        self.lblRM.text = repetitionMax.name
//        self.txtKG.text = repetitionMax.estWeight == "0" ? "" : repetitionMax.estWeight
        self.txtKG.text = repetitionMax.estWeight == "0" ? "" : "\(Double(repetitionMax.estWeight ?? "0")?.rounded(toPlaces: 1) ?? 0)".replace(target: ".0", withString: "")

    }
    
    func setupFont() {
        self.lblRM.font = themeFont(size: 14, fontname: .ProximaNovaRegular)
        self.txtKG.font = themeFont(size: 14, fontname: .ProximaNovaRegular)
        
        self.lblRM.setColor(color: .appthemeBlackColor)
        self.txtKG.setColor(color: .appthemeBlackColor)
    }
    
    // MARK: TextField Delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        
//        if txtAfterUpdate.count > 4 {
//            return false
//        }
        
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        let isNumber = allowedCharacters.isSuperset(of: characterSet)
        if !isNumber {
            return false
        }
   
        self.delegate?.AddExerciseFinishDidFinish(tag: self.tag, data: txtAfterUpdate)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.delegate?.AddExerciseFinish(tag: self.tag, data: textField.text?.toTrim() ?? "0")
    }
}
