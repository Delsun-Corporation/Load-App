//
//  FollowingVC-TableView+Extension.swift
//  Load
//
//  Created by Haresh Bhai on 26/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import MGSwipeTableCell

extension FollowingVC :UITableViewDataSource, UITableViewDelegate, SelectFollowingDelegate {
    
    //MARK:- TableView Delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : self.mainModelView.profileDetails?.list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddNewContactCell") as! AddNewContactCell
            cell.selectionStyle = .none
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FollowingCell") as! FollowingCell
            cell.selectionStyle = .none
            let model = self.mainModelView.profileDetails?.list![indexPath.row]
            cell.delegateSelect = self
            cell.selectionStyle = .none
            cell.tag = indexPath.row
            cell.isSelectedRow = (model?.isSelected)!
            cell.setupUI(model: model!)
            cell.rightButtons = [MGSwipeButton(title: "", icon: UIImage(named:"ic_delete_new"), backgroundColor: UIColor.appthemeRedColor, callback: { (MGCell) -> Bool in
                return true
            })]
            cell.showSelect(isShow: IS_SHOW_EDIT_FOLLOWERS)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = AppStoryboard.LoadCenter.instance.instantiateViewController(withIdentifier: "OtherUserProfileVC") as! OtherUserProfileVC
        let model = self.mainModelView.profileDetails?.list![indexPath.row]
        obj.mainModelView.userId = model?.id?.stringValue ?? ""
        obj.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    func SelectFollowingDidFinish(index: Int, isSelected: Bool) {
        self.mainModelView.profileDetails?.list![index].isSelected = isSelected
    }
}
