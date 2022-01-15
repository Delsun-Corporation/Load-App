//
//  LibraryExerciseListMainViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 12/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SwiftyJSON

class LibraryExerciseListMainViewModel {

    //MARK:- Variables
    fileprivate weak var theController:LibraryExerciseListMainVC!
    var isFilter:Bool = false
    var searchText:String = ""
    
    var listArray: LibraryListModelClass?
    var filterListArray: LibraryListModelClass?
    var listFavoriteArray: LibraryFavoriteListModelClass?
    var filterListFavoriteArray: LibraryFavoriteListModelClass?
    var category: Category?
    var refreshControl = UIRefreshControl()

    init(theController:LibraryExerciseListMainVC) {
        self.theController = theController
    }
    
    //MARK:- Functions
    func setupUI() {
//        self.apiCallLibraryList(status: (self.bodyParts?.code)!, id: (self.bodyParts?.id?.stringValue)!)
        refreshControl.attributedTitle = NSAttributedString(string: "Loading...")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        let view = (self.theController.view as? LibraryExerciseListMainView)
        view?.tableView.addSubview(refreshControl)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData(notification:)), name: Notification.Name(NOTIFICATION_CENTER_LIST.LIBRARY_LIST_NOTIFICATION.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(searchRecords(notification:)), name: Notification.Name(NOTIFICATION_CENTER_LIST.LIBRARY_LIST_SEARCH_NOTIFICATION.rawValue), object: nil)
    }
    
    @objc func reloadData(notification: Notification) {
        self.isFilter = false
        self.refresh(sender: self)
    }
    
    @objc func searchRecords(notification: Notification) {
        if let text = notification.userInfo?["data"] as? String {
            self.searchText = text
            self.isFilter = text == "" ? false : true
            if  SELECTED_LIBRARY_TAB == (self.category?.id?.stringValue) ?? "" {
                if text == "" {
                    self.apiCallLibraryList(status: (self.category?.code)!, id: (self.category?.id?.stringValue)!, isLoading: false)
                }
                else {
                    self.apiCallSearchLibraryList(searchText: text, status: (self.category?.code)!, id: (self.category?.id?.stringValue)!, isLoading: false)
                }
            }
        }
    }
    
    @objc func refresh(sender:AnyObject) {
        if self.isFilter {
            self.apiCallSearchLibraryList(searchText: searchText, status: (self.category?.code)!, id: (self.category?.id?.stringValue)!, isLoading: false)
        }
        else {
            self.apiCallLibraryList(status: (self.category?.code) ?? "", id: (self.category?.id?.stringValue) ?? "", isLoading: false)
        }
    }
    
    func apiCallLibraryList(status: String, id: String, isLoading:Bool = true) {
        var param = [
            "user_id": getUserDetail().data!.user!.id!.stringValue,
            "status": status,
            "is_group_wise": true,
            "list" : [ "id" , "exercise_name", "category_id", "regions_ids" , "user_id" , "is_favorite", "mechanics_id","repetition_max"],
            "relation": [ "mechanic_detail" ]
            ] as [String : Any]
        
//        if status.lowercased() == "FAVORITE".lowercased() {
//            param.removeValue(forKey: "is_group_wise")
//        }
        
        ApiManager.shared.MakePostAPI(name: LIBRARY_LIST
                                      , params: param as [String : Any], progress: isLoading, vc: self.theController, isAuth:false) { (response, error) in
            self.refreshControl.endRefreshing()
            if response != nil {
                let json = JSON(response!)
                print(json)
                let success = json.getBool(key: .success)
                if success {
                    let data = json.getDictionary(key: .data)
//                    if status.lowercased() != "FAVORITE".lowercased() {
                        var listUpdated: LibraryListModelClass?
                        let model = LibraryListModelClass(JSON: data.dictionaryObject!)
                        let model1 = LibraryListModelClass(JSON: data.dictionaryObject!)
                        self.listArray = model
                        listUpdated = model1
                        listUpdated?.list = []
                        var array:[String] = []
                        for data in self.listArray?.list ?? [] {
                            var listArrayUpdated: [ListLibraryList] = []
                            let filter = self.listArray?.list?.filter({ (modelData) -> Bool in
                                let isContains = array.contains(modelData.name ?? "")
                                return (modelData.name == data.name ?? "") && !isContains
                            })
                            if filter?.count != 0 {
                                array.append(filter?.first?.name ?? "")
                                for (index, dataValue) in (filter ?? []).enumerated() {
                                    if index == 0 {
                                        listArrayUpdated.append(dataValue)
                                    }
                                    else {
                                        for subDataValue in dataValue.data ?? [] {
                                            listArrayUpdated.first?.data?.append(subDataValue)
                                        }
                                    }
                                }
                                
                                var libraryLogList: [LibraryLogList] = []
//                                var arraySubName:[String] = []
                                
//                                for data in listArrayUpdated.first?.data ?? [] {
//                                    if !arraySubName.contains(data.mechanicDetail?.name ?? "") {
//                                        arraySubName.append(data.mechanicDetail?.name ?? "")
//                                    }
//                                }
                                
//                                let arraySubNameSort = arraySubName.sorted(by: { (str1, str2) -> Bool in
//                                    return str1.compare(str2) == ComparisonResult.orderedAscending
//                                })
                                
//                                for data in arraySubNameSort {
//                                    let filter = listArrayUpdated.first?.data?.filter({ (modelData) -> Bool in
//                                        return modelData.mechanicDetail?.name == data
//                                    })
//
                                let modelFilter = data.data?.sorted(by: { (model1, model2) -> Bool in
                                        return model1.exerciseName!.compare(model2.exerciseName ?? "") == ComparisonResult.orderedAscending
                                    })
                                    
                                    modelFilter?.forEach({ (model) in
                                        libraryLogList.append(model)
                                    })
//                                }
                                
                                listArrayUpdated.first?.data = libraryLogList
                                
                                listUpdated?.list?.append((listArrayUpdated.first)!)
                            }
                        }
                        self.listArray = listUpdated
                        self.listArray?.list = listUpdated?.list?.sorted(by: { (model1, model2) -> Bool in
                            return model1.name!.compare(model2.name ?? "") == ComparisonResult.orderedAscending
                        })
 /*
                    }
                    else {
                        
                        /*
                        old implementation
                        */
                        
                        let model = LibraryFavoriteListModelClass(JSON: data.dictionaryObject!)
                        
                        //MARK: - Yash Comments in both API favorite
                        var arraySubName:[String] = []
                        for data in model?.list ?? [] {
//                            if !arraySubName.contains(data.mechanicDetail?.name ?? "") {
                                arraySubName.append(data.mechanicDetail?.name ?? "")
//                            }
                        }
                        
                        let arraySubNameSort = arraySubName.sorted(by: { (str1, str2) -> Bool in
                            return str1.compare(str2) == ComparisonResult.orderedAscending
                        })
                        
                        var libraryLogList: [FavoriteList] = []
                        for data in arraySubNameSort {
//                            let filter = model?.list?.filter({ (modelData) -> Bool in
//                                return modelData.mechanicDetail?.name == data
//                            })
                            
//                            print("filter:\(filter?.toJSON())")
                            
                            let modelFilter = model?.list?.sorted(by: { (model1, model2) -> Bool in
                                return model1.exerciseName!.compare(model2.exerciseName ?? "") == ComparisonResult.orderedAscending
                            })
                            
                            libraryLogList = modelFilter ?? []
                            
//                            modelFilter?.forEach({ (model) in
//                                libraryLogList.append(model)
//                            })
                        }
                        model?.list = libraryLogList
                        self.listFavoriteArray = model
                        
                        
                    }*/
                    let view = (self.theController.view as? LibraryExerciseListMainView)
                    view?.tableView.reloadData()
                }
                else {
//                    let message = json.getString(key: .message)
//                    makeToast(strMessage: message)
                    self.listArray = nil
                    self.listFavoriteArray = nil
                    let view = (self.theController.view as? LibraryExerciseListMainView)
                    view?.tableView.reloadData()
                }
            }
        }
    }
    
    func apiCallSearchLibraryList(searchText: String, status: String, id: String, isLoading:Bool = true) {
        
        var param = [
            "user_id": getUserDetail().data!.user!.id!.stringValue,
            "status": status,
            "search": searchText,
            "is_group_wise": true,
            "search_from": ["exercise_name"],
            "list" : [ "id" , "exercise_name", "category_id", "regions_ids" , "user_id" , "is_favorite", "mechanics_id","repetition_max"],
            "relation": [ "mechanic_detail" ]
            ] as [String : Any]
        
//        if status.lowercased() == "FAVORITE".lowercased() {
//            param.removeValue(forKey: "is_group_wise")
//        }
        
        ApiManager.shared.MakePostAPI(name: LIBRARY_LIST, params: param as [String : Any], progress: isLoading, vc: self.theController, isAuth:false) { (response, error) in
            self.refreshControl.endRefreshing()
            if response != nil {
                let json = JSON(response!)
                print(json)
                let success = json.getBool(key: .success)
                if success {
                    let data = json.getDictionary(key: .data)
//                    if status.lowercased() != "FAVORITE".lowercased() {
//                        let model = LibraryListModelClass(JSON: data.dictionaryObject!)
//                        self.filterListArray = model
                        var listUpdated: LibraryListModelClass?
                        let model = LibraryListModelClass(JSON: data.dictionaryObject!)
                        let model1 = LibraryListModelClass(JSON: data.dictionaryObject!)
                        self.listArray = model
                        listUpdated = model1
                        listUpdated?.list = []
                        var array:[String] = []
                        for data in self.listArray?.list ?? [] {
                            var listArrayUpdated: [ListLibraryList] = []
                            let filter = self.listArray?.list?.filter({ (modelData) -> Bool in
                                let isContains = array.contains(modelData.name ?? "")
                                return (modelData.name == data.name ?? "") && !isContains
                            })
                            if filter?.count != 0 {
                                array.append(filter?.first?.name ?? "")
                                for (index, dataValue) in (filter ?? []).enumerated() {
                                    if index == 0 {
                                        listArrayUpdated.append(dataValue)
                                    }
                                    else {
                                        for subDataValue in dataValue.data ?? [] {
                                            listArrayUpdated.first?.data?.append(subDataValue)
                                        }
                                    }
                                }
                                
                                var libraryLogList: [LibraryLogList] = []
//                                var arraySubName:[String] = []
//
//                                for data in listArrayUpdated.first?.data ?? [] {
//                                    if !arraySubName.contains(data.mechanicDetail?.name ?? "") {
//                                        arraySubName.append(data.mechanicDetail?.name ?? "")
//                                    }
//                                }
//
//                                let arraySubNameSort = arraySubName.sorted(by: { (str1, str2) -> Bool in
//                                    return str1.compare(str2) == ComparisonResult.orderedAscending
//                                })
//
//                                for data in arraySubNameSort {
//                                    let filter = listArrayUpdated.first?.data?.filter({ (modelData) -> Bool in
//                                        return modelData.mechanicDetail?.name == data
//                                    })
                                    
                                    let modelFilter = data.data?.sorted(by: { (model1, model2) -> Bool in
                                        return model1.exerciseName!.compare(model2.exerciseName ?? "") == ComparisonResult.orderedAscending
                                    })
                                    
                                    modelFilter?.forEach({ (model) in
                                        libraryLogList.append(model)
                                    })
//                                }
                                
                                listArrayUpdated.first?.data = libraryLogList
                                
                                listUpdated?.list?.append((listArrayUpdated.first)!)
                            }
                        }
                        self.filterListArray = listUpdated
                        self.filterListArray?.list = listUpdated?.list?.sorted(by: { (model1, model2) -> Bool in
                            return model1.name!.compare(model2.name ?? "") == ComparisonResult.orderedAscending
                        })
                    /*
                    }
                    else {
//                        let model = LibraryFavoriteListModelClass(JSON: data.dictionaryObject!)
//                        self.filterListFavoriteArray = model
                        
                        let model = LibraryFavoriteListModelClass(JSON: data.dictionaryObject!)
                        
                        var arraySubName:[String] = []
                        for data in model?.list ?? [] {
//                            if !arraySubName.contains(data.mechanicDetail?.name ?? "") {
                                arraySubName.append(data.mechanicDetail?.name ?? "")
//                            }
                        }
                        
                        let arraySubNameSort = arraySubName.sorted(by: { (str1, str2) -> Bool in
                            return str1.compare(str2) == ComparisonResult.orderedAscending
                        })
                        
                        var libraryLogList: [FavoriteList] = []
                        for data in arraySubNameSort {
//                            let filter = model?.list?.filter({ (modelData) -> Bool in
//                                return modelData.mechanicDetail?.name == data
//                            })
                            
                            let modelFilter = model?.list?.sorted(by: { (model1, model2) -> Bool in
                                return model1.exerciseName!.compare(model2.exerciseName ?? "") == ComparisonResult.orderedAscending
                            })
                            
                            libraryLogList = modelFilter ?? []
                            
//                            modelFilter?.forEach({ (model) in
//                                libraryLogList.append(model)
//                            })
                        }
                        model?.list = libraryLogList
                        self.filterListFavoriteArray = model
                    }*/
                    let view = (self.theController.view as? LibraryExerciseListMainView)
                    view?.tableView.reloadData()
                }
                else {
                    self.filterListArray = nil
                    self.filterListFavoriteArray = nil
                    let view = (self.theController.view as? LibraryExerciseListMainView)
                    view?.tableView.reloadData()
                }
            }
        }
    }
    
    func apiCallLibraryListDelete(id: String) {
        
        let param = [:] as [String : Any]
        
        ApiManager.shared.MakeDeleteAPI(name: LIBRARY_DELETE + "/" + id, params: param as [String : Any], vc: self.theController, isAuth:false) { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let success = json.getBool(key: .success)
                if success {
                    
                }
                else {
                    let message = json.getString(key: .message)
                    makeToast(strMessage: message)
                }
            }
        }
    }
    
    func apiCallFavorite(id: String, isFavorite:Bool, userId: Int , status: String , indexPath: IndexPath, tableView: UITableView) {
        
        let param = ["is_favorite":isFavorite,
                     "user_id": userId] as [String : Any]
        
        ApiManager.shared.MakePutAPI(name: LIBRARY_SET_FAVORITE + "/" + id, params: param as [String : Any], progress: false, vc: self.theController, isAuth:false) { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let success = json.getBool(key: .success)
                if success {
                    
                    if status.lowercased() == "FAVORITE".lowercased() {
                        self.listArray?.list![indexPath.section].data?.remove(at: indexPath.row)
                        tableView.reloadSections([indexPath.section], with: .none)
                    }
                    
                }
                else {
                    let message = json.getString(key: .message)
                    makeToast(strMessage: message)
                }
            }
        }
    }
    
    func deleteRecords(model: LibraryLogList, indexPath:IndexPath, tableView: UITableView) {
        let alertController = UIAlertController(title: getCommonString(key: "Load_key"), message: getCommonString(key: "Are_you_sure_want_to_delete_key"), preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: getCommonString(key: "Yes_key"), style: UIAlertAction.Style.default) { (result : UIAlertAction) -> Void in
            
            self.apiCallLibraryListDelete(id: "\(model.id ?? 0)")
            self.listArray?.list![indexPath.section].data?.remove(at: indexPath.row)
            tableView.reloadSections([indexPath.section], with: .none)
        }
        
        let cancelAction = UIAlertAction(title: getCommonString(key: "No_key"), style: UIAlertAction.Style.cancel) { (result : UIAlertAction) -> Void in
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.theController.present(alertController, animated: true, completion: nil)
    }
}
