//
//  EventDetailsVC-TableView+Extension.swift
//  Load
//
//  Created by Haresh Bhai on 18/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

extension EventDetailsVC:UITableViewDataSource, UITableViewDelegate, LoadMoreDelegate {
    
    //MARK:- TableView Delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.mainModelView.headerArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 || section == 4{
            return 0
        }
        return 70
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 || section == 2 || section == 4 {
            return 0
        }
        return 3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = EventDetailsHeaderView.instanceFromNib() as? EventDetailsHeaderView
        view?.setupUI()
        view?.rateView.isHidden = section == 4 ? false : true
        view?.lblTitle.text = self.mainModelView.headerArray[section]
        if section == 1 {
            view?.setupFont(size: 20)
            view?.lblTitle.text = self.mainModelView.eventDetails?.eventName
        }
        else {
            view?.setupFont(size: 16)
        }
        return view
    }    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = ProfileFooterView.instanceFromNib() as? ProfileFooterView
        view?.setupUI()
        return view
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? UIScreen.main.bounds.width : UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? UIScreen.main.bounds.width : UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 3 {
            let filter = self.mainModelView.eventDetails?.amenitiesAvailable?.filter({ (data) -> Bool in
                data.data == true
            })
            if (filter?.count) ?? 0 >= 4 && !self.mainModelView.isAmenitiesLoadMore {
                return 2 + ((filter?.count)! == 4 ? 0 : 1)
            }
            else if self.mainModelView.isAmenitiesLoadMore {
                return Int((Double((filter?.count ?? 0)) / 2).rounded())
            }
            return Int((Double((filter?.count)!) / 2).rounded()) + ((filter?.count)! <= 4 ? 0 : 1)
        }
        else if section == 4 {
            return 0
        }
        else if section == 5 || section == 6 {
            return 2
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventPhotoCell") as! EventPhotoCell
            cell.selectionStyle = .none
            cell.setupUI(model: self.mainModelView.eventDetails!)
            return cell
        }
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventDescriptionCell") as! EventDescriptionCell
            cell.selectionStyle = .none
            cell.setupUI(model: self.mainModelView.eventDetails!)
            return cell
        }
        else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventDetailsCell") as! EventDetailsCell
            cell.selectionStyle = .none
            cell.setupUI(model: self.mainModelView.eventDetails!)
            return cell
        }
        else if indexPath.section == 3 {
            let filter = self.mainModelView.eventDetails?.amenitiesAvailable?.filter({ (data) -> Bool in
                data.data == true
            })
            var count = Int((filter?.count)! / 2)
            if (filter?.count)! >= 4 {
                if !self.mainModelView.isAmenitiesLoadMore {
                    count = 2
                }
            }
            if count != indexPath.row || self.mainModelView.isAmenitiesLoadMore {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AmenitiesCell") as! AmenitiesCell
                cell.selectionStyle = .none
                let v1 = indexPath.row == 0 ? 0 : (indexPath.row * 2)
                let v2 = indexPath.row == 0 ? 1 : (indexPath.row * 2) + 1
                let value1 = filter![v1].name!
                var value2 = ""
                if count == (indexPath.row - 1) {
                    if count % 2 == 0 {
                        value2 = filter?[v2].name ?? ""
                    }
                }
                else {
                    if (filter?.count)! > v2 {
                        value2 = filter?[v2].name ?? ""
                    }
                }
                cell.setupUI(lblTitle1: value1, lblTitle2: value2)
                if tableView.numberOfRows(inSection: indexPath.section) == (indexPath.row + 1) {
                    cell.viewBottom.constant = 30
                }
                else {
                    cell.viewBottom.constant = 0
                }
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "LoadMoreCell") as! LoadMoreCell
                cell.tag = indexPath.section
                cell.selectionStyle = .none
                cell.delegate = self
                let value = (filter?.count)! - 4
                cell.lblTitle.text = "Show \(value) amenties"
                cell.setupUI()
                return cell
            }
        }
        else if indexPath.section == 4 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "EventReviewCell") as! EventReviewCell
                cell.selectionStyle = .none
                cell.setupUI()                
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "LoadMoreCell") as! LoadMoreCell
                cell.selectionStyle = .none
                cell.lblTitle.text = "Show 394 reviews"
                cell.setupUI()
                return cell
            }
        }
        else if indexPath.section == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventRulesCell") as! EventRulesCell
            cell.selectionStyle = .none
            if indexPath.row == 0 {
                cell.setupUI(title: "General rules", description: self.mainModelView.eventDetails!.generalRules ?? "")
            }
            else {
                cell.setupUI(title: "\(self.mainModelView.eventDetails?.cancellationPolicyDetail?.name ?? "") Cancellation policy", description: self.mainModelView.eventDetails?.cancellationPolicyDetail?.description ?? "")
                
            }
            return cell
        }
        else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "EventOtherEventCell") as! EventOtherEventCell
                cell.selectionStyle = .none
                cell.setupUI(eventDetails: self.mainModelView.eventDetails!)
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "LoadMoreCell") as! LoadMoreCell
                cell.selectionStyle = .none
                cell.lblTitle.text = "Show more events"
                cell.setupUI()
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func LoadMoreDidFinish(tag: Int) {
        if tag == 3 {
            self.mainModelView.isAmenitiesLoadMore = true
            self.mainView.tableView.reloadData()
        }
    }
}

