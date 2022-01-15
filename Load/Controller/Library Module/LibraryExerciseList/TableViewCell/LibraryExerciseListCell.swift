//
//  LibraryExerciseListCell.swift
//  Load
//
//  Created by Haresh Bhai on 05/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol LibraryExerciseSelectionDelegate: class {
    func LibraryExerciseSelectionDidFinish(section:Int, row:Int, isSelected:Bool)
}

class LibraryExerciseListCell: UITableViewCell {

    //MARK:- @IBOutlet
    @IBOutlet weak var lblExercise: UILabel!
    @IBOutlet weak var lblMechanics: UILabel!
    @IBOutlet weak var btnCheck: UIButton!
    
    //MARK:- Variables
    var isSelectedCell: Bool = false
    weak var delegate:LibraryExerciseSelectionDelegate?
    
    //MARK:- Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setupUI(data: LibraryLogList?) {
        self.setupFont()
        self.lblExercise.text = data?.exerciseName ?? ""
        self.lblMechanics.text = data?.mechanicDetail?.name ?? ""
        
        let image = data?.selected ?? false ? UIImage(named: "ic_round_check_box_select") : UIImage(named: "ic_round_check_box_unselect")
        self.btnCheck.setImage(image, for: .normal)
        
    }
    
    func setupUIForFavorite(data: FavoriteList?) {
        self.setupFont()
        self.lblExercise.text = data?.exerciseName ?? ""
        self.lblMechanics.text = data?.mechanicDetail?.name ?? ""
        
        let image = data?.selected ?? false ? UIImage(named: "ic_round_check_box_select") : UIImage(named: "ic_round_check_box_unselect")
        self.btnCheck.setImage(image, for: .normal)
        
    }
    
    func setupFont() {
        self.lblExercise.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblMechanics.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        
        self.lblExercise.setColor(color: .appthemeBlackColor)
        self.lblMechanics.setColor(color: .appthemeBlackColor)
    }
    
    //MARK:- @IBAction
    @IBAction func btnCheckMarkClicked(_ sender: Any) {
        self.isSelectedCell = !self.isSelectedCell
        let image = self.isSelectedCell ? UIImage(named: "ic_round_check_box_select") : UIImage(named: "ic_round_check_box_unselect")
        self.btnCheck.setImage(image, for: .normal)
        self.delegate?.LibraryExerciseSelectionDidFinish(section: self.tag, row: self.lblExercise.tag, isSelected: self.isSelectedCell)
    }
}
