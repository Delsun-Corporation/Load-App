//
//  SignUpSetupProfileVC-TextField+Extension.swift
//  Load
//
//  Created by Haresh Bhai on 29/05/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

extension SignUpSetupProfileVC {
    //MARK:- TextField Delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        if textField == self.mainView.txtFullName {
            self.mainView.viewFirstName.borderColors = txtAfterUpdate == "" ? UIColor.appThemeDarkGrayColor : UIColor.appthemeRedColor
            self.mainView.txtFullName.textColor = txtAfterUpdate == "" ? UIColor.appThemeDarkGrayColor : UIColor.appthemeRedColor
            self.mainModelView.showNext(txtFullName: txtAfterUpdate)
            return true
        }
        else if textField == self.mainView.txtHeight {
            self.mainModelView.isHeightSelected = txtAfterUpdate.count != 0
            self.mainView.viewHeight.borderColors = txtAfterUpdate == "" ? UIColor.appthemeBlackColorAlpha30 : UIColor.appthemeRedColor
            
            self.mainView.txtHeight.textColor = txtAfterUpdate == "" ? UIColor.appthemeBlackColorAlpha30 : UIColor.appthemeRedColor
            
            self.mainModelView.showNext(txtFullName: self.mainView.txtFullName.text ?? "")
            
            return true
        }
        else if textField == self.mainView.txtWeight {
            self.mainModelView.isWeightSelected = txtAfterUpdate.count != 0
            self.mainView.viewWeight.borderColors = txtAfterUpdate == "" ? UIColor.appthemeBlackColorAlpha30 : UIColor.appthemeRedColor
            self.mainView.txtWeight.textColor = txtAfterUpdate == "" ? UIColor.appthemeBlackColorAlpha30 : UIColor.appthemeRedColor
            self.mainModelView.showNext(txtFullName: self.mainView.txtFullName.text ?? "")
            return true
        }
        return true
    }
}
