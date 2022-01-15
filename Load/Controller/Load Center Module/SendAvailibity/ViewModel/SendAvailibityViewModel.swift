//
//  SendAvailibityViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 27/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SwiftyJSON

class SendAvailibityViewModel: CustomNavigationBackDelegate {

    //MARK:- Variables
    fileprivate weak var theController:SendAvailibityVC!
    
    var profileDetails: OtherUserDetailsModelClass?
    var userId: String = ""
    var txtTime: String = ""
    var txtDate: String = ""
    var txtTimeId: String = ""

    init(theController:SendAvailibityVC) {
        self.theController = theController
    }
    
    func setupData() {
        let view = (self.theController.view as? SendAvailibityView)
        view?.lblDate.text = self.txtDate
        view?.lblTime.text = self.txtTime.lowercased()
    } 
    
    func apiCallStoreRequestToMakeClient(toId: Int, selectedDate: String, availableTimeId: Int, notes: String, confirmedStatus: Int, isLoading:Bool = true) {
        let param = [
            "to_id": toId,
            "selected_date": selectedDate,
            "available_time_id": availableTimeId,
            "notes": notes,
            "confirmed_status": confirmedStatus
            ] as [String : Any]
        print(param)
        
        ApiManager.shared.MakePostAPI(name: STORE_REQUEST_TO_MAKE_CLIENT, params: param as [String : Any], progress: isLoading, vc: self.theController, isAuth:false) { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let view = (self.theController.view as? CheckAvailibityView)
                let success = json.getBool(key: .success)
                if success {
                    let data = json.getDictionary(key: .data)
                    let id = data.getInt(key: .id)                    
                    SocketIOHandler.shared.getAddClientRequestMessage(id: id) { (json) in
                        print(json![0])
                        if json?.count != 0 && !json![0].isEmpty {
                            if let viewWithTag = self.theController.navigationController!.view.viewWithTag(1000) {
                                viewWithTag.removeFromSuperview()
                            }
                            let model = ConversationData(JSON: json![0].dictionaryObject!)
                            let obj: ChatVC = AppStoryboard.Messages.instance.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
                            obj.mainModelView.chatDetails = model
                            obj.mainModelView.isClientRequest = true
                            obj.mainModelView.conversationId = model?.id?.stringValue ?? ""
                            obj.hidesBottomBarWhenPushed = true
                            self.theController.navigationController?.pushViewController(obj, animated: true)
                        }
                    }
                }
                else {
                    view?.tableView.reloadData()
                }
            }
        }
    }
    
    func setupNavigationbar(title:String, type:String, image:String) {
        self.theController.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        self.theController.navigationController?.setColor()
        self.theController.navigationItem.hidesBackButton = true
        
        if let vwnav = ViewNavWhite.instanceFromNib() as? ViewNavWhite {
            
            var hightOfView = 0
            if UIScreen.main.bounds.height >= 812 {
                hightOfView = 44
            }
            else {
                hightOfView = 20
            }
            
            vwnav.frame = CGRect(x: 0, y: 0, width: self.theController.navigationController?.navigationBar.frame.width ?? 320, height: vwnav.frame.height + CGFloat(hightOfView))
            vwnav.lblName.text = title.uppercased()
            vwnav.lblType.text = type
            vwnav.showImage(url: image)
            vwnav.tag = 1000
            vwnav.delegate = self
            self.theController.navigationController?.view.addSubview(vwnav)
        }
    }
    
    func CustomNavigationBack() {
        self.theController.navigationController?.popViewController(animated: true)
    }
}
