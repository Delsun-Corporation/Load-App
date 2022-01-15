//
//  LibraryExerciseListVC-TableView+Extension.swift
//  Load
//
//  Created by Haresh Bhai on 05/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol AddLibraryExerciseDelegate: class {
    func AddLibraryExerciseDidFinish(listArray: LibraryListModelClass)
    func AddLibraryExerciseFavoriteDidFininsh(favoriteArray:LibraryFavoriteListModelClass)
//        ,favoriteArray: LibraryFavoriteListModelClass)
}

extension LibraryExerciseListVC: UITableViewDelegate, UITableViewDataSource, LibraryExerciseSelectionDelegate {
    
    //MARK:- TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        /*
        let array = self.mainModelView.isFilter ? self.mainModelView.filterListArray : self.mainModelView.listArray
        return array?.list?.count ?? 0
        */
//            if self.mainModelView.bodyParts?.code?.lowercased() != "FAVORITE".lowercased() {
                let array = self.mainModelView.isFilter ? self.mainModelView.filterListArray : self.mainModelView.listArray
                return array?.list?.count ?? 0
            /*}
            else {
                let array = self.mainModelView.isFilter ? self.mainModelView.filterListFavoriteArray : self.mainModelView.listFavoriteArray
                return (array?.list?.count ?? 0) > 0 ? 1 : 0
            }*/

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
//        if self.mainModelView.bodyParts?.code?.lowercased() != "FAVORITE".lowercased() {
            let array = self.mainModelView.isFilter ? self.mainModelView.filterListArray : self.mainModelView.listArray
            return array?.list![section].data?.count ?? 0 == 0 ? 0 : 56
        
        /*}
        else {
            return 0
        }
         */
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = LibraryExerciseListHeaderView.instanceFromNib() as? LibraryExerciseListHeaderView
        let array = self.mainModelView.isFilter ? self.mainModelView.filterListArray : self.mainModelView.listArray
        let model = (array?.list![section])!
        view?.setupUI(data: model)
        return view
        
        /*
        let view = LibraryExerciseListMainHeaderView.instanceFromNib() as? LibraryExerciseListMainHeaderView
        let array = self.mainModelView.isFilter ? self.mainModelView.filterListArray : self.mainModelView.listArray
        let model = (array?.list![section])!
        let isMultiple = self.isMultiple(array: array?.list ?? [], name: model.name ?? "")
        view?.setupUI(data: model, isMultiple: isMultiple)
        return view
         */
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        /*
        let array = self.mainModelView.isFilter ? self.mainModelView.filterListArray : self.mainModelView.listArray
        return array?.list![section].data?.count ?? 0
        */
        
//        if self.mainModelView.bodyParts?.code?.lowercased() != "FAVORITE".lowercased() {
            let array = self.mainModelView.isFilter ? self.mainModelView.filterListArray : self.mainModelView.listArray
            return array?.list![section].data?.count ?? 0
//        }
//        else {
//            let array = self.mainModelView.isFilter ? self.mainModelView.filterListFavoriteArray : self.mainModelView.listFavoriteArray
//            return array?.list?.count ?? 0
//        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LibraryExerciseListCell = self.mainView.tableView.dequeueReusableCell(withIdentifier: "LibraryExerciseListCell") as! LibraryExerciseListCell
        cell.selectionStyle = .none
        cell.tag = indexPath.section
        cell.lblExercise.tag = indexPath.row
        cell.delegate = self
        
//        if self.mainModelView.bodyParts?.code?.lowercased() != "FAVORITE".lowercased() {
            
            print("isFilter:\(self.mainModelView.isFilter)")
            
            let array = self.mainModelView.isFilter ? self.mainModelView.filterListArray : self.mainModelView.listArray
            let model = (array?.list![indexPath.section].data![indexPath.row])!
            cell.setupUI(data: model)
            return cell
       
        /*}else{
            let array = self.mainModelView.isFilter ? self.mainModelView.filterListFavoriteArray : self.mainModelView.listFavoriteArray
            let model = (array?.list?[indexPath.row])!
            cell.setupUIForFavorite(data: model)
            return cell
        }*/
        
    }    
    
    func LibraryExerciseSelectionDidFinish(section:Int, row:Int, isSelected:Bool) {
        
//        if self.mainModelView.bodyParts?.code?.lowercased() != "FAVORITE".lowercased() {
        
            let array = self.mainModelView.isFilter ? self.mainModelView.filterListArray : self.mainModelView.listArray
            let model = (array?.list![section].data![row])!
            model.selected = isSelected
            array?.list![section].data![row] = model
            
//            self.mainModelView.delegate?.AddLibraryExerciseDidFinish(listArray: self.mainModelView.listArray!)
            self.mainModelView.delegate?.AddLibraryExerciseDidFinish(listArray: array!)
        /*
        }else{
            
            let array = self.mainModelView.isFilter ? self.mainModelView.filterListFavoriteArray : self.mainModelView.listFavoriteArray
            let model = (array?.list![row])!
            model.selected = isSelected
            array?.list?[row] = model
            
            self.mainModelView.delegate?.AddLibraryExerciseFavoriteDidFininsh(favoriteArray: array!)
//            self.mainModelView.delegate?.AddLibraryExerciseFavoriteDidFininsh(favoriteArray: self.mainModelView.li)
            
        }
        */
//            ,favoriteArray: self.mainModelView.listFavoriteArray!)

    }
}
