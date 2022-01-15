//
//  EventPremiumUserTblCell.swift
//  Load
//
//  Created by Yash on 01/07/21.
//  Copyright © 2021 Haresh Bhai. All rights reserved.
//

import UIKit

class EventPremiumUserTblCell: UITableViewCell {

    //MARK:- Outlet
    
    @IBOutlet weak var lblEventName: UILabel!
    @IBOutlet weak var collectionViewEvent: UICollectionView!
    
    //MARK:- View life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupFont()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupFont(){
     
        lblEventName.textColor = .appthemeBlackColor
        lblEventName.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.collectionViewEvent.register(UINib(nibName: "EventPremiumCollectionCell", bundle:nil), forCellWithReuseIdentifier: "EventPremiumCollectionCell")

        collectionViewEvent.delegate = self
        collectionViewEvent.dataSource = self
        
    }
    
}

//MARK: - CollectionView delegate and DataSource

extension EventPremiumUserTblCell: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionViewEvent.dequeueReusableCell(withReuseIdentifier: "EventPremiumCollectionCell", for: indexPath) as! EventPremiumCollectionCell
//        cell.setupUI(model: self.professionalUserList[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        self.delegate?.ProfileUserProfileDidFinish(id: (self.professionalUserList[indexPath.row].id?.stringValue)!)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(DEVICE_TYPE.SCREEN_WIDTH)/CGFloat(1.8), height: 167)
    }

    
}
