//
//  UIViewController+Extension.swift
//  JoeToGo
//
//  Created by Haresh on 22/03/19.
//  Copyright © 2019 Haresh. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import Alamofire
import SwiftyJSON
import CoreLocation
import RxCocoa
import RxSwift


extension UIViewController : NVActivityIndicatorViewable
{
    
    func addDoneButtonOnKeyboard(textfield : UITextField)
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x:0,y: 0,width: UIScreen.main.bounds.width,height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        doneToolbar.barTintColor = UIColor.appthemeRedColor
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem:  UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: getCommonString(key: "Done_key"), style: UIBarButtonItem.Style.done, target: self, action: #selector(doneButtonAction))
        done.tintColor = UIColor.white
        
        let items = NSMutableArray()
        items.add(flexSpace)
        items.add(done)
        
        doneToolbar.items = items as? [UIBarButtonItem]
        doneToolbar.sizeToFit()
        
        textfield.inputAccessoryView = doneToolbar
        
    }
    
    @objc func doneButtonAction()
    {
        self.view.endEditing(true)
    }
    //MARK:- Navigation Bar Setup
    
    func setUpNavigationBarWithTitle(strTitle : String,isRightButtonHidden:Bool)
    {
      
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor.appthemeRedColor
        self.navigationController?.navigationBar.isTranslucent = false
        
       setNavigationShadow()
        
        let HeaderLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 100, height: 35))
        HeaderLabel.isUserInteractionEnabled = false
        HeaderLabel.text = strTitle
        HeaderLabel.textColor = UIColor.white
        HeaderLabel.numberOfLines = 2
        HeaderLabel.textAlignment = .center
        HeaderLabel.font = themeFont(size: 14, fontname: .Regular)
        
        self.navigationItem.titleView = HeaderLabel
        self.navigationItem.hidesBackButton = true
        
        if !isRightButtonHidden
        {
            let rightButton = UIBarButtonItem(image: UIImage(named: "ic_logout"), style: .plain, target: self, action: #selector(LogoutButtonAction))
            rightButton.tintColor = UIColor.white
            self.navigationItem.rightBarButtonItem = rightButton
        }
    }
    
    func setUpNavigationBarTitle(strTitle : String, fontSize:Float = 16, fontType: themeFonts = .ProximaNovaBold, isShadow:Bool = true, color:UIColor = UIColor.white) {
        if isShadow {
            setNavigationShadow()
        }else{
            removeNavigationShadow()
        }
        
        let HeaderLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 100, height: 35))
        HeaderLabel.isUserInteractionEnabled = false
        HeaderLabel.text = strTitle
        HeaderLabel.textColor = color
        HeaderLabel.numberOfLines = 2
        HeaderLabel.textAlignment = .center
        HeaderLabel.font = themeFont(size: fontSize, fontname: fontType)
        
        self.navigationItem.titleView = HeaderLabel
    }
    
    func setUpNavigationBarWhiteWithTitleAndBack(strTitle : String)
    {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor.appthemeRedColor
        self.navigationController?.navigationBar.isTranslucent = false
        
        setNavigationShadow()
        
        let leftButton = UIBarButtonItem(image: UIImage(named: "ic_back_icon"), style: .plain, target: self, action: #selector(backButtonAction))
        leftButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = leftButton
        self.navigationItem.hidesBackButton = true
        
        let HeaderLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 100, height: 35))
        HeaderLabel.isUserInteractionEnabled = false
        HeaderLabel.text = strTitle
        HeaderLabel.textColor = UIColor.white
        HeaderLabel.numberOfLines = 2
        HeaderLabel.textAlignment = .center
        HeaderLabel.font = themeFont(size: 17, fontname: .Regular)
        
        self.navigationItem.titleView = HeaderLabel
    }    
    
    func setNavigationShadow()
    {
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 2.0
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.4
        self.navigationController?.navigationBar.layer.masksToBounds = false
    }
    
    func removeNavigationShadow() {
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false

        self.navigationController?.navigationBar.layer.shadowColor = UIColor.clear.cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 0.0
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.0
        self.navigationController?.navigationBar.layer.masksToBounds = false
    }
    
    @objc func backButtonAction()
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnBackAction(_ sender : UIButton)
    {
        backButtonAction()
    }
    
    @objc func LogoutButtonAction()
    {
        let alertController = UIAlertController(title: getCommonString(key: "Load_key"), message: getCommonString(key: "Are_you_sure_want_to_logout_?_key"), preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: getCommonString(key: "Yes_key"), style: UIAlertAction.Style.default) { (result : UIAlertAction) -> Void in
            deleteJSON(key: USER_DETAILS_KEY)
            AppDelegate.shared?.openLoginScreen()
        }
        
        let cancelAction = UIAlertAction(title: getCommonString(key: "No_key"), style: UIAlertAction.Style.cancel) { (result : UIAlertAction) -> Void in
            print("Cancel")
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }    
    
   
    //MARK: - Loader
    
    
    func showLoader()
    {
        //let LoaderString:String = "Loading..."
        let LoaderSize = CGSize(width: 50, height: 50)
        
        startAnimating(LoaderSize, message: nil, type: NVActivityIndicatorType.ballPulseSync)
        
    }
    
    func hideLoader()
    {
        stopAnimating()
    }
    
    //MARK: - Validation email
    
    func isValidEmail(emailAddressString:String) -> Bool
    {
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
 
    //MARK: - Date and Time Formatter
    
    func stringTodate(Formatter:String,strDate:String) -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Formatter
        //  dateFormatter.locale = NSLocale(localeIdentifier: "en_US") as Locale!
        let FinalDate = dateFormatter.date(from: strDate)!
        return FinalDate
    }
    
    func DateToString(Formatter:String,date:Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Formatter
        //  dateFormatter.locale = NSLocale(localeIdentifier: "en_US") as Locale!
        let FinalDate:String = dateFormatter.string(from: date)
        return FinalDate
    }
    
    func stringTodate(OrignalFormatter : String,YouWantFormatter : String,strDate:String) -> String
    {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = OrignalFormatter
        guard let convertedDate = dateformatter.date(from: strDate) else {
            return ""
        }
        dateformatter.dateFormat = YouWantFormatter
        let convertedString = dateformatter.string(from: convertedDate)
        return convertedString
        
    }
    
    func strTodt(OrignalFormatter:String,YouWantFormatter:String,strDate:String) -> Date
    {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = OrignalFormatter
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = YouWantFormatter
        return dateFormatterPrint.date(from: strDate)!
    }
    
    func dtTostr(OrignalFormatter:String,YouWantFormatter:String,Date:Date) -> String
    {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = OrignalFormatter
        let strdate: String = dateFormatterGet.string(from: Date)
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = YouWantFormatter
        let date: Date = dateFormatterPrint.date(from: strdate)!
        return dateFormatterPrint.string(from: date)
    }
    
    //MARK: - Check youtube and vimeo url
    
    func checkVimeoURLWithAPI(urlString:String,completion:@escaping(_ data: JSON?) -> Void){
        
        guard ReachabilityTest.isConnectedToNetwork() else {
            makeToast(strMessage: "No internet connection available")
            return
        }

        ApiManager.shared.MakeGetAPIWithoutBaseURLAndAuth(name: strVimeoBaseURL + urlString, progress: false, vc: UIViewController()) { (response, error) in
            
            if response != nil {
                let json = JSON(response!)
                
                if json["video_id"].intValue > 0 {
                    completion(json)
                }else{
                    completion(nil)
                }
                
            }else{
                print("response nil")
                completion(nil)
            }
        }
    }

    func checkYouTubeURLWithAPI(urlString:String, completion: @escaping(_ data: JSON?) -> Void){
        
        print("masuk function")
        
        guard ReachabilityTest.isConnectedToNetwork() else {
            print("masuk else")
            makeToast(strMessage: "No internet connection available")
            return
        }

        ApiManager.shared.MakeGetAPIWithoutBaseURLAndAuth(name: strYoutubeBaseURL + urlString, progress: false, vc: UIViewController()) { (response, error) in
            
            print("Response:\(response)")
            print("Error: \(error)")
            
            if response != nil {
                let json = JSON(response!)
                
                if json["error"]["code"].intValue == 400{
                    
                }else{
                    completion(json)
                }
                
            }else{
                print("response nil")
                completion(nil)
            }
        }
    }

    //MARK: - get seconds from string
    
    func getSeconds(data: String?) -> Float {
        let dataArray = data?.split(separator: ":")
        if dataArray?.count == 3 {
            let sHr = (Double(dataArray?[0] ?? "0") ?? 0) * 60 * 60
            let sMin = (Double(dataArray?[1] ?? "0") ?? 0) * 60
            let sSec = (Double(dataArray?[2] ?? "0") ?? 0)
            
            let secondCount = sHr + sMin + sSec
            return Float(secondCount)
        }
        else if dataArray?.count == 2 {
            let sMin = (Double(dataArray?[0] ?? "0") ?? 0) * 60
            let sSec = (Double(dataArray?[1] ?? "0") ?? 0)
            
            let secondCount = sMin + sSec
            return Float(secondCount)
        }
        return Float(0)
    }
    
    //Vimeo Id get
    func getVimeoVideoString(strStreamingURL : String) -> String
    {
        let arrayContents = strStreamingURL.split(separator: "/")
        if(arrayContents.count > 0)
        {
            print("Link end - ",String(arrayContents[arrayContents.count-1]))
            
                let strValue = String(arrayContents[arrayContents.count-1])
                
                if strValue.contains("?"){
                    
                    let arraySplitQuestion = strValue.split(separator: "?")
                    
                    if arraySplitQuestion.count >= 2 {
                        print("arrayValue 0 :\(arraySplitQuestion[0])")
                        return String(arraySplitQuestion[0])
                    } else {
                        print("arrayValue 0 :\(arraySplitQuestion[0])")
                        return String(arraySplitQuestion[0])
                    }
                } else {
                    print("arrayValue 0 :\(strValue)")
                    return strValue
                }
            
//            return String(arrayContents[arrayContents.count-1])
        }else{
            return ""
        }
    }
    
    func oneDigitAfterDecimal(value : CGFloat,digit: Int = 1) -> String{
        //Old comment
//        return String(format: "%.\(digit)f", value)
        
        let multiplier = pow(10.0, CGFloat(digit))
        let rounded = round(value * multiplier) / multiplier
        return "\(rounded)"
    }

    func setOneDigitWithFloor(value: CGFloat) -> String{
         return "\(floor((value*10)) / 10)"
    }

    func setOneDigitWithFloorInCGFLoat(value: CGFloat) -> CGFloat{
         return (floor((value*10)) / 10)
    }
    
    //MARK:- Check Location is enable or not
    
    func checkLocationPermissionAvailableOrNot(){
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                self.openSettingParticularApp()
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
            @unknown default:
                break
            }
        } else {
            openSettingPrivacyAlert()
        }
    }

    
    //MARK:- Redirect to setting while user off Location
    
    func openSettingParticularApp()
    {
        let alertController = UIAlertController (title: "Load", message: getCommonString(key: "Go_to_Setting_key"), preferredStyle: .alert)

        let settingsAction = UIAlertAction(title: getCommonString(key: "Setting_key"), style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                } else {
                    // Fallback on earlier versions
                }
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: getCommonString(key: "Cancel_key"), style: .default, handler: nil)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func openSettingPrivacyAlert() {
        
        let alertController = UIAlertController(title: getCommonString(key: "Location_is_Disabled_key"), message: getCommonString(key: "setting_privacy_off_location_msg_key"), preferredStyle: UIAlertController.Style.alert)
        
        let cancelAction = UIAlertAction(title: getCommonString(key: "Cancel_key"), style: UIAlertAction.Style.cancel) { (result : UIAlertAction) -> Void in
            print("Cancel")
        }
        
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension UIViewController{
    private func trigger(selector: Selector) -> Observable<Void> {
        return rx.sentMessage(selector).map { _ in () }.share(replay: 1)
    }
    
    var viewWillAppearTrigger: Observable<Void> {
        return self.trigger(selector: #selector(self.viewWillAppear(_:)))
    }
    
    var viewDidAppearTrigger: Observable<Void> {
        return self.trigger(selector: #selector(self.viewDidAppear(_:)))
    }
    
    var viewWillDisappearTrigger: Observable<Void> {
        return self.trigger(selector: #selector(self.viewWillDisappear(_:)))
    }
    
    var viewDidDisappearTrigger: Observable<Void> {
        return self.trigger(selector: #selector(self.viewDidDisappear(_:)))
    }
    
 
}
