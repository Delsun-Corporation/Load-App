//
//  ListingUserListCell.swift
//  Load
//
//  Created by Haresh Bhai on 20/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol ProfileUserProfileDelegate: class {
    func ProfileUserProfileDidFinish(id:String)
}

class ProfileUserListCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    //MARK:- @IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK:- Variables
    weak var delegate:ProfileUserProfileDelegate?
    var professionalUserList: [NearestProfessionalProfile] = [NearestProfessionalProfile]()
    
    //MARK:- Functions
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setupUI(model: [NearestProfessionalProfile]) {
        self.professionalUserList = model
        print(model.count)
        let nibName = UINib(nibName: "ProfileUserCell", bundle:nil)
        self.collectionView.register(nibName, forCellWithReuseIdentifier: "ProfileUserCell")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.professionalUserList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileUserCell", for: indexPath) as! ProfileUserCell
        cell.setupUI(model: self.professionalUserList[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.ProfileUserProfileDidFinish(id: (self.professionalUserList[indexPath.row].id?.stringValue)!)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(DEVICE_TYPE.SCREEN_WIDTH)/CGFloat(1.8), height: 167)
    }
}
