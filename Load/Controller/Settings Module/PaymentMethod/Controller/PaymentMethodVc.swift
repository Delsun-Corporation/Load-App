//
//  PaymentMethodVc.swift
//  Load
//
//  Created by Yash on 14/04/21.
//  Copyright © 2021 Haresh Bhai. All rights reserved.
//

import UIKit

class PaymentMethodVc: UIViewController {
    
    //MARK:- Variables
    lazy var mainView: PaymentMethodView = { [unowned self] in
        return self.view as! PaymentMethodView
    }()
    
    lazy var mainModelView: PaymentMethodViewModel = {
        return PaymentMethodViewModel(theController: self)
    }()

    //MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
