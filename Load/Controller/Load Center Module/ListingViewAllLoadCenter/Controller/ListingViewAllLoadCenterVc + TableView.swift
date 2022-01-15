//
//  ListingViewAllLoadCenterVc + TableView.swift
//  Load
//
//  Created by iMac on 21/05/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import Foundation

extension ListingViewAllLoadCenterVc: UITableViewDelegate, UITableViewDataSource{
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mainModelView.arrayProfessionalList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ViewAllLoadCenterTblCell") as! ViewAllLoadCenterTblCell
        cell.tag = indexPath.row
        cell.eventDelegate = self
        cell.messageDelegate = self
        cell.setupData(data: self.mainModelView.arrayProfessionalList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Working
//        let obj = AppStoryboard.LoadCenter.instance.instantiateViewController(withIdentifier: "OtherUserProfileVC") as! OtherUserProfileVC
//        obj.mainModelView.userId = String(self.mainModelView.arrayProfessionalList[indexPath.row].id ?? 0)
//        obj.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(obj, animated: true)
    }
}

//MARK: - Bookmark Delegate

extension ListingViewAllLoadCenterVc: eventDelegateForBookmark{
    
    func selectionBookmarkEvent(selection: Bool,tag: Int) {
        
        let professionalId = self.mainModelView.arrayProfessionalList[tag].id
        self.mainModelView.apiCallAddAndRemoveFromBookmark(index: tag, professtionalID: String(professionalId ?? 0), status: selection)
        
    }

}

//MARK: - Message redirection delegate

extension ListingViewAllLoadCenterVc:redirectMessageDelegate{
    func messageClickWithID(index: String) {
        self.mainModelView.apiCallShowMessages(toID: String(Int(self.mainModelView.arrayProfessionalList[Int(index) ?? 0].userDetail?.id ?? 0)))
    }
    
}
