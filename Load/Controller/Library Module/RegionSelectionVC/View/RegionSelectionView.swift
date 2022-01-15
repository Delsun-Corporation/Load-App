//
//  RegionSelectionView.swift
//  Load
//
//  Created by Haresh Bhai on 26/11/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class RegionSelectionView: UIView {

    //MARK: - @IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Functions
    func setupUI(theController:RegionSelectionVC) {
        self.tableView.register(UINib(nibName: "RegionSelectionCell", bundle: nil), forCellReuseIdentifier: "RegionSelectionCell")
        
        /*let data = (GetAllData?.data?.regions)!.filter { (model) -> Bool in
            return model.parentId == theController.mainModelView.selectedId
        }
        let array = data.sorted(by: { (data1, data2) -> Bool in
            return data1.name!.lowercased() < data2.name!.lowercased()
        })
        
        let filter = array.filter { (value) -> Bool in
            let type = theController.currentIndex == 0 ? "front" : "back"
            return value.type?.lowercased() == type  && value.is_region == 1
        }
        
        let arraySequence = filter.sorted { (activity1, activity2) -> Bool in
            
            return activity1.sequence ?? 0 < activity2.sequence ?? 0
        }
        
        let model = RegionSelectionModelClass()
        model.title = ""
        model.activity = arraySequence*/
            
        let model = theController.mainModelView.sortedRegionSelectionModel
        theController.mainModelView.filterArray.append(model)
        
        //Last changes
        //May be sectional
        /*
        let firstLetters = array.map { String($0.name!.first!) }
        for (index,char) in removeDublicate(array: firstLetters).enumerated() {
            let filter = array.filter { (value) -> Bool in
                let type = theController.currentIndex == 0 ? "front" : "back"
                return value.name!.first == char.first && value.type?.lowercased() == type && value.is_region == 1
            }
            
            let arraySequence = filter.sorted { (activity1, activity2) -> Bool in
                return activity1.sequence ?? 0 < activity2.sequence ?? 0
            }
            
            let model = RegionSelectionModelClass()
            model.title = char
            model.activity = arraySequence
                
            theController.mainModelView.filterArray.append(model)
        }
        */
//        =====================
        
        /*
        let model = RegionSelectionModelClass()
        model.title = ""
        model.activity = arraySequence

        theController.mainModelView.filterArray.append(model)
        */
 
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
