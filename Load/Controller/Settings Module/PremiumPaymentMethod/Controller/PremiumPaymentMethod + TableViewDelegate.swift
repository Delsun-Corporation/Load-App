//
//  PremiumPaymentMethod + TableViewDelegate.swift
//  Load
//
//  Created by Yash on 04/06/21.
//  Copyright © 2021 Haresh Bhai. All rights reserved.
//

import Foundation
import MGSwipeTableCell


extension PremiumPaymentMethodVc: UITableViewDelegate, UITableViewDataSource,AutoTopUpBillingCardDelegate {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + self.mainModelView.cardNewDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell: AutoTopUpBillingTitleCell = self.mainView.tableView.dequeueReusableCell(withIdentifier: "AutoTopUpBillingTitleCell") as! AutoTopUpBillingTitleCell
            cell.selectionStyle = .none
            cell.tag = indexPath.section
            cell.setupUI()
            cell.imgRight.isHidden = self.mainModelView.cardNewDetails.count == 0 ? false : true
            return cell
        }
        else {
            let cell: AutoTopUpBillingCardCell = self.mainView.tableView.dequeueReusableCell(withIdentifier: "AutoTopUpBillingCardCell") as! AutoTopUpBillingCardCell
            cell.selectionStyle = .none
            cell.tag = indexPath.section
            cell.btnCell.tag = indexPath.row
            cell.delegateAutoBilling = self
            let model = self.mainModelView.cardNewDetails[indexPath.row - 1]
            let name = (model.firstName ?? "") + " " + (model.lastName ?? "")
            let number = model.number?.replace(target: "x", withString: "") ?? ""
            let month = model.expireMonth ?? ""
            let year = model.expireYear ?? ""
            let desc = "Ending  in \(number), Expire on " + month + "/" + year
            cell.setupUI(indexPath: indexPath, title: name, text: desc, placeHolder: "")
            cell.imgChecked.isHidden = self.mainModelView.defaultCard != model.id
            
            cell.rightButtons = [MGSwipeButton(title: "", icon: UIImage(named:"ic_delete_width"), backgroundColor: UIColor.appthemeOffRedColor, callback: { (MGCell) -> Bool in
                print("Delete API call here")
                return false
            })]

            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = PremiumHeaderView.instanceFromNib() as! PremiumHeaderView
        view.setupFont()
        view.lblTitle.text = getCommonString(key: "Payment_Method_key").uppercased()
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 83))
        view.addSubview(self.mainView.vwFooter)
        return view
    }
    
    func AutoTopUpBillingCardButton(section: Int, row: Int) {
        self.mainModelView.defaultCard = self.mainModelView.cardNewDetails[row - 1].id ?? ""
        UIView.performWithoutAnimation {
            let content = self.mainView.tableView.contentOffset
            self.mainView.tableView.reloadData {
                self.mainView.tableView.setContentOffset(content, animated: false)
            }
        }
    }
}
