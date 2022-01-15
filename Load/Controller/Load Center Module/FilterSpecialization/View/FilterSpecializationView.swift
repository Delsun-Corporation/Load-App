//
//  FilterSpecializationView.swift
//  Load
//
//  Created by Haresh Bhai on 17/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class FilterSpecializationView: UIView {

    //MARK: - @IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Functions
    func setupUI(theController:FilterSpecializationVC) {
        self.tableView.register(UINib(nibName: "FilterSpecializationCell", bundle: nil), forCellReuseIdentifier: "FilterSpecializationCell")
        let data = (GetAllData?.data?.specializations)!
        let array = data.sorted(by: { (data1, data2) -> Bool in
            return data1.name!.lowercased() < data2.name!.lowercased()
        })
        let firstLetters = array.map { String($0.name!.first!) }
        for char in removeDublicate(array: firstLetters) {
            let filter = array.filter { (value) -> Bool in
                return value.name!.first == char.first
            }
            let model = FilterSpecializationsModelClass()
            model.title = char
            model.specializations = filter
            theController.mainModelView.filterArray.append(model)
        }
        self.tableView.dataSource = theController
        self.tableView.delegate = theController
        self.tableView.reloadData()
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
