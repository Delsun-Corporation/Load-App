//
//  LibraryExerciseListMainVC-TableView+Extension.swift
//  Load
//
//  Created by Haresh Bhai on 12/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import MGSwipeTableCell

extension LibraryExerciseListMainVC: UITableViewDelegate, UITableViewDataSource {
    // Comment favorite cell code so don't need this delegate
    //, LibraryFavoriteDelegate {
    
    //MARK:- TableView
    func numberOfSections(in tableView: UITableView) -> Int {
//        if self.mainModelView.category?.code?.lowercased() != "FAVORITE".lowercased() {
            let array = self.mainModelView.isFilter ? self.mainModelView.filterListArray : self.mainModelView.listArray
            return array?.list?.count ?? 0
//        }
//        else {
//            let array = self.mainModelView.isFilter ? self.mainModelView.filterListFavoriteArray : self.mainModelView.listFavoriteArray
//            return (array?.list?.count ?? 0) > 0 ? 1 : 0
//        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if self.mainModelView.category?.code?.lowercased() != "FAVORITE".lowercased() {
            let array = self.mainModelView.isFilter ? self.mainModelView.filterListArray : self.mainModelView.listArray
            return array?.list![section].data?.count ?? 0 == 0 ? 0 : 70
//        }
//        else {
//            return 0
//        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = LibraryExerciseListMainHeaderView.instanceFromNib() as? LibraryExerciseListMainHeaderView
        let array = self.mainModelView.isFilter ? self.mainModelView.filterListArray : self.mainModelView.listArray
        let model = (array?.list![section])!
        let isMultiple = self.isMultiple(array: array?.list ?? [], name: model.name ?? "")
        view?.setupUI(data: model, isMultiple: isMultiple)
        return view
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if self.mainModelView.category?.code?.lowercased() != "FAVORITE".lowercased() {
            let array = self.mainModelView.isFilter ? self.mainModelView.filterListArray : self.mainModelView.listArray
            return array?.list![section].data?.count ?? 0
//        }
//        else {
//            let array = self.mainModelView.isFilter ? self.mainModelView.filterListFavoriteArray : self.mainModelView.listFavoriteArray
//            print("isFilter:\(self.mainModelView.isFilter)")
//            print("Count:\(array?.list?.count ?? 0)")
//            return array?.list?.count ?? 0
//        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if self.mainModelView.category?.code?.lowercased() != "FAVORITE".lowercased() {
            let cell: LibraryExerciseListMainCell = self.mainView.tableView.dequeueReusableCell(withIdentifier: "LibraryExerciseListMainCell") as! LibraryExerciseListMainCell
            let array = self.mainModelView.isFilter ? self.mainModelView.filterListArray : self.mainModelView.listArray
            let model = (array?.list?[indexPath.section].data?[indexPath.row])
            
            cell.selectionStyle = .none
            cell.tag = indexPath.row
            
            let isSelectedCell = model?.isFavorite?.boolValue ?? false
            let image = isSelectedCell ? UIImage(named: "ic_star_select_long") : UIImage(named: "ic_star_unselect_long")
            let libraryId = "\(model?.id ?? 0)"
            if model?.userId != nil {
                cell.rightButtons = [MGSwipeButton(title: "", icon: UIImage(named:"ic_delete_width"), backgroundColor: UIColor.appthemeOffRedColor, callback: { (MGCell) -> Bool in
                    self.mainModelView.deleteRecords(model: model!, indexPath: indexPath, tableView: tableView)
                    return false
                }), MGSwipeButton(title: "", icon: image, backgroundColor: UIColor.appthemeBlackColorAlpha5, callback: { (MGCell) -> Bool in
                    if self.mainModelView.isFilter {                        self.mainModelView.filterListArray?.list![indexPath.section].data?[indexPath.row].isFavorite = model?.isFavorite == 0 ? 1 : 0
                    }
                    else {
                        self.mainModelView.listArray?.list![indexPath.section].data?[indexPath.row].isFavorite = model?.isFavorite == 0 ? 1 : 0
                    }
                    if self.mainModelView.category?.code?.lowercased() ?? "" != "FAVORITE".lowercased() {
                        tableView.reloadRows(at: [indexPath], with: .none)
                    }
                    guard let userId = getUserDetail()?.data?.user?.id?.intValue else {
                        return false
                    }
                    self.LibraryFavoriteDidFinish(isFavorite: !isSelectedCell, id: libraryId, userId: userId, indexPath: indexPath)
                    return true
                })]
            }
            else {
                cell.rightButtons = [MGSwipeButton(title: "", icon: image, backgroundColor: UIColor.appthemeBlackColorAlpha5, callback: { (MGCell) -> Bool in
                    if self.mainModelView.isFilter {                        self.mainModelView.filterListArray?.list![indexPath.section].data?[indexPath.row].isFavorite = model?.isFavorite == 0 ? 1 : 0
                    }
                    else {
                        self.mainModelView.listArray?.list![indexPath.section].data?[indexPath.row].isFavorite = model?.isFavorite == 0 ? 1 : 0
                    }
                    if self.mainModelView.category?.code?.lowercased() ?? "" != "FAVORITE".lowercased() {
                        tableView.reloadRows(at: [indexPath], with: .none)
                    }
                    self.LibraryFavoriteDidFinish(isFavorite: !isSelectedCell, id: libraryId, userId: 0, indexPath: indexPath)
                    return true
                })]
            }
            
            cell.setupUI(data: model!)
            return cell
//        }
//        else {
//            print(indexPath.row)
//            let cell: LibraryFavoriteExerciseListMainCell = self.mainView.tableView.dequeueReusableCell(withIdentifier: "LibraryFavoriteExerciseListMainCell") as! LibraryFavoriteExerciseListMainCell
//            let array = self.mainModelView.isFilter ? self.mainModelView.filterListFavoriteArray : self.mainModelView.listFavoriteArray
//            let model = array?.list?[indexPath.row]
//            cell.selectionStyle = .none
//            cell.tag = indexPath.row
//
//            cell.setupUI(data: model!)
//            cell.delegateFavorite = self
//            return cell
//        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if self.mainModelView.category?.code?.lowercased() != "FAVORITE".lowercased() {
            let array = self.mainModelView.isFilter ? self.mainModelView.filterListArray : self.mainModelView.listArray
            let model = (array?.list![indexPath.section].data![indexPath.row])!
            if model.userId != nil {
                let obj: LibraryExercisePreviewVC = AppStoryboard.Library.instance.instantiateViewController(withIdentifier: "LibraryExercisePreviewVC") as! LibraryExercisePreviewVC
                obj.mainModelView.libraryId = "\(model.id ?? 0)"
                obj.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(obj, animated: true)
            }
            else {
                let obj: LibraryExercisePreviewVC = AppStoryboard.Library.instance.instantiateViewController(withIdentifier: "LibraryExercisePreviewVC") as! LibraryExercisePreviewVC
                obj.mainView.listComman = model
                obj.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(obj, animated: true)
                
                //                let obj: LibraryExercisePreviewDetailsVC = AppStoryboard.Library.instance.instantiateViewController(withIdentifier: "LibraryExercisePreviewDetailsVC") as! LibraryExercisePreviewDetailsVC
                //                obj.mainModelView.list = model
                //                obj.mainModelView.isLinkHide = true
                //                obj.hidesBottomBarWhenPushed = true
                //                self.navigationController?.pushViewController(obj, animated: true)
            }
//        }
//        else {
//            let array = self.mainModelView.isFilter ? self.mainModelView.filterListFavoriteArray : self.mainModelView.listFavoriteArray
//            let model = (array?.list![indexPath.row])!
//            if model.userId != nil {
//                let obj: LibraryExercisePreviewVC = AppStoryboard.Library.instance.instantiateViewController(withIdentifier: "LibraryExercisePreviewVC") as! LibraryExercisePreviewVC
//                obj.mainModelView.libraryId = (model.id?.stringValue)!
//                obj.hidesBottomBarWhenPushed = true
//                self.navigationController?.pushViewController(obj, animated: true)
//            }
//            else {
//                let obj: LibraryExercisePreviewDetailsVC = AppStoryboard.Library.instance.instantiateViewController(withIdentifier: "LibraryExercisePreviewDetailsVC") as! LibraryExercisePreviewDetailsVC
//                obj.mainModelView.favoritelist = model
////                obj.mainModelView.isLinkHide = true
//                obj.mainModelView.isDefaultExercise = true
//                obj.hidesBottomBarWhenPushed = true
//                self.navigationController?.pushViewController(obj, animated: true)
//            }
//        }
    } 
    
    func LibraryFavoriteDidFinish(isFavorite: Bool, id: String, userId: Int , indexPath: IndexPath) {
        
        self.mainModelView.apiCallFavorite(id: id, isFavorite: isFavorite, userId: userId, status: self.mainModelView.category?.code?.lowercased() ?? "", indexPath: indexPath, tableView: self.mainView.tableView)
    }
    
    func isMultiple(array: [ListLibraryList], name: String) -> Bool {
        let filter = array.filter { (model) -> Bool in
            return model.name == name && model.data?.count != 0
        }
        return filter.count == 1 ? false : true
    }
}
