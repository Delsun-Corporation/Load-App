//
//  CredentialsView.swift
//  Load
//
//  Created by Haresh Bhai on 10/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class CredentialsViewModel {

    //MARK:- Variables
    fileprivate weak var theController:CredentialsVC!
    let titleArray: [String] = ["Awarding Institution", "Course of study / Qualification"]
    
    var textArray: [[String]] = [["", ""]]
    var CredentialsArray: NSMutableArray = NSMutableArray()

    weak var delegate: CredentialsArrayDelegate?
    
    //MARK:- Functions
    init(theController:CredentialsVC) {
        self.theController = theController
    }
    
    func setupUI() {
        self.showDetails()
    }
    
    func showDetails() {
        var arrayData:[[String]] = []

        for data in self.CredentialsArray {
            var arrayString:[String] = []
            let awardingInstitution:String = (data as? NSDictionary)?.value(forKey: "AwardingInstitution") as! String
            let courseOfStudy:String = (data as? NSDictionary)?.value(forKey: "CourseOfStudy") as! String
            arrayString.append(awardingInstitution)
            arrayString.append(courseOfStudy)
            arrayData.append(arrayString)
        }
        if arrayData.count != 0 {
            self.textArray = arrayData
        }
        let view = (self.theController.view as? CredentialsView)
        view?.tableView.reloadData()
    }
    
    func validateDetails() {
        var isEmpty:Bool = false
        let array: NSMutableArray = NSMutableArray()
        for data in self.textArray {
            if data[0].toTrim() == "" {
                isEmpty = true
            }
            if data[1].toTrim() == "" {
                isEmpty = true
            }
            let dict: NSDictionary = ["AwardingInstitution":data[0].toTrim(), "CourseOfStudy":data[1].toTrim()]
            array.add(dict)
        }
        if isEmpty {
            makeToast(strMessage: getCommonString(key: "Please_fill_all_details_key"))
        }
        else {
            self.theController.navigationController?.popViewController(animated: true)
            self.delegate?.CredentialsArrayFinish(array: array)
        }
    }
    
    func isEmptyData() -> Bool {
        var isEmpty:Bool = false
        for data in self.textArray {
            if data[0].toTrim() == "" {
                isEmpty = true
            }
            if data[1].toTrim() == "" {
                isEmpty = true
            }
        }
        return isEmpty
    }
}
