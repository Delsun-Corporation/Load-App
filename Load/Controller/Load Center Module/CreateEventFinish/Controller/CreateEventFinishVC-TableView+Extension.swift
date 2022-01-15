//
//  CreateEventFinishVC-TableView+Extension.swift
//  Load
//
//  Created by Haresh Bhai on 16/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

extension CreateEventFinishVC:UITableViewDataSource, UITableViewDelegate, LoadMoreDelegate {
    
    //MARK:- TableView Delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.mainModelView.headerArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 20
        }
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 || section == 2 {
            return 0
        }
        return 3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = EventDetailsFinishHeaderView.instanceFromNib() as? EventDetailsFinishHeaderView
        view?.setupUI()
        view?.lblTitle.text = self.mainModelView.headerArray[section]
        view?.setupFont(size: section == 0 ? 20 :16)
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
            let filter = self.mainModelView.amenitiesArray.filter({ (data) -> Bool in
                (data[1] as? Bool) == true
            })
            if (filter.count) >= 4 && !self.mainModelView.isAmenitiesLoadMore {
                return 2 + ((filter.count) == 4 ? 0 : 1)
            }
            else if self.mainModelView.isAmenitiesLoadMore {
                return Int((Double((filter.count)) / 2).rounded())
            }
            return Int((Double((filter.count)) / 2).rounded()) + ((filter.count) <= 4 ? 0 : 1)
        }
        else if section == 4 {
            return 2
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventPhotoFinishCell") as! EventPhotoFinishCell
            cell.selectionStyle = .none
            cell.imgEvent.image = self.mainModelView.images ?? nil
            return cell
        }
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventPreviewDescriptionCell") as! EventPreviewDescriptionCell
            cell.selectionStyle = .none
            cell.setupUI(title: self.mainModelView.txtEventName, pricePerson: self.mainModelView.txtEventPrice, description: self.mainModelView.txtDescription)
            return cell
        }
        else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventDetailsCell") as! EventDetailsCell
            cell.selectionStyle = .none
            cell.setupUI(txtDate: self.mainModelView.selectedDate!, earlierTime: self.mainModelView.txtTimeArlier, txtTime: self.mainModelView.selectedTime!, location: self.mainModelView.selectedAddress, latitude: (self.mainModelView.selectedCoordinate?.latitude)!, longitude: (self.mainModelView.selectedCoordinate?.longitude)!, howLongTime: self.mainModelView.eventTime)
            return cell
        }
        else if indexPath.section == 3 {
            let filter = self.mainModelView.amenitiesArray.filter({ (data) -> Bool in
                (data[1] as? Bool) == true
            })
            var count = Int((filter.count) / 2)
            if (filter.count) >= 4 {
                if !self.mainModelView.isAmenitiesLoadMore {
                    count = 2
                }
            }
            if count != indexPath.row || self.mainModelView.isAmenitiesLoadMore {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AmenitiesCell") as! AmenitiesCell
                cell.selectionStyle = .none
                let v1 = indexPath.row == 0 ? 0 : (indexPath.row * 2)
                let v2 = indexPath.row == 0 ? 1 : (indexPath.row * 2) + 1
                let value1 = filter[v1][0]
                var value2 = ""
                if count == (indexPath.row - 1) {
                    if count % 2 == 0 {
                        value2 = filter[v2][0] as! String
                    }
                }
                else {
                    if (filter.count) > v2 {
                        value2 = filter[v2][0] as! String
                    }
                }
                cell.setupUI(lblTitle1: value1 as! String, lblTitle2: value2)
                //TODO: - Yash changes
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
                let value = (filter.count) - 4
                cell.lblTitle.text = "Show \(value) amenties"
                cell.setupUI()
                return cell
            }
        }
        else if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventRulesCell") as! EventRulesCell
            cell.selectionStyle = .none
            if indexPath.row == 0 {
                cell.setupUI(title: "General rules", description: self.mainModelView.GeneralRules)
            }
            else {
                cell.setupUI(title: "\(self.mainModelView.CancellationRulesType) cancellation policy", description: self.mainModelView.CancellationRules)

            }
            return cell
        }
        return UITableViewCell()
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

