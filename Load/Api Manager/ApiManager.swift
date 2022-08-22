//
//  ApiManager.swift
//  Berry
//
//  Created by Haresh Bhai on 29/10/18.
//  Copyright © 2018 Haresh Bhai. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView
import SwiftyJSON
import Reachability
import SystemConfiguration

class ApiManager: NSObject {
    
    static var shared = ApiManager()
    
    func showProgress(vc: UIViewController) {
        let LoaderString:String = "Loading..."
        let LoaderSize = CGSize(width: 30, height: 30)
        
        vc.startAnimating(LoaderSize, message: LoaderString, type: NVActivityIndicatorType.circleStrokeSpin)
    }
    
    func isNetworkReachable(with flags: SCNetworkReachabilityFlags) -> Bool {
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        let canConnectWithoutUserInteraction = canConnectAutomatically && !flags.contains(.interventionRequired)
        
        return isReachable && (!needsConnection || canConnectWithoutUserInteraction)
    }
    
    //MARK: - Post
    func MakePostAPI(name:String, params:[String:Any], progress: Bool = true, vc: UIViewController, isAuth:Bool = true, completionHandler: @escaping (NSDictionary?, String?)-> Void) {

        guard ReachabilityTest.isConnectedToNetwork() else {
            makeToast(strMessage: "No internet connection available")
            return
        }
        
        if progress {
            showProgress(vc: vc)
        }
        
        var headers:[String : String] = [:]
        if getUserDetail()?.success != nil {
            let base64Credentials = (getUserDetail()?.data?.tokenType ?? "") + " " + (getUserDetail()?.data?.accessToken ?? "")
            if newApiConfig {
                print("This is access token \(getUserDetail()?.data?.accessToken)")
                headers = ["Authorization": (getUserDetail()?.data?.accessToken ?? ""), "Content-Type": "application/json"]
            }
            else {
                headers = ["Authorization": base64Credentials, "Content-Type": "application/json"]
            }
            
        }
        else {
            headers = ["Content-Type": "application/json"]
        }
        print(headers)
        
        
        
        var base = isAuth ? BASE_URL_AUTH : BASE_URL
        if (newApiConfig) {
            base = BASE_URL_v2
        }
        let url = base + name
        print(url)
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            print(response)
            
            if progress {
                vc.stopAnimating()
            }
            switch response.result {
            case .success( _):
                if(response.error == nil) {
                    completionHandler(response.result.value as? NSDictionary, nil)
                }
                else {
                    completionHandler(nil, SERVER_VALIDATION)
                }
            case .failure( _):
                completionHandler(nil, SERVER_VALIDATION)
            }
        }.resume()
    }
    
    
    //MARK: - Get
    func MakeGetAPI(name:String, params:[String:Any], progress: Bool = true, vc: UIViewController, isAuth:Bool = true, completionHandler: @escaping (NSDictionary?, String?)-> Void) {
        
        guard ReachabilityTest.isConnectedToNetwork() else {
            makeToast(strMessage: "No internet connection available")
            return
        }
        
        if progress {
            showProgress(vc: vc)
        }
        
        var headers:[String : String] = [:]
        if getUserDetail()?.success != nil {
            let base64Credentials = (getUserDetail()?.data?.tokenType ?? "") + " " + (getUserDetail()?.data?.accessToken ?? "")
            if newApiConfig {
                headers = ["Authorization": (getUserDetail()?.data?.accessToken ?? ""), "Content-Type": "application/json"]
            }
            else {
                headers = ["Authorization": base64Credentials, "Content-Type": "application/json"]
            }
        }
        else {
            headers = ["Content-Type": "application/json"]
        }
        print(headers)
        
        var base = isAuth ? BASE_URL_AUTH : BASE_URL
        if (newApiConfig) {
            base = BASE_URL_v2
        }
        let url = base + name

        print(url)
        print(params)
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            
            if progress {
                vc.stopAnimating()
            }
            print(response)

            switch response.result {
            case .success( _):
                if(response.error == nil) {
                    completionHandler(response.result.value as? NSDictionary, nil)
                }
                else {
                    completionHandler(nil, SERVER_VALIDATION)
                }
            case .failure( _):
                completionHandler(nil, SERVER_VALIDATION)
            }
        }.resume()
    }
    
    func MakeGetAPIWithoutAuth(name:String, params:[String:Any], progress: Bool = true, vc: UIViewController, completionHandler: @escaping (NSDictionary?, String?)-> Void) {
        
        guard ReachabilityTest.isConnectedToNetwork() else {
            makeToast(strMessage: "No internet connection available")
            return
        }
        
        if progress {
            showProgress(vc: vc)
        }
        
        var headers:[String : String] = [:]
        if getUserDetail()?.success != nil {
            let base64Credentials = (getUserDetail()?.data?.tokenType ?? "") + " " + (getUserDetail()?.data?.accessToken ?? "")
            if newApiConfig {
                headers = ["Authorization": (getUserDetail()?.data?.accessToken ?? ""), "Content-Type": "application/json"]
            }
            else {
                headers = ["Authorization": base64Credentials, "Content-Type": "application/json"]
            }
        }
        else {
            headers = ["Content-Type": "application/json"]
        }
        print(headers)
        
        var url = BASE_URL + name
        if (newApiConfig) {
            url = BASE_URL_v2 + name
        }
        print(url)
        print(params)
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers).validate().responseJSON { (response) in
            print(response)
            
            if progress {
                vc.stopAnimating()
            }
            switch response.result {
            case .success( _):
                if(response.error == nil) {
                    completionHandler(response.result.value as? NSDictionary, nil)
                }
                else {
                    completionHandler(nil, SERVER_VALIDATION)
                }
            case .failure( _):
                completionHandler(nil, SERVER_VALIDATION)
            }
            }.resume()
    }
    
    func MakeGetAPIWithoutBaseURLAndAuth(name:String, progress: Bool = true, vc: UIViewController, completionHandler: @escaping (NSDictionary?, String?)-> Void) {
        
        guard ReachabilityTest.isConnectedToNetwork() else {
            makeToast(strMessage: "No internet connection available")
            return
        }
        
        if progress {
            showProgress(vc: vc)
        }
        
        let headers:[String : String] = ["Content-Type": "application/json"]
        print(headers)
        
        let url = name
        print(url)
        Alamofire.request(url, method: .get, parameters: [:], encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            print(response)
            
            if progress {
                vc.stopAnimating()
            }
            switch response.result {
            case .success( _):
                if(response.error == nil) {
                    completionHandler(response.result.value as? NSDictionary, nil)
                }
                else {
                    completionHandler(nil, SERVER_VALIDATION)
                }
            case .failure( _):
                completionHandler(nil, SERVER_VALIDATION)
            }
            }.resume()
    }

    //MARK: - Put
    func MakePutAPI(name:String, params:[String:Any], progress: Bool = true, vc: UIViewController, isAuth:Bool = true, completionHandler: @escaping (NSDictionary?, String?)-> Void) {

        guard ReachabilityTest.isConnectedToNetwork() else {
            makeToast(strMessage: "No internet connection available")
            return
        }
        
        if progress {
            showProgress(vc: vc)
        }
        
        var headers:[String : String] = [:]
        if getUserDetail()?.success != nil {
            let base64Credentials = (getUserDetail()?.data?.tokenType ?? "") + " " + (getUserDetail()?.data?.accessToken ?? "")
            if newApiConfig {
                headers = ["Authorization": (getUserDetail()?.data?.accessToken ?? ""), "Content-Type": "application/json"]
            }
            else {
                headers = ["Authorization": base64Credentials, "Content-Type": "application/json"]
            }
        }
        else {
            headers = ["Content-Type": "application/json"]
        }
        print(headers)
        
        var base = isAuth ? BASE_URL_AUTH : BASE_URL
        if (newApiConfig) {
            base = BASE_URL_v2
        }
        let url = base + name
        print(url)
        print(JSON(params))

        Alamofire.request(url, method: .put, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            print(response)
            
            if progress {
                vc.stopAnimating()
            }
            
            switch response.result {
            case .success( _):
                if(response.error == nil) {
                    completionHandler(response.result.value as? NSDictionary, nil)
                }
                else {
                    completionHandler(nil, SERVER_VALIDATION)
                }
            case .failure( _):
                completionHandler(nil, SERVER_VALIDATION)
            }
        }.resume()
    }
    
    func MakeDeleteAPI(name:String, params:[String:Any], progress: Bool = true, vc: UIViewController, isAuth:Bool = true, completionHandler: @escaping (NSDictionary?, String?)-> Void) {
        
        guard ReachabilityTest.isConnectedToNetwork() else {
            makeToast(strMessage: "No internet connection available")
            return
        }
        
        if progress {
            showProgress(vc: vc)
        }
        
        var headers:[String : String] = [:]
        if getUserDetail()?.success != nil {
            let base64Credentials = (getUserDetail()?.data?.tokenType ?? "") + " " + (getUserDetail()?.data?.accessToken ?? "")
            if newApiConfig {
                headers = ["Authorization": (getUserDetail()?.data?.accessToken ?? ""), "Content-Type": "application/json"]
            }
            else {
                headers = ["Authorization": base64Credentials, "Content-Type": "application/json"]
            }
        }
        else {
            headers = ["Content-Type": "application/json"]
        }
        print(headers)
        
        var base = isAuth ? BASE_URL_AUTH : BASE_URL
        if (newApiConfig) {
            base = BASE_URL_v2
        }
        let url = base + name
        print(url)
        print(JSON(params))
        
        Alamofire.request(url, method: .delete, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            if progress {
                vc.stopAnimating()
            }
            
            switch response.result {
            case .success( _):
                if(response.error == nil) {
                    completionHandler(response.result.value as? NSDictionary, nil)
                }
                else {
                    completionHandler(nil, SERVER_VALIDATION)
                }
            case .failure( _):
                completionHandler(nil, SERVER_VALIDATION)
            }
            }.resume()
    }
    
    //MARK: - Post with Image upload
    func MakePostWithImageAPI(name:String, params:[String:Any], images:[UIImage], imageName:String = "photo", progress: Bool = true, vc: UIViewController, isAuth:Bool = true, completionHandler: @escaping (NSDictionary?, String?)-> Void)
    {
        guard ReachabilityTest.isConnectedToNetwork() else {
            makeToast(strMessage: "No internet connection available")
            return
        }
        
        if progress {
            showProgress(vc: vc)
        }
        
        var headers:[String : String] = [:]
        if getUserDetail()?.success != nil {
            let base64Credentials = (getUserDetail()?.data?.tokenType ?? "") + " " + (getUserDetail()?.data?.accessToken ?? "")
            if newApiConfig {
                headers = ["Authorization": (getUserDetail()?.data?.accessToken ?? ""), "Content-Type": "application/json"]
            }
            else {
                headers = ["Authorization": base64Credentials, "Content-Type": "application/json"]
            }
        }
        else {
            headers = ["Content-Type": "application/json"]
        }
        print(headers)
        
        var base = isAuth ? BASE_URL_AUTH : BASE_URL
        if (newApiConfig) {
            base = BASE_URL_v2
        }
        let url = base + name
        print(url)
        print(params)
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for image in images {
                multipartFormData.append(image.jpeg(.medium) ?? Data(), withName: imageName,fileName: "\(randomString(length: 5)).jpg", mimeType: "image/jpg")
            }
            
            for (key, value) in params {
                multipartFormData.append((value as? String)?.data(using: String.Encoding.utf8) ?? Data(), withName: key)
            }
        }, to: url, method:.post,
           headers:headers, encodingCompletion: { result in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON(completionHandler: { (response) in
                    
                    if progress {
                        vc.stopAnimating()
                    }
//                    print(response)
                    
                    if(response.error == nil) {                       
                        completionHandler(response.result.value as? NSDictionary, nil)
                    }
                    else {
                        completionHandler(nil, SERVER_VALIDATION)
                    }
                })
            case .failure( _):
                completionHandler(nil, SERVER_VALIDATION)
            }
        })
    }
    
    //MARK: - PayPal Post
    func MakePayPalPostAPI(name:String, params:[String:Any], progress: Bool = true, vc: UIViewController, completionHandler: @escaping (NSDictionary?, String?)-> Void) {
        
        guard ReachabilityTest.isConnectedToNetwork() else {
            makeToast(strMessage: "No internet connection available")
            return
        }
        
        if progress {
            showProgress(vc: vc)
        }
        
        guard let credentialData = "\(PAYPAL_USERNAME):\(PAYPAL_PASSWORD)".data(using: String.Encoding.utf8) else {
            return
        }
        let base64Credentials = credentialData.base64EncodedString(options: [])
        
        let headers:[String : String] = ["Authorization": "Basic \(base64Credentials)", "Content-Type": "application/x-www-form-urlencoded"]
        print(headers)
        
        let url = name
        print(url)
        print(params)
        
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            print(response)

            if progress {
                vc.stopAnimating()
            }
            switch response.result {
            case .success( _):
                if(response.error == nil) {
                    completionHandler(response.result.value as? NSDictionary, nil)
                }
                else {
                    completionHandler(nil, SERVER_VALIDATION)
                }
            case .failure( _):
                completionHandler(nil, SERVER_VALIDATION)
            }
        }.resume()
    }
    
    func MakePayPalPostSaveCardAPI(name:String, params:[String:Any], progress: Bool = true, vc: UIViewController, Authorization:String = "", completionHandler: @escaping (NSDictionary?, String?)-> Void) {
        
        guard ReachabilityTest.isConnectedToNetwork() else {
            makeToast(strMessage: "No internet connection available")
            return
        }
        
        if progress {
            showProgress(vc: vc)
        }
        
        let headers:[String : String] = ["Authorization": Authorization, "Content-Type": "application/json"]
        print(headers)
        
        let url = name
        print(url)
        print(params)
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            print(response)
            
            if progress {
                vc.stopAnimating()
            }
            switch response.result {
            case .success( _):
                if(response.error == nil) {
                    completionHandler(response.result.value as? NSDictionary, nil)
                }
                else {
                    completionHandler(nil, SERVER_VALIDATION)
                }
            case .failure( _):
                completionHandler(nil, SERVER_VALIDATION)
            }
            }.resume()
    }
    
    func MakePayPalGetCardAPI(name:String, params:[String:Any], progress: Bool = true, vc: UIViewController, Authorization:String = "", completionHandler: @escaping (NSDictionary?, String?)-> Void) {
        
        guard ReachabilityTest.isConnectedToNetwork() else {
            makeToast(strMessage: "No internet connection available")
            return
        }
        
        if progress {
            showProgress(vc: vc)
        }
        
        let headers:[String : String] = ["Authorization": Authorization, "Content-Type": "application/json"]
        print(headers)
        
        let url = name
        print(url)
        print(params)
        
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            print(response)
            
            if progress {
                vc.stopAnimating()
            }
            switch response.result {
            case .success( _):
                if(response.error == nil) {
                    completionHandler(response.result.value as? NSDictionary, nil)
                }
                else {
                    completionHandler(nil, SERVER_VALIDATION)
                }
            case .failure( _):
                completionHandler(nil, SERVER_VALIDATION)
            }
            }.resume()
    }
}
