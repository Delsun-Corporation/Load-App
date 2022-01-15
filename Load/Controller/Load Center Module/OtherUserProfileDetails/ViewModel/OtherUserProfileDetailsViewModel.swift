//
//  OtherUserProfileDetailsViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 01/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class OtherUserProfileDetailsViewModel {

    //MARK:- Variables
    fileprivate weak var theController:OtherUserProfileDetailsVC!
    let headerArray: [String] = ["Introduction", "Specialized Activities", "Academic and Certifications", "Experience and Achievements", "Session Details","", "Client Requirement", "Similar coaches in the area"]
    var isLoaded:Bool = false
    var profileDetails: OtherUserDetailsModelClass?
    var numberOfLinesDescription: Int = 4
    var isCredentioalReadMore: Bool = false

    init(theController:OtherUserProfileDetailsVC) {
        self.theController = theController
    }
    
    func setupUI() {
        DispatchQueue.global().sync {
            let view = (self.theController.view as? OtherUserProfileDetailsView)
            view?.tableView.reloadData {
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    view?.delegate?.ProfileViewDidFinish(height: (view?.tableView.contentSize.height)!)
                }
                self.isLoaded = true
            }
        }
    }    
}
