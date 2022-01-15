//
//  FeedCommentViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 21/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SwiftyJSON
import KRPullLoader
import IQKeyboardManagerSwift

class FeedCommentViewModel: KRPullLoadViewDelegate {

    //MARK:- Variables
    fileprivate weak var theController:FeedCommentVC!
    let headerArray: [String] = ["Age Requirements", "Form Requirements", "Terms of Service"]
    let headerDataArray: [String] = ["Client ages 13 and up can attend.\nClient ages 13 and below require a company of a guardian.", "Upon confirmation, client are required to complete:\nForm 1\nForm 2\nForm 3", "When you book, you agree to the Load App Additional Terms of Service, Booking Release and Waiver, and Cancellation Policy"]
    var feedId:Int = 0
    var feedDetails: FeedList?
    var feedListDetails: FeedCommentListModelClass?
    let loadView = KRPullLoadView()
    let refreshView = KRPullLoadView()
    var isKeyboardOpen = false
    var tableviewTxtviewisClicked = false
    
    var feedReportId = 0
    var arayReportList : [ReportList] = []
    var reportPickerView = UIPickerView()
    

    init(theController:FeedCommentVC) {
        self.theController = theController
    }
    
    func setupUI() {
        
        self.setupKeyboard()
        loadView.delegate = self
        refreshView.delegate = self
        let view = (self.theController.view as? FeedCommentView)
        view?.tableView.addPullLoadableView(loadView, type: .loadMore)
        view?.tableView.addPullLoadableView(refreshView, type: .refresh)
        self.apiCallcommentList(feedId: self.feedId, lastCommentId: 0, limit: 20)
        self.apiCallReportGet()
        reportPickerView.delegate = theController
        reportPickerView.backgroundColor = UIColor.white
        self.theController.mainView.txtReportFlag.inputView = reportPickerView
    }
    
    func setupKeyboard() {
        let view = (self.theController.view as? FeedCommentView)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view?.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector:#selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func dismissKeyboard() {
        let view = (self.theController.view as? FeedCommentView)
        view?.endEditing(true)
    }
    
    func pullLoadView(_ pullLoadView: KRPullLoadView, didChangeState state: KRPullLoaderState, viewType type: KRPullLoaderType) {
        if type == .refresh {
            switch state {
            case let .loading(completionHandler):
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                    self.apiCallcommentList(feedId: self.feedId, lastCommentId: 0, limit: 20, isLoading: false)
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
                    self.apiCallcommentList(feedId: self.feedId, lastCommentId: (self.feedListDetails?.commentDetails?.list?.last?.id?.intValue)!, limit: 20, isLoading: false)
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
                //                self.getNotifications(page: 1, progress: false)
                completionHandler()
            }
        }
    }

    func apiCallcommentList(feedId: Int, lastCommentId: Int, limit: Int, isLoading:Bool = true) {
        let param = [
            "feed_id": feedId,
            "last_comment_id": lastCommentId,
            "limit" : limit,
            "relation": [ "user_detail"],
            "user_detail_list" : ["id", "photo", "name"]
            ] as [String : Any]
        
        ApiManager.shared.MakePostAPI(name: COMMENT_LIST, params: param as [String : Any], progress: isLoading, vc: self.theController, isAuth:false) { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let view = (self.theController.view as? FeedCommentView)
                let success = json.getBool(key: .success)
                if success {
                    let data = json.getDictionary(key: .data)
                    let model = FeedCommentListModelClass(JSON: data.dictionaryObject!)

                    if lastCommentId == 0 {
                        self.feedListDetails = model
                    }
                    else {
                        self.feedListDetails?.likeDetails = model?.likeDetails
                        for data in (model?.commentDetails?.list)! {
                            self.feedListDetails?.commentDetails?.list?.append(data)
                        }
                    }
                    view?.tableView.delegate = self.theController
                    view?.tableView.dataSource = self.theController
                    view?.tableView.reloadData()
                }
                else {
                    self.feedListDetails = nil
                    view?.tableView.reloadData()
                }
            }
        }
    }
    
    func apiCallCreateComment(feedId: Int, userId: String, comment: String, isLoading:Bool = true) {
        let param = [
            "feed_id": feedId,
            "user_id": userId,
            "comment" : comment
            ] as [String : Any]
        
        ApiManager.shared.MakePostAPI(name: CREATE_COMMENT, params: param as [String : Any], progress: isLoading, vc: self.theController, isAuth:false) { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let view = (self.theController.view as? FeedCommentView)
                let success = json.getBool(key: .success)
                if success {
                    let data = json.getDictionary(key: .data)
                    let model = FeedCommentListList(JSON: data.dictionaryObject!)
                    var list: [FeedCommentListList] = (self.feedListDetails?.commentDetails?.list?.reversed())!
                    list.append(model!)
                    let listNew: [FeedCommentListList] = list.reversed()
                    self.feedListDetails?.commentDetails?.list = listNew
                    self.feedDetails?.commentCount = NSNumber(integerLiteral: (self.feedDetails?.commentCount?.intValue)! + 1)
                    view?.tableView.reloadData {
                        view?.tableView.scrollToTop()
                    }
                }
                else {
                    self.feedListDetails = nil
                    view?.tableView.reloadData()
                }
            }
        }
    }
    
    
    func apiCallForReport(feedId: Int,feed_report_id: Int, isLoading:Bool = true) {
        let param = [
            "feed_id": feedId,
            "feed_report_id" : feed_report_id
            ] as [String : Any]
        
        ApiManager.shared.MakePostAPI(name: SUBMIT_REPORT, params: param as [String : Any], progress: isLoading, vc: self.theController, isAuth:false) { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let view = (self.theController.view as? FeedCommentView)
                let success = json.getBool(key: .success)
                if success {
                    let data = json.getDictionary(key: .data)
                }
                else {
                    self.feedListDetails = nil
                    view?.tableView.reloadData()
                }
            }
        }
    }
    
    func apiCallReportGet() {
        
        let param = ["":""] as [String : Any]
        print(JSON(param))
        
        ApiManager.shared.MakeGetAPI(name: REPORT_FEED , params: param as [String : Any], progress: false, vc: self.theController, isAuth: false, completionHandler: { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let success = json.getBool(key: .success)
                if success {
                    let data = json.getDictionary(key: .data)
                    
                    let model = ReportData(JSON: data.dictionaryObject!)
                    let dataArray = model?.list?.sorted(by: { (data1, data2) -> Bool in
                        return data1.sequence ?? 0 < data2.sequence ?? 0
                    })
                    
                    self.arayReportList = dataArray!
                    
                }
                else {
                    let message = json.getString(key: .message)
                    makeToast(strMessage: message)
                }
            }
        })
    }

    
    func apiCallFeedLike(feedId: Int) {
        let param = [
            "feed_id": feedId
            ] as [String : Any]
        
        ApiManager.shared.MakePostAPI(name: FEED_LIKE, params: param as [String : Any], progress: false, vc: self.theController, isAuth:false) { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
            }
        }
    }
}


extension FeedCommentViewModel {
    @objc func keyboardWillShow(_ notification: NSNotification) {
        
        let view = (self.theController.view as? FeedCommentView)
        // Do something here
        
        if let keyboardRectValue = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size {
            let keyboardHeight = keyboardRectValue.height
            isKeyboardOpen = true
            if tableviewTxtviewisClicked {
                view!.tableView.contentInset.bottom = keyboardHeight
                return
            }
            UIView.animate(withDuration: 1.5, animations: {
                var bottomPadding: CGFloat = 0.0
                if #available(iOS 11.0, *) {
                    let window = UIApplication.shared.keyWindow
                    bottomPadding = window?.safeAreaInsets.bottom ?? 0.0
                }
                view?.constantBottomofView.constant = keyboardHeight - bottomPadding
            }, completion: { (status) in
                //                self.scrollToBottom()
            })
        }
        
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        let view = (self.theController.view as? FeedCommentView)
        isKeyboardOpen = false
        if tableviewTxtviewisClicked {
            tableviewTxtviewisClicked = false
            view!.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            return
        }
        UIView.animate(withDuration: 1.5, animations: {
            view?.constantBottomofView.constant = 0.0
            view!.layoutIfNeeded()
        }, completion: nil)
    }
}
