//
//  CheckAvailibityViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 23/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage
import KRPullLoader

class CheckAvailibityViewModel: CustomNavigationBackDelegate, KRPullLoadViewDelegate {
    
    //MARK:- Variables
    fileprivate weak var theController:CheckAvailibityVC!
    
    init(theController:CheckAvailibityVC) {
        self.theController = theController
    }
    
    var profileDetails: OtherUserDetailsModelClass?
    var calendarArray: CalendarModelClass?
    var clientBookedDatesArray: ClientBookedDatesModelClass?

    var currentShowMonth = Date()
    var isExpanded:Bool = false
    var expandedSectionMain:Int = -1
    var expandedSection:Int = -1
    var expandedRow:Int = -1
    var expandedIndex:Int = 0
    var expandedDate:String = ""
    var selectedTime:String = ""
    var selectedTimeId:String = ""
    var arrayCount:Int = 0
    var expandedHeight:CGFloat = 0
    var isOpenSwitch: Bool = false
    var viewSwitchAccount: SwitchAccountButtonView?
    var logList: TrainingLogListModelClass?
    let refreshView = KRPullLoadView()
    let loadView = KRPullLoadView()
    
    //MARK:- PullLoadView
    
    func pullLoadView(_ pullLoadView: KRPullLoadView, didChangeState state: KRPullLoaderState, viewType type: KRPullLoaderType) {
        if type == .refresh {
            switch state {
            case let .loading(completionHandler):
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                    self.showDetails(isLoading: false)
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
                    self.loadMoreMonth()
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
    
    //MARK:- Functions
    func setupData() {
        refreshView.delegate = self
        loadView.delegate = self
        let view = (self.theController.view as? CheckAvailibityView)
        view?.tableView.addPullLoadableView(refreshView, type: .refresh)
        view?.tableView.addPullLoadableView(loadView, type: .loadMore)
        self.showDetails()
    }
    
    func showDetails(isLoading:Bool = true) {
        arrayCount = 6
        currentShowMonth = Date()
        let data = self.makeDateArray(date: currentShowMonth, position: currentShowMonth.startOfMonth().position(), PreviousCount: currentShowMonth.getPreviousMonth()!.count(), currentCount: currentShowMonth.startOfMonth().count())
        calendarArray = CalendarModelClass(JSON: JSON(data).dictionaryObject!)
        let firstDate:String = currentShowMonth.startOfMonth().iso8601
        
        let currentLastMonth = Calendar.current.date(byAdding: .month, value: 6, to: currentShowMonth)!
        currentShowMonth = currentLastMonth
        let lastDate:String = currentLastMonth.endOfMonth().iso8601
        self.apiCallcommentList(fromDate: firstDate, toDate: lastDate, isLoading: isLoading)
    }
    
    func loadMoreMonth() {
        arrayCount += 6
        let data = self.makeDateArray(date: currentShowMonth, position: currentShowMonth.startOfMonth().position(), PreviousCount: currentShowMonth.getPreviousMonth()!.count(), currentCount: currentShowMonth.startOfMonth().count())
        
        let calendarArray = CalendarModelClass(JSON: JSON(data).dictionaryObject!)

        for data in calendarArray?.date ?? [] {
            self.calendarArray?.date?.append(data)
        }
        
        for data in calendarArray?.no ?? [] {
            self.calendarArray?.no?.append(data)
        }
        
        let firstDate:String = currentShowMonth.startOfMonth().iso8601
        let currentLastMonth = Calendar.current.date(byAdding: .month, value: 6, to: currentShowMonth)!
        currentShowMonth = currentLastMonth
        let lastDate:String = currentLastMonth.endOfMonth().iso8601
        self.apiCallcommentList(fromDate: firstDate, toDate: lastDate, isLoading: false)
    }
    
    func apiCallForTrainingLogList(userId: String, startDate: String, endDate: String) {
        
        let relation = ["training_intensity", "training_goal", "training_activity", "user_detail"]
        let trainingIntensityList =  [ "id", "name", "code", "is_active" ]
        let trainingGoalList = [ "id", "name", "code", "is_active" ]
        let trainingActivityList = [ "id", "name", "code", "is_active", "icon_path" ]
        let userDetailList = [ "id", "name", "email", "mobile", "date_of_birth", "gender", "height", "weight", "photo", "is_active" ]
        
        let param = ["user_id":userId, "start_date": startDate, "end_date": endDate, "relation" : relation, "training_intensity_list": trainingIntensityList, "training_goal_list": trainingGoalList, "training_activity_list": trainingActivityList, "user_detail_list" : userDetailList] as [String : Any]
        
        ApiManager.shared.MakePostAPI(name: TRAINING_LOG_LIST, params: param as [String : Any], vc: self.theController, isAuth:false) { (response, error) in
            if response != nil {
                let json = JSON(response!)
                let data = json.getDictionary(key: .data)
                self.logList = TrainingLogListModelClass(JSON: data.dictionaryObject!)
                let view = (self.theController.view as? CalendarView)
                view?.tableView.reloadData()
            }
        }
    }
    
    func openCreateTraining() {
        let obj: CreateTrainingVC = AppStoryboard.Calendar.instance.instantiateViewController(withIdentifier: "CreateTrainingVC") as! CreateTrainingVC
        let nav = UINavigationController(rootViewController: obj)
        nav.modalPresentationStyle = .overFullScreen
        self.theController.present(nav, animated: false, completion: nil)
    }
    
    func makeDateArray(date: Date, position:Int, PreviousCount: Int, currentCount:Int) -> NSDictionary {
        
        var arrayDate:[String] = []
        var arrayNo:[Int] = []
        if position != 1 {
            for i in (PreviousCount - (position - 2))...PreviousCount {
                arrayNo.append(i)
                let day = i > 9 ? "\(i)" : "0\(i)"
                arrayDate.append((date.getPreviousMonth()?.year)! + "-" + (date.getPreviousMonth()?.month)! + "-" + day)
            }
        }
        
        for i in 1...currentCount {
            arrayNo.append(i)
            let day = i > 9 ? "\(i)" : "0\(i)"
            arrayDate.append((date.year) + "-" + (date.month) + "-" + day)
        }
        
        if arrayNo.count < 42 {
            for i in 1...(42 - arrayNo.count) {
                arrayNo.append(i)
                let day = i > 9 ? "\(i)" : "0\(i)"
                arrayDate.append((date.getNextMonth()?.year)! + "-" + (date.getNextMonth()?.month)! + "-" + day)
            }
        }
        return ["no":arrayNo,"date":arrayDate]
    }
    
    func setupNavigationbar(title:String, type:String, image:String) {
        self.theController.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        self.theController.navigationController?.setColor()
        self.theController.navigationItem.hidesBackButton = true
        
        if let vwnav = ViewNavWhite.instanceFromNib() as? ViewNavWhite {
            
            var hightOfView = 0
            if UIScreen.main.bounds.height >= 812 {
                hightOfView = 44
            }
            else {
                hightOfView = 20
            }
            
            vwnav.frame = CGRect(x: 0, y: 0, width: self.theController.navigationController?.navigationBar.frame.width ?? 320, height: vwnav.frame.height + CGFloat(hightOfView))
            vwnav.lblName.text = title.uppercased()
            vwnav.lblType.text = type
            vwnav.showImage(url: image)
            vwnav.tag = 1000
            vwnav.delegate = self
            self.theController.navigationController?.view.addSubview(vwnav)
        }
    }
    
    func CustomNavigationBack() {
        self.theController.navigationController?.popViewController(animated: true)
    }
    
    func apiCallcommentList(fromDate: String, toDate: String, isLoading:Bool = true) {
        let param = [
            "from_date": fromDate,
            "to_date": toDate,
            "relation" : [ "available_time_detail", "from_user_detail", "to_user_detail" ],
            "from_user_detail_list" : [ "id" , "name" ],
            "to_user_detail_list" : [ "id" , "name" ]
            ] as [String : Any]
        print(param)
        
        ApiManager.shared.MakePostAPI(name: GET_CLIENT_BOOKED_DATES, params: param as [String : Any], progress: isLoading, vc: self.theController, isAuth:false) { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let view = (self.theController.view as? CheckAvailibityView)
                let success = json.getBool(key: .success)
                if success {
                    let data = json.getDictionary(key: .data)
                    self.clientBookedDatesArray = ClientBookedDatesModelClass(JSON: data.dictionaryObject!)
                    view?.tableView.reloadData()
                }
                else {
                    view?.tableView.reloadData()
                }
            }
        }
    }
}
