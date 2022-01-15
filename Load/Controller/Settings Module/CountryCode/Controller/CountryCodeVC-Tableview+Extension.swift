//
//  CountryCodeVC-Tableview+Extension.swift
//  Load
//
//  Created by Haresh Bhai on 25/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol CountryCodeDelegate: class {
    func CountryCodeDidFinish(data : JSON)
}

extension CountryCodeVC: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    //MARK:- TextField Delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            print(updatedText)
            if updatedText == "" {
                self.mainModelView.isFiltered = false
                self.mainView.tableView.reloadData()
            }
            else {
                self.mainModelView.isFiltered = true
                let jobj = self.mainModelView.countryList.arrayValue
                if !jobj.isEmpty {
                    let j = jobj.filter({ (json) -> Bool in
                        return json["name"].stringValue.lowercased().contains(updatedText.lowercased()) || json["dial_code"].stringValue.lowercased().contains(updatedText.lowercased()) ||
                            json["code"].stringValue.lowercased().contains(updatedText.lowercased())
                    })
                    self.mainModelView.filteredCountryList.arrayObject = j
                    self.mainView.tableView.reloadData()
                }
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK:- TableView Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mainModelView.isFiltered ? self.mainModelView.filteredCountryList.count : self.mainModelView.countryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CountryCodeCell = self.mainView.tableView.dequeueReusableCell(withIdentifier: "CountryCodeCell") as! CountryCodeCell
        cell.selectionStyle = .none
        let data = self.mainModelView.isFiltered ? self.mainModelView.filteredCountryList[indexPath.row] : self.mainModelView.countryList[indexPath.row]
        cell.imgCountry.image = UIImage(named: data["code"].string ?? "")
        cell.lblCode.text = data["dial_code"].string ?? ""
        let str1 = (data["name"].string ?? "") + " ("
        let str2 = (data["code"].string ?? "") + ")"
        cell.lblCountry.text =  str1 + str2
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.mainModelView.isFiltered ? self.mainModelView.filteredCountryList[indexPath.row] : self.mainModelView.countryList[indexPath.row]
        self.mainModelView.delegate?.CountryCodeDidFinish(data: data)
        self.dismiss(animated: false, completion: nil)
    }
}
