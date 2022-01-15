//
//  LoadVimeoVidoVc.swift
//  Load
//
//  Created by iMac on 08/03/21.
//  Copyright © 2021 Haresh Bhai. All rights reserved.
//

import UIKit
import WebKit
import AVKit

class LoadVimeoVideoVc: UIViewController {

    //MARK: - Outlet
    @IBOutlet weak var webViewVimeo: WKWebView!
    
    //MARK; - Variable
    var vimeoId = ""
    var activityIndicator: UIActivityIndicatorView!

    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupWebView()
        
        let embedHTML="<iframe src=\"https://player.vimeo.com/video/\(vimeoId)?autoplay=0&app_id=122963\" width=\"100%\" height=\"100%\" frameborder=\"0\" allow=\"fullscreen; picture-in-picture\" allowfullscreen></iframe>"
        
        let url = URL(string: "https://")!
        self.webViewVimeo.loadHTMLString(embedHTML as String, baseURL:url )
        self.webViewVimeo.navigationDelegate = self
        
        self.startIndicatorAnimation()
        
        NotificationCenter.default.addObserver(self, selector: #selector(dismissPlayerController), name: .kAVPlayerViewControllerDismissingNotification, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: .kAVPlayerViewControllerDismissingNotification, object: nil)
    }
    
    //MARK:  - other funcation
    
    @objc func dismissPlayerController(){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func setupWebView(){
        self.webViewVimeo.scrollView.bounces = false
        self.webViewVimeo.scrollView.alwaysBounceVertical = false
        self.webViewVimeo.scrollView.showsVerticalScrollIndicator = false
        self.webViewVimeo.contentMode = .scaleAspectFit
        self.webViewVimeo.isOpaque = false
        self.webViewVimeo.backgroundColor = UIColor.black
        self.webViewVimeo.scrollView.backgroundColor = UIColor.black
        self.webViewVimeo.configuration.mediaTypesRequiringUserActionForPlayback = .video
    }
    
    func startIndicatorAnimation(){
        
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = self.view.center
        activityIndicator.style = UIActivityIndicatorView.Style.white

        self.webViewVimeo.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
    }
    
    //MARK: - IBaction method
    
    @IBAction func btnCloseTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

//MARK: - WKNavigation Delegate
extension LoadVimeoVideoVc: WKNavigationDelegate{
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
    }
}


extension Notification.Name {
    static let kAVPlayerViewControllerDismissingNotification = Notification.Name.init("dismissing")
}

extension AVPlayerViewController {
    // override 'viewWillDisappear'
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // and then , post a simple notification and observe & handle it, where & when you need to.....
        NotificationCenter.default.post(name: .kAVPlayerViewControllerDismissingNotification, object: nil)
    }
}
