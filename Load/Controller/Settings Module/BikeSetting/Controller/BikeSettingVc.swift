//
//  BikeSettingVc.swift
//  Load
//
//  Created by iMac on 30/07/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import UIKit

class BikeSettingVc: UIViewController {

    
    //MARK:- Variables
    lazy var mainView: BikeSettingView = { [unowned self] in
        return self.view as! BikeSettingView
    }()

    lazy var mainModelView: BikeSettingViewModel = {
        return BikeSettingViewModel(theController: self)
    }()

    //MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mainView.setupUI(controller: self)
        self.mainModelView.setupUI()
        
        //Witout dot(.)
        self.mainView.txtFrontChainWheel.setAsNumericKeyboard(delegate: self,isUseHyphen:true,withoutAnything: true)
        self.mainView.txtRearFreeWheel.setAsNumericKeyboard(delegate: self,isUseHyphen:true,withoutAnything: true)
        //With dot(.)
        self.mainView.txtBikeWeight.setAsNumericKeyboard(delegate: self,isUseHyphen:false)
        self.mainView.txtBikeDiameter.setAsNumericKeyboard(delegate: self,isUseHyphen:false)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.mainModelView.setupNavigationbar(title: getCommonString(key: "Bike_Setting_key"))
        self.navigationController?.setWhiteColor()
        self.navigationController?.addShadow()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let viewWithTag = self.navigationController!.view.viewWithTag(102) {
            viewWithTag.removeFromSuperview()
        }
    }
    
}

//MARK: - IBAction method

extension BikeSettingVc{
    
    @IBAction func btnBikeWeightTapped(_ sender: UIButton) {
        self.mainView.txtBikeWeight.becomeFirstResponder()
    }
    
    @IBAction func btnBikeWheelDiameter(_ sender: UIButton) {
        self.mainView.txtBikeDiameter.becomeFirstResponder()
    }
    
    @IBAction func btnBikeFrontchainwheelTapped(_ sender: UIButton) {
        self.mainView.txtFrontChainWheel.becomeFirstResponder()
    }
    
    @IBAction func btnRearFreeWheelTapped(_ sender: UIButton) {
        self.mainView.txtRearFreeWheel.becomeFirstResponder()
    }

}

//MARK: - Textield delegate

extension BikeSettingVc: UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {

        if textField == self.mainView.txtBikeWeight{
            self.mainModelView.isBikeWeight = true
        } else if textField == self.mainView.txtBikeDiameter {
            self.mainModelView.isBikeWeight = false
        }
        
        return true
        
    }
    
}

extension BikeSettingVc: NumericKeyboardDelegate {
    
    func numericKeyPressed(key: Int) {
        
        if self.mainModelView.isBikeWeight {
            if self.mainView.txtBikeWeight.text?.contains(".") ?? false{
                let data = self.mainView.txtBikeWeight.text?.split(separator: ".")
                if (data?.count ?? 0) == 2 {
                    if (data?[1].count ?? 0) > 1 {
                        self.mainView.txtBikeWeight.text?.removeLast()
                        return
                    }
                }
            }
        } else if self.mainModelView.isBikeWeight == false{
            if self.mainView.txtBikeDiameter.text?.contains(".") ?? false{
                let data = self.mainView.txtBikeDiameter.text?.split(separator: ".")
                if (data?.count ?? 0) == 2 {
                    if (data?[1].count ?? 0) > 1 {
                        self.mainView.txtBikeDiameter.text?.removeLast()
                        return
                    }
                }
            }
        }

    }
    
    func numericBackspacePressed() {
        print("Backspace pressed!")
    }
    
    func numericSymbolPressed(symbol: String) {
        print("Symbol \(symbol) pressed!")
    }
    
}
