//
//  RunningTimeVc.swift
//  Load
//
//  Created by iMac on 30/07/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import UIKit

class RunningTimeVc: UIViewController {

    //MARK: - Variable
    
    lazy var mainView: RunningTimeView = { [unowned self] in
        return self.view as! RunningTimeView
    }()
    
    lazy var mainModelView: RunningTimeViewModel = {
        return RunningTimeViewModel(theController: self)
    }()

    //MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavigationBarTitle(strTitle: getCommonString(key: "Running_Time_key"), color: UIColor.black)
        self.navigationController?.setWhiteColor()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let viewWithTag = self.navigationController!.view.viewWithTag(102) {
            viewWithTag.removeFromSuperview()
        }
    }

    
}

//MARK: - IBAction method

extension RunningTimeVc{
    
    @IBAction func btnSelectDistanceTapped(_ sender: UIButton) {
        self.mainView.txtSelectDistance.becomeFirstResponder()
    }
    
    @IBAction func btnTimeTapped(_ sender: UIButton) {
        
        self.mainView.txtTime.becomeFirstResponder()
    }
    
}
