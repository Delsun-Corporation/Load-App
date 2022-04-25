//
//  PremiumUserProfileDetailsVc.swift
//  Load
//
//  Created by Yash on 01/07/21.
//  Copyright © 2021 Haresh Bhai. All rights reserved.
//

import UIKit

class PremiumUserProfileDetailsVc: UIViewController {
    
    //MARK:- Variables
    lazy var mainView: PremiumUserProfileDetailsView = { [unowned self] in
        return self.view as! PremiumUserProfileDetailsView
    }()
    
    lazy var mainModelView: PremiumUserProfileDetailsViewModel = {
        return PremiumUserProfileDetailsViewModel(theController: self)
    }()

    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mainView.setupUI()
        self.mainModelView.setupUI()
    }

}

//MARK:- MXScrollview delegate

extension PremiumUserProfileDetailsVc: MXViewControllerViewSource {
    func viewForMixToObserveContentOffsetChange() -> UIView {
        return self.mainView.tblProfile
    }
}
