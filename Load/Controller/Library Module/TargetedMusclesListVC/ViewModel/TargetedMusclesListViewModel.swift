//
//  TargetedMusclesListViewModel.swift
//  Load
//
//  Created by Christopher Kevin on 29/08/22.
//  Copyright © 2022 Haresh Bhai. All rights reserved.
//

import Foundation

class TargetedMusclesListViewModel {
    // MARK: Variables
    weak var theController: TargetedMusclesListVC?
    var title: String = ""
    var isEditable: Bool = true
    var selectedTargetedMusclesId: [Int] = []
    var sortedSelectedTargetedMusclesName: [String] = []
    var updateTargetedMusclesCallback: (([String], [Int]) -> ())?
    
    init(theController: TargetedMusclesListVC) {
        self.theController = theController
    }
    
    func setupViewModel() {
        guard let targetedMusclesList = GetAllData?.data?.targetedMuscles else { return }
        
        sortedSelectedTargetedMusclesName = targetedMusclesList
            .filter({ currentObject in
                (selectedTargetedMusclesId
                    .contains(where: { $0 == currentObject.id?.intValue }))
            })
            .map { (object: TargetedMuscles) -> String in
                object.name ?? ""
            }
            .sorted { $0 < $1 }
    }
    
    func saveSelection() {
        guard let updateTargetedMusclesCallback = updateTargetedMusclesCallback else {
            return
        }
        updateTargetedMusclesCallback(sortedSelectedTargetedMusclesName, selectedTargetedMusclesId)
    }
}
