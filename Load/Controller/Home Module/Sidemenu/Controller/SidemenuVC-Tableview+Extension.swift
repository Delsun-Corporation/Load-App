  //
//  SidemenuVC-Tableview+Extension.swift
//  Load
//
//  Created by Haresh Bhai on 02/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
  
extension SidemenuVC: UITableViewDelegate, UITableViewDataSource {
    
    //MARK:- TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 138
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 138
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : self.mainModelView.titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: SidemenuHeaderCell = self.mainView.tableView.dequeueReusableCell(withIdentifier: "SidemenuHeaderCell") as! SidemenuHeaderCell
            cell.selectionStyle = .none
            cell.setupUI()
            return cell
        }
        else {
            let cell: SidemenuListCell = self.mainView.tableView.dequeueReusableCell(withIdentifier: "SidemenuListCell") as! SidemenuListCell
            cell.selectionStyle = .none
            cell.lblTitle.text = self.mainModelView.titleArray[indexPath.row]
            cell.setupUI()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                let obj: NotificationVC = AppStoryboard.SideMenu.instance.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
                SJSwiftSideMenuController.hideLeftMenu()
                let nav = UINavigationController(rootViewController: obj)
                nav.modalPresentationStyle = .overCurrentContext
                self.present(nav, animated: false, completion: nil)
            }
            else if indexPath.row == 1 {
                let obj: SessionVC = AppStoryboard.SideMenu.instance.instantiateViewController(withIdentifier: "SessionVC") as! SessionVC
                SJSwiftSideMenuController.hideLeftMenu()
                let nav = UINavigationController(rootViewController: obj)
                nav.modalPresentationStyle = .overCurrentContext
                self.present(nav, animated: false, completion: nil)
            }
            else if indexPath.row == 2 {
                
            }
            else if indexPath.row == 3 {
                let obj: SavedWorkoutVC = AppStoryboard.SideMenu.instance.instantiateViewController(withIdentifier: "SavedWorkoutVC") as! SavedWorkoutVC
                SJSwiftSideMenuController.hideLeftMenu()
                let nav = UINavigationController(rootViewController: obj)
                nav.modalPresentationStyle = .overCurrentContext
                self.present(nav, animated: false, completion: nil)
            }
            else if indexPath.row == 4 {
                let obj: EmergencyVC = AppStoryboard.SideMenu.instance.instantiateViewController(withIdentifier: "EmergencyVC") as! EmergencyVC
                SJSwiftSideMenuController.hideLeftMenu()
                let nav = UINavigationController(rootViewController: obj)
                nav.modalPresentationStyle = .overCurrentContext
                self.present(nav, animated: false, completion: nil)
            }
        }
    }
}
