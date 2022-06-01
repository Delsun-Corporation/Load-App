//
//  AlertHelper.swift
//  Load
//
//  Created by Christopher Kevin on 01/06/22.
//  Copyright © 2022 Haresh Bhai. All rights reserved.
//

import UIKit

class AlertHelper {
    static let shared = AlertHelper()
    
    func showErrorMessage(title: String, message: String = "") {
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()

        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.cancel, handler: { _ in
            alertWindow.isHidden = true
        }))
        
        alertWindow.windowLevel = UIWindow.Level.alert + 1;
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
        print("🍍")
    }
}
