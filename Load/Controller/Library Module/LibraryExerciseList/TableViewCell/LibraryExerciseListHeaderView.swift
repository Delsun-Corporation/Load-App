//
//  LibraryExerciseListHeaderView.swift
//  Load
//
//  Created by Haresh Bhai on 05/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class LibraryExerciseListHeaderView: UIView {

    //MARK:- @IBOutlet
    @IBOutlet weak var lblExercise: UILabel!
    
    //MARK:- Functions
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "LibraryExerciseListHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! LibraryExerciseListHeaderView
    }

    func setFrame() {
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 56)
    }
    
    func setupUI(data:ListLibraryList) {
        self.setupFont()
        self.setFrame()
        self.lblExercise.text = data.name
    }
    
    func setupFont() {
        self.lblExercise.font = themeFont(size: 18, fontname: .ProximaNovaBold)
        self.lblExercise.setColor(color: .appthemeBlackColor)        
        self.lblExercise.text = getCommonString(key: "Exercise_key")
    }
}
