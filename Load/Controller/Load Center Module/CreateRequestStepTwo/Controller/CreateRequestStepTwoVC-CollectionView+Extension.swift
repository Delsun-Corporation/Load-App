//
//  CreateRequestStepTwoVC-CollectionView+Extension.swift
//  Load
//
//  Created by Haresh Bhai on 27/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

extension CreateRequestStepTwoVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SpecializationDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (GetAllData!.data?.specializations?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.mainView.collectionView.dequeueReusableCell(withReuseIdentifier: "SpecializationCell", for: indexPath) as! SpecializationCell
        let data = GetAllData!.data?.specializations![indexPath.row]
        let array = self.mainModelView.selectedSpecialization
        let isContain = array.contains((data?.id?.stringValue)!)
        cell.isSelectedTag = isContain
        cell.delegate = self
        cell.setupUI(model: data!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let data = GetAllData!.data?.specializations![indexPath.row]
        let size = data!.name?.widthOfString(usingFont: themeFont(size: 15, fontname: .Helvetica))
        return CGSize(width: size! + 40, height: 30)
    }
    
    func SpecializationDidFinish(id: String) {
        let array = self.mainModelView.selectedSpecialization
        let isContain = array.contains(id)
        if isContain {
            var index: Int = 0
            for (i, value) in array.enumerated() {
                if value == id {
                    index = i
                }
            }
            self.mainModelView.selectedSpecialization.remove(at: index)
        }
        else {
            self.mainModelView.selectedSpecialization.append(id)
        }
        print(self.mainModelView.selectedSpecialization)
    }    
}
