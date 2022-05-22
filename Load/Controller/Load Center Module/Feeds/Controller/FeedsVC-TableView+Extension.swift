//
//  FeedsVC_Ta.swift
//  Load
//
//  Created by Haresh Bhai on 20/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SwiftyJSON

extension FeedsVC: UITableViewDelegate, UITableViewDataSource, FeedsActionDelegate {
   
    //MARK:- TableView    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.mainView.tableView {
            return self.mainModelView.feedDetails?.list?.count ?? 0
        }
        else {
            return self.mainModelView.feedSearchDetails?.list?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.mainView.tableView {
            let cell: CardioFeedsCell = self.mainView.tableView.dequeueReusableCell(withIdentifier: "CardioFeedsCell") as! CardioFeedsCell
            cell.tag = indexPath.row
            cell.selectionStyle = .none
            cell.tag = indexPath.row
            cell.delegate = self
            cell.heightViewMap.constant = 0
            cell.setupUI(model: (self.mainModelView.feedDetails?.list![indexPath.row])!)
            return cell
        }
        else {
            let cell: FeedProfileSearchCell = self.mainView.tableViewSearch.dequeueReusableCell(withIdentifier: "FeedProfileSearchCell") as! FeedProfileSearchCell
            cell.tag = indexPath.row
            cell.selectionStyle = .none
            cell.tag = indexPath.row
            let model = self.mainModelView.feedSearchDetails?.list![indexPath.row]
            cell.setupUI(model: model!)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.mainView.tableView {

        }
        else {
            let model = self.mainModelView.feedSearchDetails?.list![indexPath.row]
            let obj = AppStoryboard.LoadCenter.instance.instantiateViewController(withIdentifier: "OtherUserProfileVC") as! OtherUserProfileVC
            obj.mainModelView.userId = (model!.id?.stringValue)!
            obj.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(obj, animated: true)
        }
    }
    
    func FeedsLikeActionDidFinish(tag: Int) {
        self.mainModelView.feedDetails?.list![tag].likedDetail?.isLiked = !(self.mainModelView.feedDetails?.list![tag].likedDetail?.isLiked ?? false)
        let id = getUserDetail()?.data?.user?.id?.stringValue
        if (self.mainModelView.feedDetails?.list![tag].likedDetail?.isLiked)! {
            self.mainModelView.feedDetails?.list![tag].likedDetail?.userIds?.append(id!)
            let dict: NSDictionary = ["id":getUserDetail()?.data?.user?.id ?? 0, "photo":getUserDetail()?.data?.user?.photo ?? ""]
            var likeImage = JSON(dict)
            self.mainModelView.feedDetails?.list![tag].likedDetail?.images?.append(LikedImages(JSON: likeImage.dictionaryObject!)!)
        }
        else {
            for (index, data) in (self.mainModelView.feedDetails?.list![tag].likedDetail?.userIds?.enumerated())! {
                if data == id {
                    self.mainModelView.feedDetails?.list![tag].likedDetail?.userIds?.remove(at: index)
                }
            }
            
            for (index, data) in (self.mainModelView.feedDetails?.list![tag].likedDetail?.images?.enumerated())! {
                if data.id?.stringValue == id {
                    self.mainModelView.feedDetails?.list![tag].likedDetail?.images?.remove(at: index)
                }
            }
        }
        UIView.setAnimationsEnabled(false)
        self.mainView.tableView.beginUpdates()
        self.mainView.tableView.reloadRows(at: [IndexPath(row: tag, section: 0)], with: .none)
        self.mainView.tableView.endUpdates()
        
        self.mainModelView.apiCallFeedLike(feedId: (self.mainModelView.feedDetails?.list![tag].id?.intValue)!)
    }
    
    func FeedsCommentActionDidFinish(tag: Int) {
        let obj = AppStoryboard.LoadCenter.instance.instantiateViewController(withIdentifier: "FeedCommentVC") as! FeedCommentVC
        obj.mainModelView.feedId = (self.mainModelView.feedDetails?.list![tag].id?.intValue)!
        obj.mainModelView.feedDetails = self.mainModelView.feedDetails?.list![tag]
        obj.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    func FeedsShareActionDidFinish(tag: Int) {
        let text = "This is some text that I want to share."
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        self.present(activityViewController, animated: true, completion: nil)
    }
}
