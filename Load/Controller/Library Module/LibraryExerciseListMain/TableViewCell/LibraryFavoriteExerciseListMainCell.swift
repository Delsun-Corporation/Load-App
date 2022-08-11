//
//  LibraryFavoriteExerciseListMainCell.swift
//  Load
//
//  Created by Haresh Bhai on 25/11/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol LibraryFavoriteDelegate: class {
    func LibraryFavoriteDidFinish(isFavorite:Bool, id:String, userId: Int)
}

class LibraryFavoriteExerciseListMainCell: UITableViewCell {
    
    //MARK:- @IBOutlet
    @IBOutlet weak var lblExercise: UILabel!
    @IBOutlet weak var lblMechanics: UILabel!
    @IBOutlet weak var btnFavorite: UIButton!
    
    //MARK:- Variables
    var libraryId: String = ""
    var isSelectedCell: Bool = false
    var userId = 0
    weak var delegateFavorite:LibraryFavoriteDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setupUI(data: FavoriteList) {
        self.setupFont()
        self.libraryId = (data.id?.stringValue)!
        self.userId = Int(data.userId ?? 0)
        self.lblExercise.text = data.exerciseName
        if newApiConfig {
            self.lblMechanics.text = getMechanicsName(id: data.mechanicsId ?? 0)
        }
        else {
            self.lblMechanics.text = data.mechanicDetail?.name
        }
        self.isSelectedCell = data.isFavorite?.boolValue ?? false
        let image = self.isSelectedCell ? UIImage(named: "ic_star_select") : UIImage(named: "ic_star_unselect")
        self.btnFavorite.setImage(image, for: .normal)
    }
    
    func setupFont() {
        self.lblExercise.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblMechanics.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        
        self.lblExercise.setColor(color: .appthemeBlackTabColor)
        self.lblMechanics.setColor(color: .appthemeBlackTabColor)
    }
    
    //MARK:- @IBAction
    @IBAction func btnFavoriteClicked(_ sender: Any) {
        self.isSelectedCell = !self.isSelectedCell
        let image = self.isSelectedCell ? UIImage(named: "ic_star_select") : UIImage(named: "ic_star_unselect")
        self.btnFavorite.setImage(image, for: .normal)
        self.delegateFavorite?.LibraryFavoriteDidFinish(isFavorite: self.isSelectedCell, id: self.libraryId, userId: self.userId)
    }
}
