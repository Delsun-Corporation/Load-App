//
//  MultipleImagesBookmarkTblCell.swift
//  Load
//
//  Created by iMac on 18/03/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import UIKit

class MultipleImagesBookmarkTblCell: UITableViewCell {

    //MARK: - Outlet
    @IBOutlet weak var stackTwoimagesVertically: UIStackView!
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    
    
    //MARK: - View life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI(sectionHeaderName:String, arrayData: [arraySubBookmarkList]?){
        
        if sectionHeaderName.lowercased() == "Professionals".lowercased(){
            self.stackTwoimagesVertically.isHidden = false
            
            
            if arrayData?.count ?? 0 == 0{
                return
            }
            
            let dict = arrayData?[0]

            self.lblName.text = dict?.professionalDetail?.userDetail?.name
            print("Profession array :\(arrayData?.count)")
            
            if arrayData?.count == 1{
                img1.isHidden = false
                img2.isHidden = true
                img3.isHidden = true
                
            self.img1.sd_setImage(with:  dict?.professionalDetail?.userDetail?.photo!.toURL(), completed: nil)

                
            }else if arrayData?.count == 2{
                img1.isHidden = false
                img2.isHidden = false
                img3.isHidden = true
                
                let dict1 = arrayData?[1]
                
                self.img1.sd_setImage(with:  dict?.professionalDetail?.userDetail?.photo!.toURL(), completed: nil)
                self.img2.sd_setImage(with:  dict1?.professionalDetail?.userDetail?.photo!.toURL(), completed: nil)
                
            }else if arrayData?.count ?? 0 > 2{
                img1.isHidden = false
                img2.isHidden = false
                img3.isHidden = false
                
                let dict1 = arrayData?[1]
                let dict2 = arrayData?[2]
                
                self.img1.sd_setImage(with:  dict?.professionalDetail?.userDetail?.photo!.toURL(), completed: nil)
                self.img2.sd_setImage(with:  dict1?.professionalDetail?.userDetail?.photo!.toURL(), completed: nil)
                self.img3.sd_setImage(with:  dict2?.professionalDetail?.userDetail?.photo!.toURL(), completed: nil)
                
            }
            
        }else{
            
            let dict = arrayData?[0]
            
            self.stackTwoimagesVertically.isHidden = true
            self.lblName.text = dict?.eventDetail?.eventName
            self.img1.sd_setImage(with:  dict?.eventDetail?.eventImage?.toURL(), completed: nil)
            print("Event array :\(arrayData?.count)")
        }
        
    }
    
}
