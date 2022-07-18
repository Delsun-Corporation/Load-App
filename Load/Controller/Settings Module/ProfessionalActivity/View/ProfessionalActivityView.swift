//
//  ProfessionalActivityView.swift
//  Load
//
//  Created by Haresh Bhai on 03/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class ProfessionalActivityView: UIView {
    
    //MARK: - @IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblSelectionMsg: UILabel!
    
    var isViewValid = true
    
    //MARK: - Functions
    func setupUI(theController:ProfessionalActivityVC) {
        self.tableView.register(UINib(nibName: "FilterActivityCell", bundle: nil), forCellReuseIdentifier: "FilterActivityCell")
        let data = (GetAllData?.data?.specializations)
        let array = data?.sorted(by: { (data1, data2) -> Bool in
            guard let name1 = data1.name,
                  let name2 = data2.name else {
                isViewValid = false
                return false
            }
            return name1.lowercased() < name2.lowercased()
        })
        let firstLetters = array?.map { String($0.name!.first!) } ?? [String]()
        for char in removeDublicate(array: firstLetters) {
            let filter = array?.filter { (value) -> Bool in
                guard let name = value.name else {
                    isViewValid = false
                    return false
                }
                return name.first == char.first
            }
            let model = FilterActivityModelClass()
            model.title = char
            model.activity = filter
            theController.mainModelView.filterArray.append(model)
        }
        self.tableView.dataSource = theController
        self.tableView.delegate = theController
        self.tableView.reloadData()
        
        self.lblSelectionMsg.text = getCommonString(key: "Select_up_to_3_activities_key")
        self.lblSelectionMsg.font = themeFont(size: 12, fontname: .ProximaNovaRegular)
        self.lblSelectionMsg.textColor = .appthemeBlackColor
        
    }
    
    func removeDublicate(array: [String]) -> [String] {
        var answer1:[String] = []
        for i in array {
            if !answer1.contains(i) {
                answer1.append(i)
            }}
        return answer1
    }
}
