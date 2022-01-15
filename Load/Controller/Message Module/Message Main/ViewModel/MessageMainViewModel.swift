//
//  MessageMainViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 26/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import CarbonKit

class MessageMainViewModel {

    //MARK:- Variables
    fileprivate weak var theController:MessageMainVC!
    var items = NSArray()
    var carbonTabSwipeNavigation = CarbonTabSwipeNavigation()
    var lastBadge: String = ""

    init(theController:MessageMainVC) {
        self.theController = theController
    }
    
    func showBadge(index: Int, badgeValue: String) {
        let tabView: UIView? = carbonTabSwipeNavigation.carbonSegmentedControl!.segments![index] as? UIView
        
        if badgeValue != "0" {
            if lastBadge == badgeValue {
                return
            }
            lastBadge = badgeValue
            if let viewWithTag = tabView!.viewWithTag(101) {
                for v in viewWithTag.subviews{
                    if v is UILabel{
                        v.removeFromSuperview()
                        viewWithTag.addSubview(addBadgeLabel(count: badgeValue))
                    }
                }
            }
            else {
                tabView?.addSubview(addBadgeValue(count: badgeValue))
            }
        }
        else {
            lastBadge = ""
            if let viewWithTag = self.theController.view.viewWithTag(101) {
                viewWithTag.removeFromSuperview()
            }
        }
    }
    
    func addBadgeValue(count: String)-> UIView {
        let starWidth = self.widthOfString(str: count, usingFont: themeFont(size: 11, fontname: .Helvetica)) + 10
        let newWidth = starWidth > 15 ? starWidth : 15
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: newWidth, height: 15))
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.white
        label.font = themeFont(size: 11, fontname: .Helvetica)
        label.text = "\(count)"
        
        let viewDemo = UIView()
        viewDemo.tag = 101
        viewDemo.backgroundColor = UIColor.appthemeRedColor
        let frame = UIScreen.main.bounds.width / 4
        viewDemo.frame = CGRect(x: frame + 35, y: 15, width: newWidth, height: 15)
        viewDemo.layer.cornerRadius = 15 / 2
        
        viewDemo.addSubview(label)
        return viewDemo
    }
    
    func addBadgeLabel(count: String)-> UILabel {
        let starWidth = self.widthOfString(str: count, usingFont: UIFont.systemFont(ofSize: 14)) + 10
        let newWidth = starWidth > 15 ? starWidth : 15
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: newWidth, height: 15))
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "\(count)"
        return label
    }
    
    func widthOfString(str: String, usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = str.size(withAttributes: fontAttributes)
        return size.width
    }
}
