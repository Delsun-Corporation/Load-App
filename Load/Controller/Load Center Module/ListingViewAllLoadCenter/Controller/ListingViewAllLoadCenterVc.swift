//
//  ListingViewAllLoadCenterVc.swift
//  Load
//
//  Created by iMac on 20/05/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import UIKit

enum checkComeFromViewAll{
    case fromSaved
    case fromLisitng
}


class ListingViewAllLoadCenterVc: UIViewController {

    //MARK:- Variables
    lazy var mainView: ListingViewAllLoadCenterView = { [unowned self] in
        return self.view as! ListingViewAllLoadCenterView
        }()
    
    lazy var mainModelView: ListingViewAllLoadCenterViewModel = {
        return ListingViewAllLoadCenterViewModel(theController: self)
    }()
    
    @IBOutlet weak var btnBookmark: UIButton!
    
    var strTitleName = ""
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.setupUI(theController:self)
        setUpNavigationBarTitle(strTitle: strTitleName)
        self.navigationController?.setColor()
        
        mainModelView.setupUI()
        

        
        // Do any additional setup after loading the view.
    }
    
}

//MARK: - IBAction method

extension ListingViewAllLoadCenterVc{
    
    @IBAction func btnBookmarkTapped(_ sender: UIButton) {
        
        let obj = AppStoryboard.LoadCenter.instance.instantiateViewController(withIdentifier: "BookmarkLoadCenterVc") as! BookmarkLoadCenterVc
        let nav = UINavigationController(rootViewController: obj)
        nav.modalPresentationStyle = .overFullScreen
        self.present(nav, animated: true, completion: nil )
        
    }
    
    @IBAction func btnCloseTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
