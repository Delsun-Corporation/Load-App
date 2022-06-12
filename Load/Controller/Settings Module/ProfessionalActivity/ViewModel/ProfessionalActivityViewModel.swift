//
//  ProfessionalActivityViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 03/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class ProfessionalActivityViewModel {

    //MARK:- Variables
    fileprivate weak var theController:ProfessionalActivityVC!
    var filterArray:[FilterActivityModelClass] = [FilterActivityModelClass]()
    var selectedArray:[Int] = [Int]()
    var selectedNameArray:[String] = [String]()
    weak var delegate:FilterActivitySelectedDelegate?
    
    //MARK:- Functions
    init(theController:ProfessionalActivityVC) {
        self.theController = theController
    }
    
    func setupNavigationbar(title:String) {
        self.theController.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        self.theController.navigationItem.hidesBackButton = true
        
        if let vwnav = ViewNavMedium.instanceFromNib() as? ViewNavMedium {
            
            vwnav.imgBackground.isHidden = true
            vwnav.btnback.isHidden = false
            vwnav.btnSave.isHidden = true
            
            vwnav.btnback.setImage(UIImage(named: "ic_close_switch_screen_red"), for: .normal)
            
            var hightOfView = 0
            if UIScreen.main.bounds.height >= 812 {
                hightOfView = 44
            }
            else {
                hightOfView = 20
            }
            
            vwnav.frame = CGRect(x: 0, y: CGFloat(hightOfView), width: self.theController.navigationController?.navigationBar.frame.width ?? 320, height: vwnav.frame.height)
            
            let myMutableString = NSMutableAttributedString()
            
            let dict = [NSAttributedString.Key.font: themeFont(size: 16, fontname: .ProximaNovaBold)]
            myMutableString.append(NSAttributedString(string: title, attributes: dict))
            vwnav.lblTitle.attributedText = myMutableString
            
            vwnav.lblTitle.textColor = .black
            
            vwnav.tag = 1002
            vwnav.delegate = self
            
            self.theController.navigationController?.view.addSubview(vwnav)
            
        }
    }

}

extension ProfessionalActivityViewModel: CustomNavigationWithSaveButtonDelegate{
    
    func CustomNavigationClose() {
        self.theController.btnCloseClicked()
    }
    
    func CustomNavigationSave() {
        self.theController.btnSelectClicked()
    }

}
