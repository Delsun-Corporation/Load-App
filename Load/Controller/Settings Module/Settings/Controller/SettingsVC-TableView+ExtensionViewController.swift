//
//  SettingsVC-TableView+ExtensionViewController.swift
//  Load
//
//  Created by Haresh Bhai on 22/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

extension SettingsVC :UITableViewDataSource, UITableViewDelegate {
    
    //MARK:- TableView Delegates
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mainModelView.titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingProfileCell") as! SettingProfileCell
            cell.selectionStyle = .none
            cell.setupUI()
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingListCell") as! SettingListCell
            cell.selectionStyle = .none
            cell.setupUI(name: self.mainModelView.titleArray[indexPath.row], indexPath: indexPath)            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let obj = AppStoryboard.Settings.instance.instantiateViewController(withIdentifier: "SettingsProfileVC") as! SettingsProfileVC
            obj.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 1 {
            let obj = AppStoryboard.Settings.instance.instantiateViewController(withIdentifier: "AccountVC") as! AccountVC
            obj.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 2 {
            let obj = AppStoryboard.Settings.instance.instantiateViewController(withIdentifier: "LoadCenterSettingsVC") as! LoadCenterSettingsVC
            obj.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 3 {
            let obj = AppStoryboard.Settings.instance.instantiateViewController(withIdentifier: "TrainingSettingsVC") as! TrainingSettingsVC
            obj.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 9 {
            LogoutButtonAction()
        }
        else if indexPath.row == 8{

        }
    }
}
