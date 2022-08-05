//
//  AutoPauseVc.swift
//  Load
//
//  Created by iMac on 25/08/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import UIKit

class AutoPauseVc: UIViewController {

    //MARK: - Variable
    
    lazy var mainView: AutoPauseView = { [unowned self] in
        return self.view as! AutoPauseView
    }()
    
    lazy var mainModelView: AutoPauseViewModel = {
        return AutoPauseViewModel(theController: self)
    }()
    
    //MARK: - View life cycle
    
    var handerUpdateAutoPause : (Bool,Bool) -> Void = {_,_ in}
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mainView.btnRunAutopause.isSelected = self.mainModelView.isRunAutoPause
        self.mainView.btnCycleAutoPause.isSelected = self.mainModelView.isCycleAutoPause
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpNavigationBarTitle(strTitle: getCommonString(key: "Auto-Pause_key"), color: UIColor.black)
        self.navigationController?.setWhiteColor()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let viewWithTag = self.navigationController!.view.viewWithTag(1002) {
            viewWithTag.removeFromSuperview()
        }
    }
    
    @IBAction func btnBackClicked() {
        backButtonAction()
    }
}

//MARK: - IBAction method

extension AutoPauseVc{
    
    @IBAction func btnRunAutopausedTapped(_ sender: UIButton) {
        self.mainView.btnRunAutopause.isSelected = !self.mainView.btnRunAutopause.isSelected
        handerUpdateAutoPause(self.mainView.btnRunAutopause.isSelected,self.mainView.btnCycleAutoPause.isSelected)
    }
    
    @IBAction func btnCycleAutoPausedTapped(_ sender: UIButton) {
        self.mainView.btnCycleAutoPause.isSelected = !self.mainView.btnCycleAutoPause.isSelected
        handerUpdateAutoPause(self.mainView.btnRunAutopause.isSelected,self.mainView.btnCycleAutoPause.isSelected)
    }
}
