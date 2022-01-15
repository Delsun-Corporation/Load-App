//
//  ListingUserListCell.swift
//  Load
//
//  Created by Haresh Bhai on 20/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol ListingUserProfileDelegate: class {
    func ListingUserProfileDidFinish(id:String,index: Int)
}

class ListingUserListCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    //MARK:- @IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK:- Variables
    weak var delegate:ListingUserProfileDelegate?
    var professionalUserList: [ProfessionalData] = [ProfessionalData]()
    
    //MARK:- Functions
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setupUI(model: [ProfessionalData]) {
        self.professionalUserList = model
        print(model.count)
        let nibName = UINib(nibName: "ListingUserCell", bundle:nil)
        self.collectionView.register(nibName, forCellWithReuseIdentifier: "ListingUserCell")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.professionalUserList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "ListingUserCell", for: indexPath) as! ListingUserCell
        cell.setupUI(model: self.professionalUserList[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.ListingUserProfileDidFinish(id: (self.professionalUserList[indexPath.row].id?.stringValue)!,index: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 175, height: 160)
    }
}
