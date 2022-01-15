//
//  CoachNeededCollectionViewCell.swift
//  Load
//
//  Created by Haresh Bhai on 20/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class CoachNeededCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {  
    
    //MARK:- @IBOutlet
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK:- Variables
    var requestList: RequestList?

    
    //MARK:- Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }    
    
    func setupUI(model: RequestList) {
        self.setupFont()
        self.requestList = model
        self.imgProfile.sd_setImage(with: model.userDetail?.photo!.toURL(), completed: nil)
        self.lblName.text = model.userDetail?.name
       
        self.lblLocation.text = model.countryData?.name ?? ""
        
        self.lblTitle.text = model.title
        self.lblDescription.text = model.yourself
        self.lblDate.text = convertDateFormater(model.startDate!, dateFormat: "dd MMM")
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.register(UINib.init(nibName: "SpecializationDetailsCell", bundle: nil), forCellWithReuseIdentifier: "SpecializationDetailsCell")
        self.collectionView.reloadData()
    }
    
    func setupFont() {
        self.lblName.font = themeFont(size: 13, fontname: .ProximaNovaRegular)
        self.lblLocation.font = themeFont(size: 10, fontname: .ProximaNovaRegular)
        self.lblDate.font = themeFont(size: 10, fontname: .ProximaNovaRegular)
        self.lblTitle.font = themeFont(size: 16, fontname: .ProximaNovaBold)
        self.lblDescription.font = themeFont(size: 14, fontname: .ProximaNovaRegular)
        
        self.lblName.setColor(color: .appthemeWhiteColor)
        self.lblLocation.setColor(color: .appthemeWhiteColor)
        self.lblDate.setColorWithAlpha(color: .appthemeWhiteColor, set: 5)
        self.lblTitle.setColor(color: .appthemeWhiteColor)
        self.lblDescription.setColor(color: .appthemeWhiteColor)
        self.imgProfile.setCircle()
    }
    
    //MARK:- CollectionView Delegates
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {       
        return self.requestList?.specializationDetails?.count ?? 00
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SpecializationDetailsCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "SpecializationDetailsCell", for: indexPath) as! SpecializationDetailsCell
        cell.lblTitle.setTitle(str: (self.requestList?.specializationDetails?[indexPath.row].name)!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.requestList?.specializationDetails?[indexPath.row].name?.widthOfString(usingFont: themeFont(size: 13, fontname: .ProximaNovaRegular))
        return CGSize(width: width! + 20, height: 25)
    }
}
