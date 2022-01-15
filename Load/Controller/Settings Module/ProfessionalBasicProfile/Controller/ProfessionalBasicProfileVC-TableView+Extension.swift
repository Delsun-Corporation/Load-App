//
//  ProfessionalBasicProfileVC-TableView+Extension.swift
//  Load
//
//  Created by Haresh Bhai on 02/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

extension ProfessionalBasicProfileVC:UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mainModelView.searchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceResultTableViewCell") as! PlaceResultTableViewCell
        cell.setTheData(theData: self.mainModelView.searchResult[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchData = self.mainModelView.searchResult[indexPath.row]
        self.mainModelView.fetchLatLongFrom(predication: searchData)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.mainModelView.clearButton.isHidden = textField.text == "" ? true : false
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
}
