//
//  BookmarkLoadCenter + TableView.swift
//  Load
//
//  Created by iMac on 18/03/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import Foundation

extension BookmarkLoadCenterVc: UITableViewDelegate, UITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {
        
        
//        if self.mainModelView.arrayMainBookmarkList?[section].arraySubData?.count ?? 0 >= 1{
//            return 1
//        }
        
        return self.mainModelView.arrayMainBookmarkList?.count ?? 0
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 63
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = ListingHeaderView.instanceFromNib() as? ListingHeaderView
        view?.setupUI()
        
        let name = self.mainModelView.arrayMainBookmarkList?[section].name
        view?.lblTitle.text = name
        view?.btnViewAll.tag = section
        view?.btnViewAll.addTarget(self, action: #selector(viewAllTapped), for: .touchUpInside)
        
        return view
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        if self.mainModelView.arrayMainBookmarkList?[section].name.lowercased() == "Professionals".lowercased(){
//            if self.mainModelView.arrayMainBookmarkList?[section].arraySubData?.count >= 1{
//                return 1
//            }
//        }else{
//            if self.mainModelView.arrayMainBookmarkList?[section].arraySubData?.count >= 1{
//                return 1
//            }
//        }
        
        if self.mainModelView.arrayMainBookmarkList?[section].arraySubData?.count ?? 0 >= 1{
            return 1
        }
        
        return 0
//        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MultipleImagesBookmarkTblCell") as! MultipleImagesBookmarkTblCell
        
        let sectionName  = self.mainModelView.arrayMainBookmarkList?[indexPath.section].name
        
        let arrayData = self.mainModelView.arrayMainBookmarkList?[indexPath.section].arraySubData
        cell.tag = indexPath.row
        cell.setupUI(sectionHeaderName: sectionName!,arrayData :arrayData)
        
        return cell
    }

}

//MARK: - View All Tapped

extension BookmarkLoadCenterVc{
    
    @objc func viewAllTapped(sender:UIButton){
        
        let sectionName  = self.mainModelView.arrayMainBookmarkList?[sender.tag].name

        print("Tag : \(sender.tag)")
//        print("selected Name : \(self.mainModelView.listingArray?.professionalUserList?[sender.tag].name)")
        
        let obj = AppStoryboard.LoadCenter.instance.instantiateViewController(withIdentifier: "ListingViewAllLoadCenterVc") as! ListingViewAllLoadCenterVc
        obj.mainModelView.selectedFromController = .fromSaved
        obj.strTitleName = sectionName ?? ""
        obj.mainModelView.selectedViewAllForName = sectionName ?? ""
        let nav = UINavigationController(rootViewController: obj)
        nav.modalPresentationStyle = .overFullScreen
        self.present(nav, animated: true, completion: nil)

    }
}
