//
//  LibraryExercisePreviewProgressionsViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 13/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SwiftyJSON

class LibraryExercisePreviewProgressionsViewModel {
    
    //MARK:- Variables
    fileprivate weak var theController:LibraryExercisePreviewProgressionsVC!
    var libraryPreviewModel : LibraryListPreviewModelClass?
    var list: LibraryLogList?
    var graphDetails: [GraphDetailsModelClass] = []
    var selectedDate:Date = Date()
    
    init(theController:LibraryExercisePreviewProgressionsVC) {
        self.theController = theController
    }
    
    func setupUI() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let startDate = dateFormatter.string(from: self.selectedDate.startOfMonth().setTimeZero() ?? Date())
        let endDate = dateFormatter.string(from: self.selectedDate.endOfMonth().setTimeEnd() ?? Date())

        let id = self.list == nil ? (self.libraryPreviewModel?.id?.stringValue ?? "") : "\(self.list?.id ?? 0)"
        self.apiCallLibraryShow(id: id, startDate: startDate, endDate: endDate)
    }
    
    func apiCallLibraryShow(id: String, startDate: String, endDate: String) {
        
        let param = ["start_date" : startDate, "end_date" : endDate] as [String : Any]
        print(param)
        
        ApiManager.shared.MakePostAPI(name: LIBRARY_GRAPH_DETAILS + "/" + id, params: param as [String : Any], vc: self.theController, isAuth:false) { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let success = json.getBool(key: .success)
                if success {
                    self.graphDetails = []
                    let data = json.getArray(key: .data)
                    print(data)
                    for dataValue in data {
                        let model = GraphDetailsModelClass(JSON: JSON(dataValue).dictionaryObject!)
                        self.graphDetails.append(model!)
                    }
                    
                    var total: [Int] = []
                    
                    for (index, data) in self.graphDetails.enumerated() {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "d"
                        let date = data.date?.convertDateFormater()
                        let strDate = formatter.string(from: date!)
                        
                        total.append(data.totalVolume?.intValue ?? 0)
                        self.graphDetails[index].dateConv = strDate
                    }
                    
                    let modelFilter = self.graphDetails.sorted(by: { (model1, model2) -> Bool in
                        return model1.dateConv!.compare(model2.dateConv ?? "") == ComparisonResult.orderedAscending
                    })
                    self.graphDetails = modelFilter
                    let view = (self.theController.view as? LibraryExercisePreviewProgressionsView)
                    view?.showDetails(model: self.graphDetails, theController: self.theController)
                    
                    view?.lblLatestValue.text = (self.graphDetails.last?.totalVolume?.stringValue ?? "") + " kg"
                    view?.lblHighestValue.text = "\(total.max() ?? 0)" + " kg"
                }
                else {
                    let view = (self.theController.view as? LibraryExerciseListMainView)
                    view?.tableView.reloadData()
                }
            }
        }
    }
}
