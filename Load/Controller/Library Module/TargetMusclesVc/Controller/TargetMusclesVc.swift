//
//  TargetMusclesVc.swift
//  Load
//
//  Created by iMac on 21/04/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class TargetMusclesVc: UIViewController {
    
    //MARK: - Variable
    
    lazy var mainView: TargetMusclesView = { [unowned self] in
        return self.view as! TargetMusclesView
    }()
    
    @IBOutlet weak var btnSave: UIButton!
    var selectedTargetValue = ""
    var isCheckController = TARGET_SHOW_OR_EDIT.onlyShow
    var handlerTextReturn:(_ strData:String) -> Void = {_ in}
    
    //MARK; - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainView.setupUI()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.placeholderColor = UIColor.clear
    }
    
    //MARK: - SetupUI
    func setupUI(){
        
        self.navigationController?.setWhiteColor()
        setUpNavigationBarTitle(strTitle: getCommonString(key: "Targeted_Muscles_key"), color:UIColor.black)
        
        if isCheckController == .editable{
            self.mainView.txtTargetMuscles.isUserInteractionEnabled = true
            self.btnSave.isHidden = false
        }else if isCheckController == .onlyShow{
            self.mainView.txtTargetMuscles.isUserInteractionEnabled = false
            self.btnSave.isHidden = true
        }
        
        self.btnSave.setTitle(str: getCommonString(key: "Save_key"))
        self.btnSave.setTitleColor(UIColor.appthemeOffRedColor, for: .normal)
        self.btnSave.titleLabel?.font = themeFont(size: 14, fontname: .ProximaNovaRegular)
        
        self.mainView.txtTargetMuscles.text = selectedTargetValue
        
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnSaveTapped(_ sender: UIButton) {
        self.handlerTextReturn(self.mainView.txtTargetMuscles.text ?? "")
        self.navigationController?.popViewController(animated: true)
    }
    
}
