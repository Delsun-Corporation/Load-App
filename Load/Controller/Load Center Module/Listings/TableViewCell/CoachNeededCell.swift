//
//  CoachNeededCell.swift
//  Load
//
//  Created by Haresh Bhai on 20/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit


protocol redirectToDetailScreenDelegate {
    func redirectToDetailScreen(data: RequestList)
}


class CoachNeededCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    //MARK:- @IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK:- Variables
    var requestList: [RequestList] = [RequestList]()

    var delegate : redirectToDetailScreenDelegate?
    
    //MARK:- Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI(model: [RequestList]) {
        self.requestList = model
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.isPagingEnabled = true
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.register(UINib.init(nibName: "CoachNeededCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CoachNeededCollectionViewCell")
        self.collectionView.reloadData()
    }
    
    //MARK:- CollectionView Delegates
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.requestList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CoachNeededCollectionViewCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "CoachNeededCollectionViewCell", for: indexPath) as! CoachNeededCollectionViewCell
        cell.setupUI(model: self.requestList[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 152)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("Dataaa: \(self.requestList[indexPath.row])")
        
        if Int(self.requestList[indexPath.row].userId ?? 0) == (getUserDetail().data?.user?.id?.intValue)!{
            delegate?.redirectToDetailScreen(data: self.requestList[indexPath.row])
        }
    }
}
