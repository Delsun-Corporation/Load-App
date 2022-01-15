//
//  MultiSelectionViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 14/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

struct MultiSelectionDataEntry {
    var id: String
    var title: String
    var isSelected: Bool
}


class MultiSelectionViewModel {

    fileprivate weak var theController:MultiSelectionVC!
    var title: String = "Title"
    var data: [MultiSelectionDataEntry] = [MultiSelectionDataEntry]()
    
    weak var delegate: MultiSelectionDelegate?
    
    init(theController:MultiSelectionVC) {
        self.theController = theController
    }
    
    
    func setupNavigationbar(title:String) {
        self.theController.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        self.theController.navigationItem.hidesBackButton = true
        
        if let vwnav = ViewNavMedium.instanceFromNib() as? ViewNavMedium {
            
            vwnav.imgBackground.isHidden = true
            vwnav.btnback.isHidden = false
            vwnav.btnSave.isHidden = false
            
            vwnav.btnback.setImage(UIImage(named: "ic_close_switch_screen_red"), for: .normal)
            vwnav.btnSave.setTitle(str: getCommonString(key: "Select_key"))
            
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


extension MultiSelectionViewModel: CustomNavigationWithSaveButtonDelegate{
    
    func CustomNavigationClose() {
        self.theController.dismiss(animated: false, completion: nil)
        self.delegate?.dismissPopupScreen()
    }
    
    func CustomNavigationSave() {
        let data: [MultiSelectionDataEntry] = self.data.filter { (model) -> Bool in
            model.isSelected == true
        }
        if data.count == 0 {
            makeToast(strMessage: getCommonString(key: "Please_select_at_least_one_key"))
            return
        }
        self.theController.dismiss(animated: false, completion: nil)
        self.delegate?.MultiSelectionDidFinish(selectedData: data)

    }

}

