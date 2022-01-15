//
//  EventDetailsVC.swift
//  Load
//
//  Created by Haresh Bhai on 18/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class EventDetailsVC: UIViewController, NewMessageSelectDelegate {

    //MARK:- Variables
    lazy var mainView: EventDetailsView = { [unowned self] in
        return self.view as! EventDetailsView
    }()
    
    lazy var mainModelView: EventDetailsViewModel = {
        return EventDetailsViewModel(theController: self)
    }()
    
    //MARK:- Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        self.navigationController?.setWhiteColor()
        self.setUpNavigationBarTitle(strTitle: getCommonString(key: "UPCOMING_EVENTS_key").lowercased().capitalized, fontType: .HelveticaBold, color: UIColor.black)
        self.mainView.setupUI(theController: self)
        self.mainModelView.setupUI()
    }
    
    //MARK:- @IBAction
    @IBAction func btnCloseClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnBookmarkTapped(_ sender: Any) {
        self.mainView.btnBookmark.isSelected = !self.mainView.btnBookmark.isSelected
        self.mainModelView.apiCallAddAndRemoveFromBookmark(eventId: self.mainModelView.eventId, status: self.mainView.btnBookmark.isSelected, isLoading: true)
    }
    
    @IBAction func btnContinueClicked(_ sender: Any) {
        let obj: NewMessageSelectVC
            = AppStoryboard.Messages.instance.instantiateViewController(withIdentifier: "NewMessageSelectVC") as! NewMessageSelectVC
        obj.mainModelView.delegate = self
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    func NewMessageSelectDidFinish(name: String, id: String) {
        SocketIOHandler.shared.shareFriendEvent(toIds: [Int(id)!], eventId: (self.mainModelView.eventDetails?.id?.intValue)!)
    }
}
