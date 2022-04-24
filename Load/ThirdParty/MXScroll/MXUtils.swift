//
//  MXUtils.swift
//  Load
//
//  Created by Timotius Leonardo Lianoto on 24/04/22.
//  Copyright © 2022 Haresh Bhai. All rights reserved.
//

import Foundation
import UIKit

class MXUtil {
    /**
     * Method to get topspacing of container,
     
     - returns: topspace in float
     */
    static func getTopSpacing(_ viewController: UIViewController) -> CGFloat {
        if let _ = viewController.splitViewController {
            return 0.0
        }
        
        var topSpacing: CGFloat = 0.0
        let navigationController = viewController.navigationController
        
        if navigationController?.children.last == viewController {
            if navigationController?.isNavigationBarHidden == false {
                topSpacing = UIApplication.shared.statusBarFrame.height
                if !(navigationController?.navigationBar.isOpaque)! {
                    topSpacing += (navigationController?.navigationBar.bounds.height)!
                }
            }
        }
        return topSpacing
    }
    
    /**
     * Method to get bottomspacing of container
     
     - returns: bottomspace in float
     */
    static func getBottomSpacing(_ viewController: UIViewController) -> CGFloat {
        var bottomSpacing: CGFloat = 0.0
        
        if let tabBarController = viewController.tabBarController {
            if !tabBarController.tabBar.isHidden && !tabBarController.tabBar.isOpaque {
                bottomSpacing += tabBarController.tabBar.bounds.size.height
            }
        }
        
        return bottomSpacing
    }
}
