//
//  TargetedMusclesListVC.swift
//  Load
//
//  Created by Christopher Kevin on 29/08/22.
//  Copyright © 2022 Haresh Bhai. All rights reserved.
//

import UIKit

class TargetedMusclesListVC: UIViewController {
    
    // MARK: - Variables
    
    lazy var mainView: TargetedMusclesListView = { [unowned self] in
        return self.view as! TargetedMusclesListView
    }()
    
    lazy var mainModelView: TargetedMusclesListViewModel = {
        return TargetedMusclesListViewModel(theController: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.setupUI(theController: self)
        mainModelView.setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpNavigationBarTitle(strTitle: self.mainModelView.title, color: UIColor.black)
        self.navigationController?.setWhiteColor()
    }
    
    //MARK:- @IBAction
    @IBAction func btnCloseClicked(_ sender: Any) {
        mainModelView.saveSelection()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnEditClicked(_ sender: Any) {
        var dataEntry: [MultiSelectionDataEntry] = [MultiSelectionDataEntry]()
        guard let targetedMusclesArray = GetAllData?.data?.targetedMuscles else { return }
        for data in targetedMusclesArray {
            let isSelected = self.mainModelView.selectedTargetedMusclesId.contains((data.id) as! Int)
            dataEntry.append(MultiSelectionDataEntry(id: (data.id?.stringValue ?? "0"), title: data.name ?? "", isSelected: isSelected))
        }
        
        let obj = AppStoryboard.Library.instance.instantiateViewController(withIdentifier: "MultiSelectionVC") as! MultiSelectionVC
        obj.mainModelView.delegate = self
        obj.mainModelView.data = dataEntry
        obj.mainModelView.title = getCommonString(key: "Select_Targeted_Muscles_key")
        
        let nav = UINavigationController(rootViewController: obj)
        nav.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(nav, animated: true, completion: nil)
    }
}

extension TargetedMusclesListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainModelView.sortedSelectedTargetedMusclesName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TargetedMusclesListCell") as! TargetedMusclesListCell
        
        cell.setupUI(text: mainModelView.sortedSelectedTargetedMusclesName[indexPath.row])
        
        return cell
    }
}

extension TargetedMusclesListVC: MultiSelectionDelegate {
    func dismissPopupScreen() {}
    
    func MultiSelectionDidFinish(selectedData: [MultiSelectionDataEntry]) {
        
        var selectedTargetedMusclesId: [Int] = []
        
        for model in selectedData {
            guard let modelId = Int(model.id) else { return }
            selectedTargetedMusclesId.append(modelId)
        }
        mainModelView.selectedTargetedMusclesId = selectedTargetedMusclesId
        mainModelView.setupViewModel()
            
        mainView.tableView.reloadData()
    }
}
