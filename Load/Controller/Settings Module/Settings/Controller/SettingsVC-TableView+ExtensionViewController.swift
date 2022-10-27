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
            cell.setupUI(name: self.mainModelView.titleArray[indexPath.row].rawValue,
                         indexPath: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch mainModelView.titleArray[indexPath.row] {
        case .account:
            let obj = AppStoryboard.Settings.instance.instantiateViewController(withIdentifier: "AccountVC") as! AccountVC
            obj.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(obj, animated: true)
        case .loadCentre:
            let obj = AppStoryboard.Settings.instance.instantiateViewController(withIdentifier: "LoadCenterSettingsVC") as! LoadCenterSettingsVC
            obj.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(obj, animated: true)
        case .training:
            let obj = AppStoryboard.Settings.instance.instantiateViewController(withIdentifier: "TrainingSettingsVC") as! TrainingSettingsVC
            obj.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(obj, animated: true)
        case .notifications:
            LOADLog("Notifications tapped")
        case .helpAndSupport:
            LOADLog("Help and support tapped")
        case .privacyAndPolicy:
            LOADLog("Privacy and policy tapped")
        case .referAndEarn:
            LOADLog("Refer and Earn tapped")
        case .contactUs:
            LOADLog("Contact us tapped")
        case .changePassword:
            let obj = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
            obj.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(obj, animated: true)
        case .logout:
            LogoutButtonAction()
        case .name:
            let obj = AppStoryboard.Settings.instance.instantiateViewController(withIdentifier: "SettingsProfileVC") as! SettingsProfileVC
            obj.mainModelView.delegate = self.mainModelView
            obj.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(obj, animated: true)
        }
    }
}
