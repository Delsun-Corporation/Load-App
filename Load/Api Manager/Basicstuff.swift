//
//  Basicstuff.swift
//  Load
//
//  Created by Haresh Bhai on 22/03/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire
import MaterialComponents
import CoreLocation
import RealmSwift

//MARK: - User Location
var userCurrentLocation:CLLocation?

struct GlobalVariables {
    static var localTimeZoneName: String { return TimeZone.current.identifier }
    static let deviceType = "iOS"
}

let Defaults = UserDefaults.standard

//MARK: - Realm Object
var realm = try? Realm()

//MARK: - Setup mapping
let StringFilePath = Bundle.main.path(forResource: "Language", ofType: "plist")
let dictStrings = NSDictionary(contentsOfFile: StringFilePath ?? "")

func getCommonString(key:String) -> String {
    return dictStrings?.object(forKey: key) as? String ?? ""
}

//MARK: - Set Toaster

func makeToast(strMessage : String){
    let messageSnack = MDCSnackbarMessage()
    messageSnack.text = strMessage
    MDCSnackbarManager.default.show(messageSnack)
}

func getUserDetail() -> LoginModelClass? {
    let userDetail = loadJSON(key: USER_DETAILS_KEY)
    let data = JSON(userDetail)
    return LoginModelClass(JSON: data.dictionaryObject ?? [String: Any]())
}

func getUserDetailJSON() -> JSON {
    let userDetail = loadJSON(key: USER_DETAILS_KEY)
    let data = JSON(userDetail)
    return data
}

func printFonts() {
    let fontFamilyNames = UIFont.familyNames
    for familyName in fontFamilyNames {
        print("------------------------------")
        print("Font Family Name = [\(familyName)]")
        let names = UIFont.fontNames(forFamilyName: familyName )
        print("Font Names = [\(names)]")
    }
}


struct DEVICE_TYPE {
    // iDevice detection code
    static let IS_IPAD             = UIDevice.current.userInterfaceIdiom == .pad
    static let IS_IPHONE           = UIDevice.current.userInterfaceIdiom == .phone
    static let IS_RETINA           = UIScreen.main.scale >= 2.0
    
    static let SCREEN_WIDTH        = Int(UIScreen.main.bounds.size.width)
    static let SCREEN_HEIGHT       = Int(UIScreen.main.bounds.size.height)
    static let SCREEN_MAX_LENGTH   = Int( max(SCREEN_WIDTH, SCREEN_HEIGHT) )
    static let SCREEN_MIN_LENGTH   = Int( min(SCREEN_WIDTH, SCREEN_HEIGHT) )
    
    static let IS_IPHONE_4_OR_LESS = IS_IPHONE && SCREEN_MAX_LENGTH < 568
    static let IS_IPHONE_5_OR_LESS = IS_IPHONE && SCREEN_MAX_LENGTH <= 568
    static let IS_IPHONE_5         = IS_IPHONE && SCREEN_MAX_LENGTH == 568
    static let IS_IPHONE_6         = IS_IPHONE && SCREEN_MAX_LENGTH == 667
    static let IS_IPHONE_6P        = IS_IPHONE && SCREEN_MAX_LENGTH == 736
    static let IS_IPHONE_X         = IS_IPHONE && SCREEN_MAX_LENGTH == 812
    static let IS_IPHONE_XS        = IS_IPHONE && SCREEN_MAX_LENGTH == 812
    static let IS_IPHONE_X_MAX     = IS_IPHONE && SCREEN_MAX_LENGTH == 896
}

extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem as Any, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}
