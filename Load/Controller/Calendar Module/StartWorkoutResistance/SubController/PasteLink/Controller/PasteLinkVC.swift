//
//  PasteLinkVC.swift
//  Load
//
//  Created by iMac on 01/02/21.
//  Copyright © 2021 Haresh Bhai. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import AlamofireSwiftyJSON

class PasteLinkVC: UIViewController {

    //MARK: - Outlet
    
    @IBOutlet weak var lblPasteLink: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var txtLink: CustomTextField!
    
    //MARK: - Variable
    var isValidURL = false
    var handlerAddedLink:(String) -> Void = {_ in}
    
    var strCommonLibraryId = 0
    var strLibraryId = 0
 
    //MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblPasteLink.textColor = UIColor.black
        lblPasteLink.font = themeFont(size: 18, fontname: .ProximaNovaRegular)
        lblPasteLink.text = getCommonString(key: "Paste_video_URL_here_key")
        
        txtLink.textColor = UIColor.black
        txtLink.font = themeFont(size: 18, fontname: .ProximaNovaRegular)
        txtLink.placeholder = getCommonString(key: "Provide_the_exercise_URL_link_key")
        txtLink.delegate = self
        
        txtLink.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnCloseTapped(_ sender: UIButton) {
        
        self.dismiss(animated: true) {
            self.view.endEditing(true)
        }
    }
    
}

//MARK: - TextField delegate

extension PasteLinkVC: UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        txtLink.placeholder = ""
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if txtLink.text?.toTrim() == ""{
            txtLink.text = ""
            txtLink.placeholder = getCommonString(key: "Provide_the_exercise_URL_link_key")
        }
        
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if !self.isValidURL && (textField.text?.toTrim() != ""){
            makeToast(strMessage: getCommonString(key: "Please_input_links_from_Youtube_or_Vimeo_key"))
            return true
        }
        
        if textField.text?.toTrim() == ""{
            
        }else{
            
            if self.isValidURL{
                
                if self.strLibraryId == 0{
                    self.apiCallCommonUpdateLibrary(txtData: textField.text?.toTrim() ?? "")
                }else{
                    self.apiCallCustomExerciseUpdateLink(txtData: textField.text?.toTrim() ?? "")
                }
                
            }else{
                
                if self.strLibraryId == 0{
                    self.apiCallCommonUpdateLibrary(txtData: "")
                }else{
                    self.apiCallCustomExerciseUpdateLink(txtData: "")
                }
            }
        }

        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if textField.text?.toTrim() != "" && textField.text?.count ?? 0 > 18{
            
            if textField.text?.lowercased().contains("youtube".lowercased()) ?? false{
                
                if textField.text?.count ?? 0 > 31{
                    print("check youtube url")
                    
                    self.checkYouTubeURLWithAPI(urlString: textField.text?.toTrim() ?? ""){ [weak self] json in
                        
                        if json == nil{
                            
                            self?.isValidURL = false
                        }else{
                            self?.isValidURL = true
                        }
                        
                    }
                
                }else{
                    self.isValidURL = false
                }
                
            }else if textField.text?.lowercased().contains("vimeo".lowercased()) ?? false{
                
                if textField.text?.count ?? 0 > 18{
                    print("check vimeo url")
                    self.checkVimeoURLWithAPI(urlString: textField.text?.toTrim() ?? ""){ [weak self] json in
                        
                        if json == nil{
                            self?.isValidURL = false
                        }else{
                            self?.isValidURL = true
                        }
                        
                    }
                }
                
            }else{
               // makeToast(strMessage: getCommonString(key: "Please_input_links_from_Youtube_or_Vimeo_key"))
            }
        }else{
            self.isValidURL = false
        
        }
    }
    
}

//MARK: - API calling for save exerciseLink

extension PasteLinkVC{
    
    func apiCallCommonUpdateLibrary(txtData:String) {
        let param = [
            "common_libraries_id": self.strCommonLibraryId,
            "exercise_link" : self.txtLink.text,
            ] as [String : Any]
        print(JSON(param))
        
        ApiManager.shared.MakePostAPI(name: CREATE_UPDATE_COMMON_LIBRARY_DETAILS, params: param as [String : Any], vc: self, isAuth:false) { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let success = json.getBool(key: .success)
                let message = json.getString(key: .message)
                
                if success {
                    self.handlerAddedLink(txtData)
                    self.dismiss(animated: true, completion: nil)
                }
                else {
                    makeToast(strMessage: message)
                }
            }
        }
    }
    
    func apiCallCustomExerciseUpdateLink(txtData:String) {
        
        let param = [
                   "exercise_link": txtData,
                   ] as [String : Any]
        print(JSON(param))
        
        ApiManager.shared.MakePutAPI(name: LIBRARY_UPDATE_CUSTOM_LIBRARY_EXERCISE_LINK + "/" + "\(self.strLibraryId)", params: param as [String : Any], vc: self, isAuth:false) { (response, error) in
            if response != nil {
                let json = JSON(response!)
                let success = json.getBool(key: .success)
                let message = json.getString(key: .message)
                
                if success {
                    self.handlerAddedLink(txtData)
                    self.dismiss(animated: true, completion: nil)
                }
                else {
                    makeToast(strMessage: message)
                }
            }
        }
    }

}
