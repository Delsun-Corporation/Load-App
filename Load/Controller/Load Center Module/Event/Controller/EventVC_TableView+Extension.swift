//
//  EventVC_TableView+Extension.swift
//  Load
//
//  Created by Haresh Bhai on 20/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

extension EventVC:UITableViewDelegate, UITableViewDataSource {
    
    //MARK:- TableView    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 51
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = EventHeaderView.instanceFromNib() as? EventHeaderView
        view?.setupUI()
        return view
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mainModelView.eventArray?.upcomingEvent?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EventCell = self.mainView.tableView.dequeueReusableCell(withIdentifier: "EventCell") as! EventCell
        cell.selectionStyle = .none
        cell.tag = indexPath.row
        cell.eventDelegate = self
        let model = self.mainModelView.eventArray?.upcomingEvent![indexPath.row]
        cell.setupUI(model: model!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.mainModelView.eventArray?.upcomingEvent![indexPath.row]
        let obj: EventDetailsVC = AppStoryboard.LoadCenter.instance.instantiateViewController(withIdentifier: "EventDetailsVC") as! EventDetailsVC
        obj.mainModelView.eventId = (model?.id?.stringValue)!
        let nav = UINavigationController(rootViewController: obj)
        nav.modalPresentationStyle = .overCurrentContext
        self.present(nav, animated: true, completion: nil)
    }
}

//MARK: - Event delegate

extension EventVC: eventDelegateForBookmark {
    func selectionBookmarkEvent(selection: Bool,tag: Int) {
        
        let eventId = self.mainModelView.eventArray?.upcomingEvent?[tag].id
        print("eventId : \(eventId)")
        
        self.mainModelView.apiCallAddAndRemoveFromBookmark(index: tag,eventId: String(Int(eventId ?? 0)), status: selection, isLoading: true)
        
    }
    
}
