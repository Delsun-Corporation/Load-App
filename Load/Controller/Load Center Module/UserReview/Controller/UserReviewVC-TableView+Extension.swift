//
//  UserReviewVC-TableView+Extension.swift
//  Load
//
//  Created by Haresh Bhai on 16/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

extension UserReviewVC:UITableViewDataSource, UITableViewDelegate, TTTAttributedLabelDelegate {
    //MARK:- TableView Delegates
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserReviewCell") as! UserReviewCell
        cell.selectionStyle = .none
        cell.imgProfile.sd_setImage(with: TEST_IMAGE_URL.toURL(), completed: nil)
        let strFull = "I need to implement the same. As answers are already given but according to me TTTAttributedLabel is the best way to do it. I gives I need to implement the same. As answers are already given but according to me TTTAttributedLabel is the best way to do it. I gives you"
        cell.lblComment.numberOfLines = 0
        cell.lblComment.tag = indexPath.row
        if self.mainModelView.selectedReadMore.contains(indexPath.row) {
            cell.lblComment.text = strFull
        }
        else {
            cell.lblComment.showTextOnTTTAttributeLable(str: strFull, readMoreText: "...ReadMore", readLessText: "", font: themeFont(size: 13, fontname: .ProximaNovaRegular), charatersBeforeReadMore: 150, activeLinkColor: UIColor.appthemeRedColor, isReadMoreTapped: false, isReadLessTapped: false)
            cell.lblComment.delegate = self
        }        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWithTransitInformation components: [AnyHashable : Any]!) {
      if let _ = components as? [String: String] {
        if let value = components["ReadMore"] as? String, value == "1" {
//          self.readMore(readMore: true)
//            let strFull = "I need to implement the same. As answers are already given but according to me TTTAttributedLabel is the best way to do it. I gives I need to implement the same. As answers are already given but according to me TTTAttributedLabel is the best way to do it. I gives you"
//
//            label.showTextOnTTTAttributeLable(str: strFull, readMoreText: "...ReadMore", readLessText: "", font: nil, charatersBeforeReadMore: 0, activeLinkColor: UIColor.blue, isReadMoreTapped: true, isReadLessTapped: false)
            self.mainModelView.selectedReadMore.append(label.tag)
            self.mainView.tableView.reloadRows(at: [IndexPath(row: label.tag, section: 0)], with: .none)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.mainView.delegate?.ProfileViewDidFinish(height: self.mainView.tableView.contentSize.height)
            }
        }
        if let value = components["ReadLess"] as? String, value == "1" {
        }
      }
    }
}
