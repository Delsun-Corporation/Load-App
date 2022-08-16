//
//  LibraryExercisePreviewDetailsVC.swift
//  Load
//
//  Created by Haresh Bhai on 13/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SwiftyJSON
import XCDYouTubeKit
import AVKit


class LibraryExercisePreviewDetailsVC: UIViewController {

    //MARK:- Variables
    lazy var mainView: LibraryExercisePreviewDetailsView = { [unowned self] in 
        return self.view as! LibraryExercisePreviewDetailsView
    }()
    
    lazy var mainModelView: LibraryExercisePreviewDetailsViewModel = {
        return LibraryExercisePreviewDetailsViewModel(theController: self)
    }()
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainView.setupUI(theController: self)
        self.mainModelView.setupUI()
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnTargetMuscleTapped(_ sender: UIButton) {
        
        let vc = AppStoryboard.Library.instance.instantiateViewController(withIdentifier: "TargetMusclesVc") as! TargetMusclesVc
        vc.isCheckController = .onlyShow
        vc.selectedTargetValue = mainView.lblTargetedMuscles.text ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnLinkTapped(_ sender: UIButton) {
        
        if sender.isSelected == true{
            
            let videoUrl = self.mainView.txtLink.text.toTrim()
            
            if videoUrl.contains("vimeo"){
                
                let vimeoId = self.getVimeoVideoString(strStreamingURL: videoUrl)

                let obj = AppStoryboard.Library.instance.instantiateViewController(withIdentifier: "LoadVimeoVideoVc") as! LoadVimeoVideoVc
                obj.vimeoId = vimeoId
                obj.modalPresentationStyle = .fullScreen
                self.present(obj, animated: true, completion: nil)
                
            }else{
                self.youtubeVideoPlay()
            }
        }
    }
    
    //MARK: - Other function
    
    func youtubeVideoPlay(){
        
        let weakPlayerViewController =  AVPlayerViewController()
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch(let error) {
            print(error.localizedDescription)
        }

        let youtubeId = self.mainView.txtLink.text.toTrim().youtubeID ?? ""
        self.showLoader()
        
        XCDYouTubeClient.default().getVideoWithIdentifier(youtubeId) { [weak self] (video, error) in
            
            self?.hideLoader()
            
            if video != nil {
                let streamURLs = video?.streamURLs
                let streamURL = streamURLs?[XCDYouTubeVideoQualityHTTPLiveStreaming] ?? streamURLs?[NSNumber(value: XCDYouTubeVideoQuality.HD720.rawValue)] ?? streamURLs?[NSNumber(value: XCDYouTubeVideoQuality.medium360.rawValue)] ?? streamURLs?[NSNumber(value: XCDYouTubeVideoQuality.small240.rawValue)]
                if let streamURL = streamURL {
                    weakPlayerViewController.player = AVPlayer(url: streamURL)
                }
                
                self?.present(weakPlayerViewController, animated: true) {
                    weakPlayerViewController.player?.play()
                }
            }
        }
    }
    
}


//MARK: - UITextView delegate

extension LibraryExercisePreviewDetailsVC: UITextViewDelegate{
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.mainView.txtLink.placeholder = ""
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text.toTrim() == ""{
            self.mainView.txtLink.placeholder = getCommonString(key: "Provide_the_exercise_URL_link_key")
            self.mainView.txtLink.text = ""
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        print("trim:\(textView.text.toTrim())")
        print("trim:\(textView.text.count)")
        
        if textView.text.toTrim() != "" && textView.text.count > 18{
            
            if textView.text.lowercased().contains("youtube".lowercased()){
                
                if textView.text.count > 31{
                    print("check youtube url")
                    
                    self.checkYouTubeURLWithAPI(urlString: textView.text.toTrim()){ [weak self] json in
                        
                        if json == nil{
                            self?.mainView.btnLink.isSelected = false
                        }else{
                            self?.mainView.btnLink.isSelected = true
                        }
                        
                    }
                
                }else{
                    self.mainView.btnLink.isSelected = false
                }
                
            }else if textView.text.lowercased().contains("vimeo".lowercased()){
                
                if textView.text.count > 18{
                    print("check vimeo url")
                    self.checkVimeoURLWithAPI(urlString: textView.text.toTrim()){ [weak self] json in
                        
                        if json == nil{
                            self?.mainView.btnLink.isSelected = false
                        }else{
                            self?.mainView.btnLink.isSelected = true
                        }
                        
                    }
                }
                
            }else{
              //  makeToast(strMessage: getCommonString(key: "Please_input_links_from_Youtube_or_Vimeo_key"))
            }
        }else{
            self.mainView.btnLink.isSelected = false
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.toTrim() == ""{
            
        }else{
            self.mainModelView.apiCallCommonUpdateLibrary(txtData: textView.text.toTrim())
            
        }
    }
    
}

