//
//  CalendarTrainingLogResistanceSummary.swift
//  Load
//
//  Created by iMac on 20/05/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class CalendarTrainingLogResistanceSummaryVc: UIViewController {

    //MARK:- Variables
    lazy var mainView: CalendarTrainingLogResistanceSummaryView = { [unowned self] in
        return self.view as! CalendarTrainingLogResistanceSummaryView
        }()
    
    lazy var mainModelView: CalendarTrainingLogResistanceSummaryViewModel = {
        return CalendarTrainingLogResistanceSummaryViewModel(theController: self)
    }()

    var tableHeight: CGFloat = 0.0
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor.white
        self.mainView.setupUI(theController: self)
        self.mainModelView.setupUI()
        setNavigationBar()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.mainView.tableView.addObserver(self, forKeyPath: "contentSize", options: [.new], context: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.mainView.tableView.removeObserver(self, forKeyPath: "contentSize")
        NotificationCenter.default.removeObserver(self, name: Notification.Name(NOTIFICATION_CENTER_LIST.CALENDAR_RELOADING.rawValue), object: nil)
    }
    
    func setNavigationBar(){
        setUpNavigationBarTitle(strTitle: convertDateFormater(self.mainModelView.date,format: "yyyy-MM-dd", dateFormat: "EEEE, dd MMM"), isShadow: false ,color: .white)
        self.navigationController?.setColor()
        
        let navigationBarHeight: CGFloat = self.navigationController?.navigationBar.frame.height ?? 66
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "Topheader")?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0 ,right: 0), resizingMode: .stretch), for: .default)

        self.navigationController?.navigationBar.shadowImage = UIImage(named: "")
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")

    }
}

//MARK:-  IBAction method

extension CalendarTrainingLogResistanceSummaryVc{
    
    @IBAction func btnCloseTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        self.mainModelView.delegateDismissTrainingLogSummary?.dismissCalendarTrainingLogSummary()
    }
    
    
    @IBAction func btnSaveTapped(_ sender: UIButton) {
        
        if self.mainView.txtvwComment.text.toTrim() == ""{
            makeToast(strMessage: getCommonString(key: "Please_enter_comment_key"))
            return
        }
        
        self.mainModelView.saveSummaryResistancelog()
    }
    
    @IBAction func btnTrainingLogExpandTapped(_ sender: UIButton) {
        
        if self.mainView.btnArrowUpDown.isSelected{
            self.mainView.heightTblDataConstant.constant = 0
        }else{
            
            var count:Int = 0
            /*
            if let array = self.mainModelView.resistanceSummaryDetails?.additionalExercise{
                
                for (index, _) in (array.enumerated()) {
                    count += array[index].data?.count ?? 0
                }
                //30 for row
                //83 for exercise name
                //10 for footer
                //14 for first and last set in particular exercise add extra space
                //45 for table header height (lblExercise header)
                
                self.mainView.heightTblDataConstant.constant = CGFloat(CGFloat((count) * 39) + ((CGFloat(83+10 + 14)) * CGFloat(array.count)) + 45)
            }*/
            
            self.mainView.heightTblDataConstant.constant =  self.tableHeight
        }
        
        self.mainView.tableView.reloadData()
        self.mainView.btnArrowUpDown.isSelected = !self.mainView.btnArrowUpDown.isSelected
        
    }
    
    @IBAction func btnDeleteTapped(_ sender: UIButton) {
        self.mainModelView.deleteLog()
    }
    
    @IBAction func btnShareTapped(_ sender: UIButton) {
    }
    
    //MARK:- Overide Method
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if object is UITableView {
            self.tableHeight = self.mainView.tableView.contentSize.height
        }
    }

    
}

//MARK: - ScrollView Delegate method
extension CalendarTrainingLogResistanceSummaryVc: UITextViewDelegate{
    
    func textViewDidChange(_ textView: UITextView) {
        self.mainView.lblPlaceholder.isHidden = self.mainView.txtvwComment.text == "" ? false : true
    }
    
}

//MARK: - ScrollView delegate
extension CalendarTrainingLogResistanceSummaryVc: UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y > self.mainView.vwMainTotalDuration.frame.origin.y {
            
            if scrollView.contentOffset.y > self.mainView.vwMainTotalDuration.frame.origin.y + 26{
                self.mainView.vwMainTotalDuration.isHidden = false
                //                self.mainView.vwDummayTotalDuration.isHidden = true
                
                if scrollView.contentOffset.y > self.mainView.vwMainTotalDuration.frame.origin.y + 26{
                    self.mainView.constrainTopDummyDuration.constant = (self.mainView.vwMainTotalDuration.frame.origin.y + 26) - scrollView.contentOffset.y
                }
                
            }else{
                self.mainView.constrainTopDummyDuration.constant = 0
                self.mainView.vwMainTotalDuration.isHidden = true
                self.mainView.vwDummyTotalDuration.isHidden = false
            }
            
        }else{
            self.mainView.vwMainTotalDuration.isHidden = false
            self.mainView.vwDummyTotalDuration.isHidden = true
        }
        
    }

}
