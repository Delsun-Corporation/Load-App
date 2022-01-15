//
//  CreateTrainingLogVc + CollectionView.swift
//  Load
//
//  Created by iMac on 05/02/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import Foundation
import SwiftyJSON

extension CreateTrainingLogVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.mainModelView.arrayHeader.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderCollectionCell", for: indexPath) as! HeaderCollectionCell
        
        let dict = self.mainModelView.arrayHeader[indexPath.row]
        
        cell.btnImageWithTitle.setTitle(dict["name"].stringValue, for: .normal)
        cell.btnImageWithTitle.isSelected = dict["selected"].stringValue == "1" ? true : false
        cell.btnImageWithTitle.setImage(cell.btnImageWithTitle.isSelected == true ? UIImage(named: dict["selectedImage"].stringValue) : UIImage(named: dict["unselectedImage"].stringValue) , for: .normal)
        cell.btnImageWithTitle.titleLabel?.font = cell.btnImageWithTitle.isSelected == true ? themeFont(size: 15, fontname: .ProximaNovaBold) :  themeFont(size: 15, fontname: .ProximaNovaRegular)
        
        if dict["selected"].stringValue == "1"
        {
            self.mainModelView.pastSelectedIndex = indexPath.row
        }

        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.mainModelView.arrayHeader[self.mainModelView.pastSelectedIndex]["selected"].stringValue = "0"
        self.mainModelView.arrayHeader[indexPath.row]["selected"].stringValue = "1"
        
        self.mainModelView.carbonTabSwipeNavigation.setCurrentTabIndex(UInt(indexPath.row), withAnimation: true)
        
        collectionView.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.width/2, height: collectionView.bounds.height)
    }
    
}

