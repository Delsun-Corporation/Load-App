//
//  OwnRequestListingDetailScreenVc.swift
//  Load
//
//  Created by iMac on 09/07/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import UIKit

class OwnRequestListingDetailScreenVc: UIViewController {

    //MARK:- Variables
    lazy var mainView: OwnRequestListingDetailScreenView = { [unowned self] in
        return self.view as! OwnRequestListingDetailScreenView
        }()
    
    lazy var mainModelView: OwnRequestListingDetailScreenViewModel = {
        return OwnRequestListingDetailScreenViewModel(theController: self)
    }()

    //MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainView.setupUI()
        self.mainModelView.setUpData()
        self.mainView.scrollView.delegate = self
        
        setUpNavigationBarTitle(strTitle: "" , isShadow: false, color: .white)
        
        
        // Do any additional setup after loading the view.
    }
    
    
    func setNavigationForIndoor(){
        
        let navigationBarHeight: CGFloat = self.navigationController?.navigationBar.frame.height ?? 66
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "Topheader")?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0 ,right: 0), resizingMode: .stretch), for: .default)

//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "Topheader")?.resizeImage(targetSize: CGSize(width: UIScreen.main.bounds.width, height: 100), customHeight: navigationBarHeight), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage(named: "")
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    }

    
    @IBAction func btnPromoteTapeed(_ sender: UIButton) {
    }
    
    @IBAction func btnDeleteTapped(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "", message: getCommonString(key: "Do_you_want_to_delete_this_request_key"), preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: getCommonString(key: "Yes_key"), style: UIAlertAction.Style.default) { (result : UIAlertAction) -> Void in
            self.mainModelView.apiCallRequestDelete()
        }
        
        let cancelAction = UIAlertAction(title: getCommonString(key: "No_key"), style: UIAlertAction.Style.cancel) { (result : UIAlertAction) -> Void in
            print("Cancel")
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func btnCloseTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnEditTapped(_ sender: UIButton) {
        let obj = AppStoryboard.LoadCenter.instance.instantiateViewController(withIdentifier: "CreateRequestStepOneVC") as! CreateRequestStepOneVC
        obj.mainModelView.isEdit = true
        obj.mainModelView.editRequestData = self.mainModelView.requestDetailsData
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    func setNavigationWithtitle(name:String){
        
        setUpNavigationBarTitle(strTitle: name , isShadow: false, color: .white)
//
//        self.navigationController?.navigationBar.backgroundColor = .clear
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.navigationBar.layer.shadowColor = UIColor.clear.cgColor
//        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
//        self.navigationController?.navigationBar.layer.shadowRadius = 0.0
//        self.navigationController?.navigationBar.layer.shadowOpacity = 0.0
//        self.navigationController?.navigationBar.layer.masksToBounds = false

        setNavigationForIndoor()

    }
}


//MARK: - ScrollView Delegate

extension OwnRequestListingDetailScreenVc : UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentSize.height+50 <= mainView.safeAreaHeight{
            return
        }
        
        if self.mainView.scrollView.panGestureRecognizer.translation(in: scrollView).y > 0{

            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                
                [self.mainView.vwDelete,self.mainView.vwPromote].forEach { (vw) in
                    vw?.alpha = 0.0
                }
                self.mainView.lblInstructionInBottom.alpha = 0.0
                self.mainView.vwMainBottom.isUserInteractionEnabled = false
                
//                self.mainView.isShowButtonAndLabel(isShow: false)
                
//                if self.mainModelView.checkIsExerciseStarted(){
//
//                }else{
//                    self.mainView.heightOfVwBottom.constant = 0
//                    self.mainView.isBottomDeleteShareShow(isShow: false)
//                }
//                self.mainView.constraintBottomofStackView.constant = 0
//                self.mainView.ConstratintBottomView.constant = 0
                self.mainView.layoutIfNeeded()

            }, completion: nil)
            
        }
        else{
            
            if (scrollView.contentOffset.y > 0 && scrollView.contentOffset.y < (scrollView.contentSize.height - scrollView.frame.size.height)){
            }else{
                
                if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
                    scrollEndMethod()
                }

            }
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        scrollEndMethod()
    }
    
    func scrollEndMethod(){
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            
            [self.mainView.vwDelete,self.mainView.vwPromote].forEach { (vw) in
                vw?.alpha = 1.0
            }
            self.mainView.lblInstructionInBottom.alpha = 1.0
            self.mainView.vwMainBottom.isUserInteractionEnabled = true
            
//            self.mainView.isShowButtonAndLabel(isShow: true)

//            self.mainView.constraintBottomofStackView.constant = 30.5
//            self.mainView.heightOfVwBottom.constant = 75
//            self.mainView.ConstratintBottomView.constant = 15
            self.mainView.layoutIfNeeded()
        }, completion: nil)

    }
    
}
