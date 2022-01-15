//
//  TimerUnderTensionVc.swift
//  Load
//
//  Created by iMac on 01/08/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import UIKit

class TimerUnderTensionVc: UIViewController {

    //MARK:- Variables

    lazy var mainView: TimeUnderTensionView = { [unowned self] in
        return self.view as! TimeUnderTensionView
    }()
    
    lazy var mainModelView: TimeUnderTensionViewModel = {
        return TimeUnderTensionViewModel(theController: self)
    }()

    //MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mainView.setupUI()
        self.mainModelView.setupUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.mainModelView.setupNavigationbar(title: getCommonString(key: "Time_Under_Tension_key"))
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

extension TimerUnderTensionVc{
    
    @IBAction func btnDetailsTapped(_ sender: UIButton) {
    }
    
    func redirectToInfoScreen(){
        
        self.view.endEditing(true)
        
        let obj = AppStoryboard.Settings.instance.instantiateViewController(withIdentifier: "TimeUnderTensionInfoVC") as! TimeUnderTensionInfoVC
        obj.mainModelView.arrayTimeUnderTensionList = self.mainModelView.arrayTimeUnderTensionList
        let nav = UINavigationController(rootViewController: obj)
        nav.modalPresentationStyle = .overCurrentContext
        self.present(nav, animated: true, completion: nil)

    }
    
}
