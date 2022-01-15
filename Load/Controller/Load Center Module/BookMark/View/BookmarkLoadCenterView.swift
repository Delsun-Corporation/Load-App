//
//  BookmarkLoadCenterView.swift
//  Load
//
//  Created by iMac on 18/03/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import UIKit

class BookmarkLoadCenterView: UIView {

    //MARK: - Outlet
    
    @IBOutlet weak var tblBookMark: UITableView!
    
    //MARK:- Functions
     func setupUI() {
         self.tblBookMark.register(UINib(nibName: "MultipleImagesBookmarkTblCell", bundle: nil), forCellReuseIdentifier: "MultipleImagesBookmarkTblCell")
     }

}
