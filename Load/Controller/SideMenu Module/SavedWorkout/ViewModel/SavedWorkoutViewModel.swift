//
//  SavedWorkoutViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 10/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import KRPullLoader
import SwiftyJSON

class SavedWorkoutViewModel: KRPullLoadViewDelegate {

    //MARK:- Variables
    fileprivate weak var theController:SavedWorkoutVC!
    var workoutList:SaveWorkoutListModelClass?
    let refreshView = KRPullLoadView()
    let loadView = KRPullLoadView()
    var pageCount:Int = 1
    init(theController:SavedWorkoutVC) {
        self.theController = theController
    }
    
    func setupUI() {
        refreshView.delegate = self
        loadView.delegate = self
        let view = (self.theController.view as? SavedWorkoutView)
        view?.tableView.addPullLoadableView(refreshView, type: .refresh)
        view?.tableView.addPullLoadableView(loadView, type: .loadMore)
        self.apiCallSaveWorkoutList(page: 1)
    }
    
    func pullLoadView(_ pullLoadView: KRPullLoadView, didChangeState state: KRPullLoaderState, viewType type: KRPullLoaderType) {
        if type == .refresh {
            switch state {
            case let .loading(completionHandler):
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                    self.pageCount = 1
                    self.apiCallSaveWorkoutList(page: 1, progress: false)
                    completionHandler()
                }
            default: break
            }
            return
        }
        
        if type == .loadMore {
            switch state {
            case let .loading(completionHandler):
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                    self.apiCallSaveWorkoutList(page: self.pageCount, progress: false)
                    completionHandler()
                }
            default: break
            }
            return
        }
        
        switch state {
        case .none:
            pullLoadView.messageLabel.text = ""
            
        case .pulling(_, _):
            break
            
        case let .loading(completionHandler):
            pullLoadView.messageLabel.text = ""
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                completionHandler()
            }
        }
    }
    
    func apiCallSaveWorkoutList(page: Int, progress:Bool = true) {
        
        let param = [
            "page": page,
            "last_id": 20,
            "relation" : ["training_log"]
            ] as [String : Any]
        print(JSON(param))
        
        ApiManager.shared.MakePostAPI(name: SAVE_WORKOUT_LIST, params: param as [String : Any], progress: progress, vc: self.theController, isAuth: false, completionHandler: { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let success = json.getBool(key: .success)
                if success {
                    let data = json.getDictionary(key: .data)
                    if page == 1 {
                        self.workoutList = SaveWorkoutListModelClass(JSON: data.dictionaryObject!)
                    }
                    else {
                        let model = SaveWorkoutListModelClass(JSON: data.dictionaryObject!)
                        for data in model?.list ?? [] {
                            self.workoutList?.list?.append(data)
                        }
                    }
                    self.pageCount += 1
                    let view = (self.theController.view as? SavedWorkoutView)
                    view?.tableView.reloadData()
                }
                else {
                    //                    let message = json.getString(key: .message)
                    //                    makeToast(strMessage: message)
                }
            }
        })
    }
}
