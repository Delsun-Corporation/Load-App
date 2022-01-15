//
//  FeedCommentVC-TableView+Extension.swift
//  Load
//
//  Created by Haresh Bhai on 21/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SwiftyJSON

extension FeedCommentVC:UITableViewDataSource, UITableViewDelegate, FeedsActionDelegate {
   
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
        return section == 0 ? 1 : self.mainModelView.feedListDetails?.commentDetails?.list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCommentProfileCell") as! FeedCommentProfileCell
            cell.selectionStyle = .none
            cell.delegate = self
            cell.heightViewMap.constant = 0
            cell.isLiked = self.mainModelView.feedListDetails?.likeDetails?.isLiked ?? false
            cell.setupUI(model: (self.mainModelView.feedDetails)!)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCommentCell") as! FeedCommentCell
            cell.selectionStyle = .none
            let comment = self.mainModelView.feedListDetails?.commentDetails?.list![indexPath.row]
            cell.setupUI(model: comment!)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func FeedsLikeActionDidFinish(tag: Int) {
        self.mainModelView.feedDetails?.likedDetail?.isLiked = !(self.mainModelView.feedDetails?.likedDetail?.isLiked ?? false)
        let id = getUserDetail().data?.user?.id?.stringValue
        if (self.mainModelView.feedDetails?.likedDetail?.isLiked)! {
            self.mainModelView.feedDetails?.likedDetail?.userIds?.append(id!)
            let dict: NSDictionary = ["id":getUserDetail().data?.user?.id ?? 0, "photo":getUserDetail().data?.user?.photo ?? ""]
            var likeImage = JSON(dict)
            self.mainModelView.feedDetails?.likedDetail?.images?.append(LikedImages(JSON: likeImage.dictionaryObject!)!)
        }
        else {
            for (index, data) in (self.mainModelView.feedDetails?.likedDetail?.userIds?.enumerated())! {
                if data == id {
                    self.mainModelView.feedDetails?.likedDetail?.userIds?.remove(at: index)
                }
            }
            
            for (index, data) in (self.mainModelView.feedDetails?.likedDetail?.images?.enumerated())! {
                if data.id?.stringValue == id {
                    self.mainModelView.feedDetails?.likedDetail?.images?.remove(at: index)
                }
            }
        }
        
        UIView.setAnimationsEnabled(false)
        self.mainView.tableView.beginUpdates()
        self.mainView.tableView.reloadSections([0], with: .none)
        self.mainView.tableView.endUpdates()
        
        self.mainModelView.apiCallFeedLike(feedId: (self.mainModelView.feedDetails?.id?.intValue)!)
    }
    
    func FeedsCommentActionDidFinish(tag: Int) {
        
    }
    
    func FeedsShareActionDidFinish(tag: Int) {
        
    }
}


