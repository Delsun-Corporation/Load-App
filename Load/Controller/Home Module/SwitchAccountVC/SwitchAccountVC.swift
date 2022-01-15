//
//  SwitchAccountVC.swift
//  Load
//
//  Created by Haresh Bhai on 03/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol SwitchAccountPickedDelegate: class {
    func SwitchAccountPickedClicked(index:Int)
}

class SwitchAccountVC: UIViewController {

    @IBOutlet weak var btnFree: UIButton!
    @IBOutlet weak var btnPremium: UIButton!
    @IBOutlet weak var btnProfessional: UIButton!

    weak var delegate:SwitchAccountPickedDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        self.setupFont()
        let index = SELECTED_ACCOUNT_TYPE == ACCOUNT_TYPE.FREE.rawValue ? 0 : (SELECTED_ACCOUNT_TYPE == ACCOUNT_TYPE.PREMIUM.rawValue ? 1 : 2)
        self.changeLabelColor(index: index)
    }
   
    
    func setupFont() {
        self.btnFree.titleLabel?.font = themeFont(size: 15, fontname: .Helvetica)
        self.btnPremium.titleLabel?.font = themeFont(size: 15, fontname: .Helvetica)
        self.btnProfessional.titleLabel?.font = themeFont(size: 15, fontname: .Helvetica)
        
        self.btnFree.setTitle(str: getCommonString(key: "Free_key"))
        self.btnPremium.setTitle(str: getCommonString(key: "Premium_key"))
        self.btnProfessional.setTitle(str: getCommonString(key: "Professional_key"))
    }
    
    @IBAction func btnFreeClicked(_ sender: Any) {
        self.delegate?.SwitchAccountPickedClicked(index: 0)
        self.changeLabelColor(index: 0)
    }
    
    @IBAction func btnPremiumClicked(_ sender: Any) {
        self.delegate?.SwitchAccountPickedClicked(index: 1)
        self.changeLabelColor(index: 1)
    }
    
    @IBAction func btnProfessionalClicked(_ sender: Any) {
        self.delegate?.SwitchAccountPickedClicked(index: 2)
        self.changeLabelColor(index: 2)
    }
    
    func changeLabelColor(index:Int) {
        if index == 0 {
            self.btnFree.titleLabel?.textColor = UIColor.appthemeRedColor
            self.btnPremium.titleLabel?.textColor = UIColor.darkGray
            self.btnProfessional.titleLabel?.textColor = UIColor.darkGray
        }
        else if index == 1 {
            self.btnFree.titleLabel?.textColor = UIColor.darkGray
            self.btnPremium.titleLabel?.textColor = UIColor.appthemeRedColor
            self.btnProfessional.titleLabel?.textColor = UIColor.darkGray
        }
        else {
            self.btnFree.titleLabel?.textColor = UIColor.darkGray
            self.btnPremium.titleLabel?.textColor = UIColor.darkGray
            self.btnProfessional.titleLabel?.textColor = UIColor.appthemeRedColor
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
