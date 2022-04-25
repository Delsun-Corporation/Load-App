//
//  ListingsVC_TableView+Extension.swift
//  Load
//
//  Created by Haresh Bhai on 20/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SwiftyJSON

extension ListingsVC: UITableViewDelegate, UITableViewDataSource, ListingUserProfileDelegate {
    
    //MARK:- TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return (self.mainModelView.listingArray?.professionalUserList?.count)! + 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : ((self.mainModelView.listingArray?.professionalUserList?[section - 1].data?.count)! == 0 ? 0 : 63)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let view = ListingHeaderView.instanceFromNib() as? ListingHeaderView
            view?.setupUI()
            return view
        }
        else {
            let view = ListingHeaderView.instanceFromNib() as? ListingHeaderView
            view?.setupUI()
            view?.lblTitle.text = self.mainModelView.listingArray?.professionalUserList?[section - 1].name
            view?.btnViewAll.tag = section-1
            view?.btnViewAll.addTarget(self, action: #selector(viewAllbtnTapped), for: .touchUpInside)
            return view
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : ((self.mainModelView.listingArray?.professionalUserList?[section - 1].data?.count)! == 0 ? 0 : 1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: CoachNeededCell = self.mainView.tableView.dequeueReusableCell(withIdentifier: "CoachNeededCell") as! CoachNeededCell
            cell.selectionStyle = .none
            cell.tag = indexPath.row
            cell.delegate = self
            cell.setupUI(model: (self.mainModelView.listingArray?.requestList)!)
            return cell
        }
        else {
            let cell: ListingUserListCell = self.mainView.tableView.dequeueReusableCell(withIdentifier: "ListingUserListCell") as! ListingUserListCell
            cell.selectionStyle = .none
            cell.tag = indexPath.row
            cell.delegate = self
            cell.setupUI(model: (self.mainModelView.listingArray?.professionalUserList?[indexPath.section - 1].data)!)
            return cell
        }
    }
    
    func ListingUserProfileDidFinish(id: String,index:Int) {
        let obj = AppStoryboard.LoadCenter.instance.instantiateViewController(withIdentifier: "OtherUserProfileVC") as! OtherUserProfileVC
        obj.mainModelView.userId = id
        obj.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(obj, animated: true)
    }
     
    @objc func viewAllbtnTapped(sender: UIButton){
        print("Tag : \(sender.tag)")
        print("selected Name : \(self.mainModelView.listingArray?.professionalUserList?[sender.tag].name)")
        
        let obj = AppStoryboard.LoadCenter.instance.instantiateViewController(withIdentifier: "ListingViewAllLoadCenterVc") as! ListingViewAllLoadCenterVc
        obj.mainModelView.selectedFromController = .fromLisitng
        obj.strTitleName = self.mainModelView.listingArray?.professionalUserList?[sender.tag].name ?? ""
        obj.mainModelView.specializationID = self.mainModelView.listingArray?.professionalUserList?[sender.tag].id ?? 0
        let nav = UINavigationController(rootViewController: obj)
        nav.modalPresentationStyle = .overFullScreen
        self.present(nav, animated: true, completion: nil)
        
    }
}

extension ListingsVC: redirectToDetailScreenDelegate{
    
    func redirectToDetailScreen(data : RequestList) {
        let obj = AppStoryboard.LoadCenter.instance.instantiateViewController(withIdentifier: "OwnRequestListingDetailScreenVc") as! OwnRequestListingDetailScreenVc
        obj.mainModelView.requestId = data.id
        let nav = UINavigationController(rootViewController: obj)
        nav.modalPresentationStyle = .overFullScreen
        self.present(nav, animated: true, completion: nil)

    }
    
}
