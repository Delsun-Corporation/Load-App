//
//  EventOtherEventCell.swift
//  Load
//
//  Created by Haresh Bhai on 18/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SDWebImage

class EventOtherEventCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    //MARK:- @IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK:- Variables
    var eventDetails:EventDetailsModelClass?

    //MARK:- Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setupUI(eventDetails:EventDetailsModelClass) {
        self.eventDetails = eventDetails
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib.init(nibName: "EventOtherEventListCell", bundle: nil), forCellWithReuseIdentifier: "EventOtherEventListCell")
        self.collectionView.reloadData()
    }
    
    //MARK:- CollectionView Delegates
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.eventDetails?.nearestEvents?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: EventOtherEventListCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "EventOtherEventListCell", for: indexPath) as! EventOtherEventListCell
        cell.setupUI(model: (self.eventDetails?.nearestEvents![indexPath.row])!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180, height: 181)
    }
}
