//
//  LibraryExerciseListMainHeaderView.swift
//  Load
//
//  Created by Haresh Bhai on 12/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class LibraryExerciseListMainHeaderView: UIView {
    
    //MARK:- @IBOutlet
    @IBOutlet weak var lblExercise: UILabel!
    
    //MARK:- Functions
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "LibraryExerciseListMainHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! LibraryExerciseListMainHeaderView
    }
    
    func setFrame() {
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 70)
    }
    
    func setupUI(data:ListLibraryList, isMultiple: Bool) {
        self.setupFont()
        self.setFrame()
        if isMultiple {
            self.lblExercise.text = (data.name ?? "")// + " (" + (data.type ?? "") + ")"
        }
        else {
            self.lblExercise.text = data.name
        }
    }
    
    func setupFont() {
        self.lblExercise.font = themeFont(size: 18, fontname: .ProximaNovaBold)
        self.lblExercise.setColor(color: .appthemeBlackTabColor)
    }
}
