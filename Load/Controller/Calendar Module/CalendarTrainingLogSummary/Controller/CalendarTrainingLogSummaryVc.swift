//
//  CalendarTrainingLogSummaryVc.swift
//  Load
//
//  Created by iMac on 17/03/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

class CalendarTrainingLogSummaryVc: UIViewController {
    
    //MARK:- Variables
    lazy var mainView: CalendarTrainingLogSummaryView = { [unowned self] in
        return self.view as! CalendarTrainingLogSummaryView
        }()
    
    lazy var mainModelView: CalendarTrainingLogSummaryViewModel = {
        return CalendarTrainingLogSummaryViewModel(theController: self)
    }()
    
    @IBOutlet weak var btnActivityImage: UIButton!
    var oldContentOffset = CGPoint.zero
    let topConstraintRange = (CGFloat(263.66)..<CGFloat(334.66))

    var isPaceSelected = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mainView.setupUI(theController: self)
        self.mainModelView.setupUI()
        
        setUpNavigationBarTitle(strTitle: convertDateFormater(self.mainModelView.date,format: "yyyy-MM-dd", dateFormat: "EEEE, dd MMM"), isShadow: false ,color: .white)
        self.navigationController?.setColor()

        if self.mainModelView.controllerMoveFrom == .trainingLog{
            self.mainView.btnDelete.isHidden = false
        } else if self.mainModelView.controllerMoveFrom == .trainingProgram{
            self.mainView.btnDelete.isHidden = true
        }
        
        // Do any additional setup after loading the view.
    }
    
    func setNavigationForIndoor(){
        
        let navigationBarHeight: CGFloat = self.navigationController?.navigationBar.frame.height ?? 66
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "Topheader")?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0 ,right: 0), resizingMode: .stretch), for: .default)

        self.navigationController?.navigationBar.shadowImage = UIImage(named: "")
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    }
    
    func setNavigationForOutdoor(){
        let navigationBarHeight: CGFloat = self.navigationController?.navigationBar.frame.height ?? 66
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "ic_header_outdoor")?.resizeImage(targetSize: CGSize(width: UIScreen.main.bounds.width, height: 85), customHeight: navigationBarHeight), for: .default)
    }
    
    func setLeftNavigationBarButton(image:UIImage){
        
        self.btnActivityImage.setImage(image, for: .normal)
        
//        let leftButton = UIImageView()
//        leftButton.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
//        leftButton.image = image
//        leftButton.contentMode = .scaleAspectFit
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
    }
    
}

//MARK: - IBAction method

extension CalendarTrainingLogSummaryVc{
    
    @IBAction func btnCloseTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        self.mainModelView.delegateDismissTrainingLogSummary?.dismissCalendarTrainingLogSummary()
    }
    
    @IBAction func btnSaveTapped(_ sender: UIButton) {
        
        if self.mainView.txtvwComment.text.toTrim() == ""{
            makeToast(strMessage: getCommonString(key: "Please_enter_comment_key"))
            return
        }
        
        self.mainModelView.saveSummaryCardiolog()
    }
    
    @IBAction func btnTrainingLogExpandTapped(_ sender: UIButton) {
        
        if self.mainView.btnArrowUpDown.isSelected{
            self.mainView.heightTblDataConstant.constant = 0
            self.mainView.vwLaps.isHidden = true
            self.mainView.heightOfVwLaps.constant = 0
            
            self.mainView.vwTraininGoalShadow.shadowColors = .clear
            self.mainView.imgArrow.image = UIImage(named: "ic_up_summary_black")
            
            
        }else{
            
            if self.mainModelView.controllerMoveFrom == .trainingLog{
                self.mainView.heightTblDataConstant.constant = CGFloat((self.mainModelView.cardioSummaryDetails?.exercise?.count ?? 0) * 70) + CGFloat(60)
            }
            else if self.mainModelView.controllerMoveFrom == .trainingProgram {
                self.mainView.heightTblDataConstant.constant = CGFloat((self.mainModelView.cardioSummaryDetails?.exerciseTrainingProgram?.count ?? 0) * 70) + CGFloat(60)
            }
            
            self.mainView.vwLaps.isHidden = false
            self.mainView.heightOfVwLaps.constant = 45
            self.mainView.vwTraininGoalShadow.setShadowToView()
            self.mainView.vwTraininGoalShadow.shadowColors = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
            self.mainView.imgArrow.image = UIImage(named: "ic_down_summary_black")
        }
        self.mainView.tableView.reloadData()
        
        self.mainView.btnArrowUpDown.isSelected = !self.mainView.btnArrowUpDown.isSelected
        
    }
    
    @IBAction func btnDeleteTapped(_ sender: UIButton) {
        self.mainModelView.deleteLog()
    }
    
    @IBAction func btnShareTapped(_ sender: UIButton) {
    }
    
}

//MARK: - ScrollView Delegate method
extension CalendarTrainingLogSummaryVc: UITextViewDelegate{
    
    func textViewDidChange(_ textView: UITextView) {
        self.mainView.lblPlaceholder.isHidden = self.mainView.txtvwComment.text == "" ? false : true
    }
    
}

extension CalendarTrainingLogSummaryVc: UIScrollViewDelegate{
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//        print("Content Offset : \(scrollView.contentOffset.y)")
//
//        if scrollView.contentOffset.y  >= 250 && scrollView.contentOffset.y  <= 260 {
//
//            self.mainView.scrollView.setContentOffset(CGPoint(x: 0, y: 250), animated: false)
//
//            self.mainView.scrollView.isScrollEnabled = false
//
//            UIView.animate(withDuration: 0.2, animations: {
//
//                self.mainView.scrollView.isScrollEnabled = true
//
//                if self.mainView.scrollView.panGestureRecognizer.translation(in: scrollView).y > 0{
//                    self.mainView.constraintTopDayInterval.constant = 64
//
//                }else{
//                    self.mainView.constraintTopDayInterval.constant = 44
////                    self.mainView.scrollView.scrollsToTop = false
////                    self.mainView.scrollView.setContentOffset(CGPoint(x: 0, y: 265), animated: false)
//                }
//
//                self.mainView.layoutIfNeeded()
//
//            }) { (status) in
//
//                self.mainView.scrollView.isScrollEnabled = true
////                if self.mainView.scrollView.panGestureRecognizer.translation(in: scrollView).y > 0{
////                    print("Up")
////                    self.mainView.scrollView.setContentOffset(CGPoint(x: 0, y: 249), animated: true)
////                }else{
////                    self.mainView.scrollView.setContentOffset(CGPoint(x: 0, y: 261), animated: true)
////                }
//            }
//
//        }else{
//
//            self.mainView.scrollView.isScrollEnabled = true
//
//            if scrollView.contentOffset.y  < 250 {
//                UIView.animate(withDuration: 0.3, animations: {
//
//                    self.mainView.constraintTopDayInterval.constant = 64
////                    self.mainView.scrollView.setContentOffset(CGPoint(x: 0, y: 249), animated: false)
//
//                    self.mainView.layoutIfNeeded()
//
//                }) { (status) in
//
//                }
//            }
//        }
//    }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y > self.mainView.vwMainTotalDuration.frame.origin.y {
            
//            if scrollView.contentOffset.y >= self.mainView.vwMainTotalDuration.frame.origin.y + (self.mainView.vwMainTotalDuration.frame.height/3){
//                self.mainView.vwMainTotalDuration.isHidden = false
////                self.mainView.vwDummayTotalDuration.isHidden = true
//
//                if scrollView.contentOffset.y >= (self.mainView.vwMainTotalDuration.frame.origin.y + (self.mainView.vwMainTotalDuration.frame.height/3)){
//                    self.mainView.constrainTopDummyDuration.constant = (self.mainView.vwMainTotalDuration.frame.origin.y + (self.mainView.vwMainTotalDuration.frame.height/3)) - scrollView.contentOffset.y
//                }

                //Content scroll till 266 after that move upside and Hide view
            
            /*
            if scrollView.contentOffset.y > 266{
                self.mainView.vwMainTotalDuration.isHidden = false
                //                self.mainView.vwDummayTotalDuration.isHidden = true
                
                if scrollView.contentOffset.y > 266{
                    self.mainView.constrainTopDummyDuration.constant = (266) - scrollView.contentOffset.y
                }
                
            }else{
                self.mainView.constrainTopDummyDuration.constant = 0
                self.mainView.vwMainTotalDuration.isHidden = true
                self.mainView.vwDummayTotalDuration.isHidden = false
            }*/
            
            if scrollView.contentOffset.y > self.mainView.vwMainTotalDuration.frame.origin.y + 26{
                self.mainView.vwMainTotalDuration.isHidden = false
                //                self.mainView.vwDummayTotalDuration.isHidden = true
                
                if scrollView.contentOffset.y > self.mainView.vwMainTotalDuration.frame.origin.y + 26{
                    self.mainView.constrainTopDummyDuration.constant = (self.mainView.vwMainTotalDuration.frame.origin.y + 26) - scrollView.contentOffset.y
                }
                
            }else{
                self.mainView.constrainTopDummyDuration.constant = 0
                self.mainView.vwMainTotalDuration.isHidden = true
                self.mainView.vwDummayTotalDuration.isHidden = false
            }
            
        }else{
            self.mainView.vwMainTotalDuration.isHidden = false
            self.mainView.vwDummayTotalDuration.isHidden = true
        }
        
    }
    
}
