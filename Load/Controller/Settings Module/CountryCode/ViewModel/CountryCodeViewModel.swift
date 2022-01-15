//
//  CountryCodeViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 25/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SwiftyJSON

class CountryCodeViewModel {
    
    //MARK:- Variables
    fileprivate weak var theController:CountryCodeVC!
    var countryList : JSON = JSON()
    var filteredCountryList : JSON = JSON()
    var isFiltered: Bool = false
    weak var delegate: CountryCodeDelegate?
    
    //MARK:- Functions
    init(theController:CountryCodeVC) {
        self.theController = theController
    }
    
    func setupUI() {
        self.getCode()
    }
    
    func getCode() {
        if let path = Bundle.main.path(forResource: "CountryCodes", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                print(JSON(jsonResult))
                countryList = JSON(jsonResult)
                (self.theController.view as? CountryCodeView)?.tableView.reloadData()
            } catch {
                // handle error
            }
        }
    }
}
