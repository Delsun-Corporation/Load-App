//
//  TargetMusclesView.swift
//  Load
//
//  Created by iMac on 20/01/21.
//  Copyright © 2021 Haresh Bhai. All rights reserved.
//

import UIKit

class TargetMusclesView: UIView {

    @IBOutlet weak var txtTargetMuscles: UITextView!

    func setupUI(){
        
        self.txtTargetMuscles.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
         self.txtTargetMuscles.setColor(color: .appthemeBlackColor)
        self.txtTargetMuscles.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.txtTargetMuscles.textContainer.lineFragmentPadding = 0

    }

}
