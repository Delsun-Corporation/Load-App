//
//  OtherUserProfileDetailsVC-TableView+Extension.swift
//  Load
//
//  Created by Haresh Bhai on 01/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

extension OtherUserProfileDetailsVC:UITableViewDataSource, UITableViewDelegate, ProfileReloadDelegate, ProfileHeaderDelegate, ProfileUserProfileDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.mainModelView.headerArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 5 {
            return 15
        } else {
            return 55
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = ProfileHeaderView.instanceFromNib() as? ProfileHeaderView
        view?.btnSelect.tag = section
        view?.delegate = self
        view?.btnSelect.isHidden = section != 5
        if section == 6 || section == 7 {
            view?.imgArrow.isHidden = false
        }
        else {
            view?.imgArrow.isHidden = true
        }
        if section != 6 {
            view?.lblTitle.font = themeFont(size: 16, fontname: .ProximaNovaBold)
        }
        else {
            view?.lblTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        }
        view?.setupUI(title: self.mainModelView.headerArray[section])
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = ProfileFooterView.instanceFromNib() as? ProfileFooterView
        view?.setupUI()
        return view
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.mainView.delegate?.ProfileViewDidFinish(height: tableView.contentSize.height)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.mainModelView.profileDetails
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "IntroductionCell") as! IntroductionCell
            cell.selectionStyle = .none
            cell.delegate = self
            cell.btnReadMore.tag = indexPath.section
            cell.lblDescription.text = self.mainModelView.profileDetails?.introduction ?? "Description Not Found"
            cell.setLines(setValue: self.mainModelView.numberOfLinesDescription, calculatedLines: cell.lblDescription.calculateMaxLines())
            return cell
        }
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileDescriptionCell") as! ProfileDescriptionCell
            cell.selectionStyle = .none
            cell.setupUI(model: (model?.specializationDetails)!)
            return cell
        }
        else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "IntroductionCell") as! IntroductionCell
            cell.selectionStyle = .none
            var str = ""
            if  model?.academicCredentials == nil || (model?.academicCredentials?.count ?? 0) <= 2 || self.mainModelView.isCredentioalReadMore == true {
                cell.hideReadMore()
                cell.lblDescription.numberOfLines = 0
            }
            else {
                cell.lblDescription.numberOfLines = 4
            }
            
            for data in model?.academicCredentials ?? [] {
                str += (data.awardingInstitution ?? "") + "\n"
                str += (data.courseOfStudy ?? "") + "\n"
            }
            
            cell.btnReadMore.tag = indexPath.section
            cell.delegate = self
            cell.lblDescription.text = str
            
            return cell
        }
        else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileDescriptionCell") as! ProfileDescriptionCell
            cell.selectionStyle = .none
            cell.lblDescription.text = model?.experienceAndAchievements ?? "Experience and achievements Not Found"
            return cell
        }
        else if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileDescriptionCell") as! ProfileDescriptionCell
            cell.selectionStyle = .none
            
            var strAmeinities = "-"
            
            for data in model?.amenities ?? [] {
                strAmeinities += (data.name ?? "") + ", "
            }
            
            if strAmeinities.count >= 2{
                strAmeinities.removeLast(2)
            }
            
            //Session type remain to add from backend
            //number of person remain to check
            
            let formattedString = NSMutableAttributedString()
            formattedString
                .bold("Duration" + "\n", font: themeFont(size: 12, fontname: .ProximaNovaBold))
                .normal12("\(getSecondsToHoursMinutesSeconds(seconds: model?.sessionDuration?.intValue ?? 0))" + "\n\n", font: themeFont(size: 14, fontname: .ProximaNovaRegular))
                .bold("Session types" + "\n", font: themeFont(size: 12, fontname: .ProximaNovaBold))
                .normal12("\(model?.perMultipleSessionRate?.stringValue ?? "") sessions" + "\n\n", font: themeFont(size: 14, fontname: .ProximaNovaRegular))
                .bold("Maximum client per sessions" + "\n", font: themeFont(size: 12, fontname: .ProximaNovaBold))
                .normal12("\(model?.sessionMaximumClients?.stringValue ?? "") persons" + "\n\n", font: themeFont(size: 14, fontname: .ProximaNovaRegular))
                .bold("Amenities" + "\n", font: themeFont(size: 12, fontname: .ProximaNovaBold))
                .normal12("\(strAmeinities)" + "", font: themeFont(size: 14, fontname: .ProximaNovaRegular))
            cell.lblDescription.attributedText = formattedString
            
//            cell.lblDescription.text = "Duration\n60 Minutes\n\nPackages options\n1 or 10 sessions\n\nMaximum client per sessions\n1 persons\n\nPayment options\nPaypal , Wallet\n\nCancellation policy\nStrict"
            return cell
        }
        else if indexPath.section == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileDescriptionCell") as! ProfileDescriptionCell
            cell.selectionStyle = .none
            cell.bottomHeight.constant = 0
            let formattedString = NSMutableAttributedString()
            formattedString
                .bold("cancellation policy" + "\n", font: themeFont(size: 12, fontname: .ProximaNovaBold))
                .normal12("Strict" + "\n\n", font: themeFont(size: 14, fontname: .ProximaNovaRegular))
            cell.lblDescription.attributedText = formattedString
            return cell
        }
        else if indexPath.section == 6 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileDescriptionCell") as! ProfileDescriptionCell
            cell.selectionStyle = .none
            cell.bottomHeight.constant = 0
            cell.lblDescription.text = ""
            return cell
        }
        else {
            let cell: ProfileUserListCell = self.mainView.tableView.dequeueReusableCell(withIdentifier: "ProfileUserListCell") as! ProfileUserListCell
            cell.selectionStyle = .none
            cell.tag = indexPath.row
            cell.delegate = self
            cell.setupUI(model: (model?.nearestProfessionalProfile)!)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func DescriptionReload() {
        self.mainModelView.numberOfLinesDescription = 0
        self.mainView.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
    }
    
    func CredentialsReload() {
        self.mainModelView.isCredentioalReadMore = true
        self.mainView.tableView.reloadRows(at: [IndexPath(row: 0, section: 2)], with: .none)
    }
    
    func ProfileHeaderDidFinish(index: Int) {
        if index == 5 {
            let obj = AppStoryboard.LoadCenter.instance.instantiateViewController(withIdentifier:  "ClientRequirementVC") as! ClientRequirementVC
            self.navigationController?.pushViewController(obj, animated: true)
        }
    }
    
    func ProfileUserProfileDidFinish(id: String) {
        let obj = AppStoryboard.LoadCenter.instance.instantiateViewController(withIdentifier: "OtherUserProfileVC") as! OtherUserProfileVC
        obj.mainModelView.userId = id
        obj.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(obj, animated: true)
    }
}


extension UILabel {
    func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
}
