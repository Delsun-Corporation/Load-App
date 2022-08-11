//
//  LibraryExerciseListMainCell.swift
//  Load
//
//  Created by Haresh Bhai on 12/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class LibraryExerciseListMainCell: MGSwipeTableCell {
    
    //MARK:- @IBOutlet
    @IBOutlet weak var lblExercise: UILabel!
    @IBOutlet weak var lblMechanics: UILabel!
    
    //MARK:- Variables
    var libraryId: String = ""
    var isSelectedCell: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setupUI(data: LibraryLogList) {
        self.setupFont()
        self.libraryId = ("\(data.id ?? 0)")
        self.lblExercise.text = data.exerciseName
        if newApiConfig {
            self.lblMechanics.text = getMechanicsName(id: data.mechanicsId ?? 0)
        }
        else {
            self.lblMechanics.text = data.mechanicDetail?.name
        }
        self.isSelectedCell = data.isFavorite?.boolValue ?? false
    }
    
    func setupFont() {
        self.lblExercise.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblMechanics.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        
        self.lblExercise.setColor(color: .appthemeBlackTabColor)
        self.lblMechanics.setColor(color: .appthemeBlackTabColor)
    }
}

