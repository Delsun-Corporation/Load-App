//
//  RegionSelectionView.swift
//  Load
//
//  Created by Haresh Bhai on 26/11/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class TypesOfTrainingSelectionView: UIView {

    //MARK: - @IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Functions
    func setupUI(theController:TypesOfTrainingSelectionVC) {
        self.tableView.register(UINib(nibName: "RegionSelectionCell", bundle: nil), forCellReuseIdentifier: "RegionSelectionCell")
        
        let data = GetAllData?.data?.trainingTypes ?? []
        let array = data.sorted(by: { (data1, data2) -> Bool in
            return (data1.sequence?.intValue ?? 0) < (data2.sequence?.intValue ?? 0)
        })
        theController.mainModelView.filterArray = array
        
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
