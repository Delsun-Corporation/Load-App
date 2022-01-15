//
//  BookmarkLoadCenterViewModel.swift
//  Load
//
//  Created by iMac on 18/03/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import AlamofireSwiftyJSON
import Alamofire

class BookmarkLoadCenterViewModel {

    //MARK:- Variables
    fileprivate weak var theController:BookmarkLoadCenterVc!

    init(theController:BookmarkLoadCenterVc) {
        self.theController = theController
    }
    
    var arrayMainBookmarkList: [arrayMainBookMarkList]?
    
    func setupUI(){
        self.apiCallLBookMarkList()
    }
    
    func apiCallLBookMarkList(isLoading: Bool = true) {
        
        let param = [
            
                "relation": [
                    "event_detail",
                    "professional_detail.user_detail",
                    "professional_detail"
                ],
                "list": [
                    "id",
                    "event_id",
                    "professional_id"
                ],
                "event_detail_list": [
                    "id",
                    "event_name",
                    "event_image"
                ],
                "professional_detail_list": [
                    "id",
                    "user_id"
                ],
                "professional_detail.user_detail_list": [
                    "id",
                    "name",
                    "photo"
                ]
            
            
//                "relation": [
//                    "event_detail",
//                    "professional_detail.user_detail",
//                    "professional_detail"
//                ],
//                "list": [
//                    "event_id",
//                    "professional_id"
//                ],
//                "event_detail_list": [
//                    "id",
//                    "title",
//                    "event_image"
//                ],
//                "professional_detail_list": [
//                    "id",
//                    "user_id"
//                ],
//                "professional_detail.user_detail_list": [
//                    "id",
//                    "name",
//                    "photo"
//                ]

            ] as [String : Any]
       
        print(param)
        
        ApiManager.shared.MakePostAPI(name: BOOKMARK_LIST, params: param as [String : Any], progress: isLoading, vc: self.theController, isAuth: false, completionHandler: { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let view = (self.theController.view as? BookmarkLoadCenterView)
                let success = json.getBool(key: .success)
                if success {
                    
                    let model = BookmarkModel(JSON: json.dictionaryObject!)
                    self.arrayMainBookmarkList = model?.data ?? []
                    
                    view?.tblBookMark.delegate = self.theController
                    view?.tblBookMark.dataSource = self.theController
                    view?.tblBookMark.reloadData()
                }
                else {
                    self.arrayMainBookmarkList = nil
                    view?.tblBookMark.reloadData()
                }
            }
        })
    }
}

