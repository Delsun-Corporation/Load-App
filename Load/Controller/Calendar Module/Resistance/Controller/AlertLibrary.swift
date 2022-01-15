//
//  AlertLibrary.swift
//  Load
//
//  Created by iMac on 25/02/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import UIKit

class AlertLibrary: UIViewController {

    //MARK: - Outlet
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubMsg: UILabel!
    
    @IBOutlet weak var lblDontShowThisAgain: UILabel!
    @IBOutlet weak var btnCheckMark:UIButton!
    @IBOutlet weak var btnYes:UIButton!
    @IBOutlet weak var btnNo:UIButton!
    
    //MARK: - Variable
    
    var handlerSelectYes:(Bool) -> Void = {_ in}
    var handlerSelectNo:() -> Void = {}
    
    //MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - SetupUI
    
    func setupUI(){
        
        lblTitle.font = themeFont(size: 17, fontname: .Helvetica)
        lblSubMsg.font = themeFont(size: 13, fontname: .Helvetica)
        lblDontShowThisAgain.font = themeFont(size: 13, fontname: .Helvetica)
        
        [lblTitle,lblSubMsg,lblDontShowThisAgain].forEach { (lbl) in
            lbl?.textColor = UIColor.appthemeBlackColor
        }
        
        lblTitle.text = getCommonString(key: "Update_the_weight_in_the_Library_?_key")
        lblSubMsg.text = getCommonString(key: "This_will_update_the_weight_in_the_library_for_this_exercise_key")
        lblDontShowThisAgain.text = getCommonString(key: "Dont_show_this_message_again_key")
        
        [btnYes,btnNo].forEach { (btn) in
            btn?.setTitleColor(UIColor.appthemeRedColor, for: .normal)
            btn?.titleLabel?.font = themeFont(size: 17, fontname: .Regular)
        }
        
        btnYes.setTitle(str: getCommonString(key: "Yes_key"))
        btnNo.setTitle(str: getCommonString(key: "No_key"))
        
    }

}

//MARK: - IBAction method

extension AlertLibrary{
    
    @IBAction func btnCheckMarkTapped(_ sender: Any) {
        
        btnCheckMark.isSelected = !btnCheckMark.isSelected
    }
    
    @IBAction func btnYesTapped(_ sender: Any) {
        
        self.handlerSelectYes(btnCheckMark.isSelected)
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func btnnoTapped(_ sender: Any) {
        
        self.handlerSelectNo()
        self.dismiss(animated: false, completion: nil)
    }
    
}
