//
//  RegionSelectionViewModel.swift
//  Load
//
//  Created by iMac on 31/01/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import Foundation
import CarbonKit

class RegionSelectionMainViewModel {
    
    //MARK:- Variables
    fileprivate weak var theController:RegionSelectionMainVc!
    var filterArray:[RegionSelectionModelClass] = [RegionSelectionModelClass]()
    
    
    var selectedFrontArray: [Int] = [Int]()
    var selectedFrontSubBodyPartIdArray:[Int] = [Int]()
    var selectedFrontNameArray: [String] = [String]()
    
    var selectedBackArray: [Int] = [Int]()
    var selectedBackSubBodyPartIdArray:[Int] = [Int]()
    var selectedBackNameArray: [String] = [String]()
    
    var selectedArray:[Int] = [Int]()
    var selectedSubBodyPartIdArray:[Int] = [Int]()
    var selectedNameArray:[String] = [String]()
    var selectedId:NSNumber?
    var isHeaderHide:Bool = false

    var items = NSArray()
    var carbonTabSwipeNavigation = CarbonTabSwipeNavigation()
    
    weak var delegate:RegionSelectionSelectedDelegate?
    
    init(theController:RegionSelectionMainVc) {
        self.theController = theController
    }
    
    func showImages() {
        let view = (self.theController.view as? RegionSelectionMainView)
        for view in view?.viewImage.subviews ?? [] {
            view.removeFromSuperview()
        }
        
        let filter = GetAllData?.data?.regions?.filter({ (model) -> Bool in
            return self.selectedArray.contains(model.id?.intValue ?? 0)
        })
        
        for images in filter ?? [] {
            
            if images.image != "" {
                let imageView = UIImageView()
                imageView.contentMode = .scaleAspectFit
                imageView.frame = CGRect(x: 0, y: 0, width: (view?.viewImage.bounds.width ?? 0), height: (view?.viewImage.bounds.height ?? 0))
                view?.viewImage.addSubview(imageView)
                
                if self.selectedArray.first == images.id?.intValue {
                    imageView.sd_setImage(with: images.image?.toURL(), completed: nil)
                }
                else {
                    imageView.sd_setImage(with: images.secondaryImage?.toURL(), completed: nil)
                }
            }
        }
    }
    
    
    func passSortedArray(index:Int) -> RegionSelectionModelClass{
        
        let data = (GetAllData?.data?.regions)!.filter { (model) -> Bool in
            
            // For power region, show all body parts
            if let selectedId = selectedId, selectedId == 0 {
                return true
            } else {
                return model.parentId == self.selectedId
            }
        }
        
        let array = data.sorted(by: { (data1, data2) -> Bool in
            return data1.name!.lowercased() < data2.name!.lowercased()
        })
        
        let filter = array.filter { (value) -> Bool in
            let type = index == 0 ? "front" : "back"
            return value.type?.lowercased() == type  && value.is_region == 1
        }
        
        let arraySequence = filter.sorted { (activity1, activity2) -> Bool in
            return activity1.sequence ?? 0 < activity2.sequence ?? 0
        }
        
        let model = RegionSelectionModelClass()
        model.title = ""
        model.activity = arraySequence
        
        return model
    }
    
}
