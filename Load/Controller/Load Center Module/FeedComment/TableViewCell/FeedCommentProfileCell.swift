//
//  FeedCommentProfileCell.swift
//  Load
//
//  Created by Haresh Bhai on 21/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import GoogleMaps
import SDWebImage
import BubblePictures

class FeedCommentProfileCell: UITableViewCell {
    
    //MARK:- @IBOutlet
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var imgType: UIImageView!
    @IBOutlet weak var lbltype: UILabel!
    
    @IBOutlet weak var lblFieldOneTitle: UILabel!
    @IBOutlet weak var lblFieldOne: UILabel!
    
    @IBOutlet weak var lblFieldTwoTitle: UILabel!
    @IBOutlet weak var lblFieldTwo: UILabel!
    
    @IBOutlet weak var lblFieldThreeTitle: UILabel!
    @IBOutlet weak var lblFieldThree: UILabel!
    
    @IBOutlet weak var viewMap: GMSMapView!

    @IBOutlet weak var heightViewMap: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var lblLikeCount: UILabel!
    @IBOutlet weak var lblCommentCount: UILabel!

    @IBOutlet weak var collectionWidth: NSLayoutConstraint!
    //MARK:- Variables
    weak var delegate: FeedsActionDelegate?
    private var bubblePictures: BubblePictures!
    var isLiked:Bool = false
    
    //MARK:- Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupFont() {
        self.lblName.font = themeFont(size: 12, fontname: .ProximaNovaBold)
        self.lblDate.font = themeFont(size: 12, fontname: .ProximaNovaRegular)
        self.lbltype.font = themeFont(size: 16, fontname: .ProximaNovaBold)
        self.lblFieldOneTitle.font = themeFont(size: 12, fontname: .ProximaNovaRegular)
        self.lblFieldOne.font = themeFont(size: 20, fontname: .ProximaNovaRegular)
        self.lblFieldTwoTitle.font = themeFont(size: 12, fontname: .ProximaNovaRegular)
        self.lblFieldTwo.font = themeFont(size: 20, fontname: .ProximaNovaRegular)
        self.lblFieldThreeTitle.font = themeFont(size: 12, fontname: .ProximaNovaRegular)
        self.lblFieldThree.font = themeFont(size: 20, fontname: .ProximaNovaRegular)
        self.lblLikeCount.font = themeFont(size: 9, fontname: .ProximaNovaRegular)
        self.lblCommentCount.font = themeFont(size: 9, fontname: .ProximaNovaRegular)

        self.lblName.setColor(color: .appthemeBlackColor)
        self.lblDate.setColor(color: .appthemeBlackColor)
        self.lbltype.setColor(color: .appthemeBlackColor)
        self.lblFieldOneTitle.setColor(color: .appthemeBlackColor)
        self.lblFieldOne.setColor(color: .appthemeBlackColor)
        self.lblFieldTwoTitle.setColor(color: .appthemeBlackColor)
        self.lblFieldTwo.setColor(color: .appthemeBlackColor)
        self.lblFieldThreeTitle.setColor(color: .appthemeBlackColor)
        self.lblFieldThree.setColor(color: .appthemeBlackColor)
        self.lblLikeCount.setColor(color: .appthemeBlackColor)
        self.lblCommentCount.setColor(color: .appthemeBlackColor)

        self.imgProfile.setCircle()
    }
    
    func setupUI(model: FeedList) {
        self.setupFont()
        self.imgProfile.sd_setImage(with: model.userDetail?.photo?.toURL(), completed: nil)
        let str = SERVER_URL + (model.trainingActivity?.iconPath ?? "")
        self.imgType.sd_setImage(with: str.toURL(), completed: { (image, error, type, url) in
            self.imgType.image = image?.withRenderingMode(.alwaysTemplate)
            self.imgType.tintColor = UIColor.appthemeRedColor
        })
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: 48.857165, longitude: 2.354613, zoom: 8.0)
        viewMap.camera = camera
        self.lblName.text = model.userDetail?.name
        self.lblDate.text = convertDateFormater((model.date)!, dateFormat: "MMM dd, yyyy 'at' HH:mm a")
        self.lbltype.text = model.workoutName
        self.lblFieldOneTitle.text = "Completed Vol. (kg)"
        self.lblFieldOne.text = "1222"
        self.lblFieldTwoTitle.text = "Total Exercise"
        self.lblFieldTwo.text = "9"
        self.lblFieldThreeTitle.text = "Duration"
        self.lblFieldThree.text = "1:18:28"
        
        self.setupBubbles(model: model)
        if model.likedDetail != nil {
            self.lblLikeCount.text = self.getLikeStatus(isLiked: (model.likedDetail?.isLiked)!, count: model.likedDetail?.userIds?.count ?? 0)
            self.isLike(isLike: (model.likedDetail?.isLiked)!)
        }
        else {
            self.lblLikeCount.text = "0                                                                     "
        }
        
        if model.likedDetail != nil {
            self.lblLikeCount.text = self.getLikeStatus(isLiked: (model.likedDetail?.isLiked)!, count: model.likedDetail?.userIds?.count ?? 0)
            self.isLike(isLike: (model.likedDetail?.isLiked)!)
        }
        else {
            self.lblLikeCount.text = "0"
        }
        self.lblCommentCount.text = "\(model.commentCount!.intValue) Comments"
    }
    
    func isLike(isLike:Bool) {
        if isLike {
            self.btnLike.setImage(self.btnLike.currentImage!.withRenderingMode(.alwaysTemplate), for: .normal)
            self.btnLike.tintColor = UIColor.appthemeRedColor
        }
        else {
            self.btnLike.setImage(self.btnLike.currentImage!.withRenderingMode(.alwaysTemplate), for: .normal)
            self.btnLike.tintColor = UIColor.appThemeDarkGrayColor
        }
    }
    
    func getLikeStatus(isLiked:Bool, count:Int) -> String {
        print(self.tag)
        var str = ""
        var countNew = count
        if isLiked {
            countNew -= 1
        }
        if countNew <= 0 && isLiked {
            str = "1"
        }
        else if countNew <= 0 {
            str = "0"
        }
        else if isLiked {
            str = "\(countNew)"
        }
        else {
            if self.isLiked {
                str = "\(countNew - 1)"
            }
            else {
                str = "\(countNew)"
            }
        }
        return str
    }
    
    func setupBubbles(model: FeedList) {
        let max = model.userId == getUserDetail()?.data?.user?.id ? 1 : 5
        let configFiles = getConfigFiles(images: model.likedDetail?.images ?? [])
        self.collectionWidth.constant = CGFloat(configFiles.count * 15)
        let layoutConfigurator = BPLayoutConfigurator(
            backgroundColorForTruncatedBubble: UIColor.clear,
            fontForBubbleTitles: UIFont(name: "HelveticaNeue-Light", size: 7.0)!,
            colorForBubbleBorders: UIColor.white,
            colorForBubbleTitles: UIColor.clear,
            maxCharactersForBubbleTitles: 0,
            maxNumberOfBubbles: max,
//            numberForTruncatedCell: 0,
            direction: .leftToRight,
            alignment: .left)
        
        bubblePictures = BubblePictures(collectionView: collectionView, configFiles: configFiles, layoutConfigurator: layoutConfigurator)
        bubblePictures.delegate = self
    }
    
    func getConfigFiles(images: [LikedImages]) -> [BPCellConfigFile] {
        var imagesArray: [BPCellConfigFile] = [BPCellConfigFile]()
        for data in images {
            if data.photo == "" {
                imagesArray.append(BPCellConfigFile(imageType: BPImageType.image(UIImage(named: "ic_menu_splash_holder")!), title: ""))
            }
            else {
                imagesArray.append(BPCellConfigFile(
                    imageType: BPImageType.URL(URL(string: data.photo == "" ? "https://www.apple.com" : data.photo!)!),
                    title: ""))
            }
        }
        return imagesArray
    }
    
    @IBAction func btnLikeClicked(_ sender: Any) {
        self.delegate?.FeedsLikeActionDidFinish(tag: self.tag)
    }  
}

extension FeedCommentProfileCell: BPDelegate {
    func didSelectTruncatedBubble() {
        print("Selected truncated bubble")
    }
    
    func didSelectBubble(at index: Int) {
        print(index)
    }
}
