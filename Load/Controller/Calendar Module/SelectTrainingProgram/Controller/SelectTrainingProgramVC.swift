//
//  SelectTrainingProgramVC.swift
//  Load
//
//  Created by Haresh Bhai on 14/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
//Preset and Customize screen

class SelectTrainingProgramVC: UIViewController {

    //MARK:- Variables
    lazy var mainView: SelectTrainingProgramView = { [unowned self] in
        return self.view as! SelectTrainingProgramView
        }()
    
    lazy var mainModelView: SelectTrainingProgramViewModel = {
        return SelectTrainingProgramViewModel(theController: self)
    }()
    
    var isPresetClickable = false
    var isCustomiseClickable = false
    //MARK:- Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainModelView.setupUI()
        self.mainView.setupUI(theController: self)
        self.mainModelView.setupNavigationbar(title: "")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    //MARK:- @IBAction
    @IBAction func btnPresetClicked(_ sender: Any) {
        
        //Old flow
        /*if self.mainModelView.isResistance {
            let obj = AppStoryboard.Calendar.instance.instantiateViewController(withIdentifier: "PresetResistanceTrainingProgramVC") as! PresetResistanceTrainingProgramVC
            let nav = UINavigationController(rootViewController: obj)
            nav.modalPresentationStyle = .overCurrentContext
            self.present(nav, animated: true, completion: nil)
        }
        else {
            let obj = AppStoryboard.Calendar.instance.instantiateViewController(withIdentifier: "PresetTrainingProgramVC") as! PresetTrainingProgramVC
            let nav = UINavigationContr		oller(rootViewController: obj)
            nav.modalPresentationStyle = .overCurrentContext
            self.present(nav, animated: true, completion: nil)
        }*/
        
        //New flow
        
        let obj = AppStoryboard.Calendar.instance.instantiateViewController(withIdentifier: "CreateTrainingProgramVC") as! CreateTrainingProgramVC
        obj.isPresetCickable = true
        obj.mainModelView.delegateTrainingProgram = self
        let nav = UINavigationController(rootViewController: obj)
        nav.modalPresentationStyle = .overCurrentContext
        self.present(nav, animated: true, completion: nil)
        
    }
    
    @IBAction func btnCustomClicked(_ sender: Any) {
        let obj = AppStoryboard.Calendar.instance.instantiateViewController(withIdentifier: "CreateTrainingProgramVC") as! CreateTrainingProgramVC
        obj.isPresetCickable = false
        obj.mainModelView.delegateTrainingProgram = self
        let nav = UINavigationController(rootViewController: obj)
        nav.modalPresentationStyle = .overCurrentContext
        self.present(nav, animated: true, completion: nil)
    }
}

extension SelectTrainingProgramVC{
    
    //Resistance -> Preset
    //Cardio -> Customise
    
    func setupData(data: checkTrainngProgramVisibilityData?){
        
        var title = ""
        
        self.mainView.constraintSubCardioHeight.constant = 13
        self.mainView.lblCardioTitle.text = getCommonString(key: "Customise_key")
        self.mainView.lblSubCardioTitle.text = getCommonString(key: "Customise_your_own_training_program_key")
        
        if data?.isCardio == true || data?.isResistance == true {
            self.isPresetClickable = true
            self.isCustomiseClickable = true
            
            self.mainView.imgCustom.setImageColor(color: .appthemeOffRedColor)
            title = "How would you like to\nplan your program?"
        }

        if data?.isCardioCustomEdit == true || data?.isResistanceCustomEdit == true {
            self.isPresetClickable = false
            self.isCustomiseClickable = true
            
            self.mainView.lblCardioTitle.text = getCommonString(key: "Edit_customize_program_key")
            self.mainView.imgCustom.image = UIImage(named: "ic_edit_customise_program")
            self.mainView.lblSubCardioTitle.text = ""
            self.mainView.constraintSubCardioHeight.constant = 0
            
            title = "Make changes to your\ncurrent program"
        }
        
        if data?.isCardioPresetDelete == true || data?.isResistancePresetDelete == true {
            self.isPresetClickable = true
            self.isCustomiseClickable = false
            
            title = "Make changes to your\ncurrent program"
        }
        	
        self.mainModelView.setupNavigationbar(title: title)
        
        self.mainView.vwPreset.isHidden = false
        self.mainView.vwCustomize.isHidden = false

        
        if self.isPresetClickable == true{
            self.mainView.lblResistanceTitle.textColor = .appthemeOffRedColor
            self.mainView.btnPreset.isUserInteractionEnabled = true
            
            self.mainView.imgPreset.setImageColor(color: .appthemeOffRedColor)
            self.mainView.imgPresetArrow.setImageColor(color: .appthemeOffRedColor)
        }else{
            self.mainView.lblResistanceTitle.textColor = .black
            self.mainView.btnPreset.isUserInteractionEnabled = false
            
            self.mainView.imgPreset.setImageColor(color: .black)
            self.mainView.imgPresetArrow.setImageColor(color: .black)
        }
        
        if self.isCustomiseClickable == true{
            self.mainView.lblCardioTitle.textColor = .appthemeOffRedColor
            self.mainView.btnCustomise.isUserInteractionEnabled = true
            
            self.mainView.imgCustomArrow.setImageColor(color: .appthemeOffRedColor)
            
        }else{
            self.mainView.lblCardioTitle.textColor = .black
            self.mainView.btnCustomise.isUserInteractionEnabled = false

            self.mainView.imgCustom.setImageColor(color: .black)
            self.mainView.imgCustomArrow.setImageColor(color: .black)
        }
    }
}

//MARK: - Dismiss Controller delegate
extension SelectTrainingProgramVC: dismissTrainingProgramDelegate{
    
    func onlyDismissTrainingProgram() {
        self.dismiss(animated: false, completion: nil)
        self.mainModelView.delegateDismiss?.dismissSelectTrainingProgram()
    }
    
    
    func dismissReloadTrainigProgram() {
        self.mainModelView.setupUI()
    }
}
