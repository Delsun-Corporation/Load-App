//
//  TopUpPaymentSuccessPopupVc.swift
//  Load
//
//  Created by Yash on 08/06/21.
//  Copyright © 2021 Haresh Bhai. All rights reserved.
//

import UIKit

class TopUpPaymentSuccessPopupVc: UIViewController {

    //MARK:- Variables
    lazy var mainView: TopUpPaymentSuccessPopupView = { [unowned self] in
        return self.view as! TopUpPaymentSuccessPopupView
        }()
    
    lazy var mainModelView: TopUpPaymentSuccessPopupViewModel = {
        return TopUpPaymentSuccessPopupViewModel(theController: self)
    }()
    
    var handlerClose:() -> Void = {}

    //MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainView.setupUI()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissableViewTapped))
        self.mainView.vwBack.addGestureRecognizer(gestureRecognizer)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }

}

//MARK:- IBAction method

extension TopUpPaymentSuccessPopupVc {
    
    @IBAction func btnDoneTapped(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
        self.handlerClose()

    }
    
    @objc func dismissableViewTapped(){
        self.dismiss(animated: true, completion: nil)
    }

}
