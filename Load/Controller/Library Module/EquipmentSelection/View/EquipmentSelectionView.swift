//
//  ProfessionalActivityView.swift
//  Load
//
//  Created by Haresh Bhai on 03/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class EquipmentSelectionView: UIView {
    
    //MARK: - @IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Functions
    func setupUI(theController:EquipmentSelectionVC) {
        self.tableView.register(UINib(nibName: "EquipmentSelectionCell", bundle: nil), forCellReuseIdentifier: "EquipmentSelectionCell")
        let data = (GetAllData?.data?.equipments)!
        
        //anil code letter wise
        /*let array = data.sorted(by: { (data1, data2) -> Bool in
            return data1.name!.lowercased() < data2.name!.lowercased()
        })
        let firstLetters = array.map { String($0.name!.first!) }
        for char in removeDublicate(array: firstLetters) {
            let filter = array.filter { (value) -> Bool in
                return value.name!.first == char.first
            }
            let model = EquipmentsModelClass()
            print("char:\(char)")
            model.title = char
            model.activity = filter
            theController.mainModelView.filterArray.append(model)
        }*/
        
        let model = EquipmentsModelClass()
        model.activity = data
        theController.mainModelView.filterArray.append(model)

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
