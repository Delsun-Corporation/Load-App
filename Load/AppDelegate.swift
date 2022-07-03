//
//  AppDelegate.swift
//  Load
//
//  Created by Haresh Bhai on 28/05/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import SwiftyJSON
import GoogleMaps
import GooglePlacePicker
import RealmSwift
import Firebase

@objc protocol updateLatLongDelegate : class {
    func updatedLatLong(lat:Double,long:Double)
}

//Push

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static let shared = UIApplication.shared.delegate as? AppDelegate
    var locationManager = CLLocationManager()
    var lattitude  = Double()
    var longitude = Double()

    var isUpdated:Bool = false
    
    weak var delegateUpadateLatLong : updateLatLongDelegate?
    
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.placeholderColor = UIColor.clear
        IQKeyboardManager.shared.toolbarTintColor = UIColor.appthemeOffRedColor
        IQKeyboardManager.shared.toolbarBarTintColor = UIColor.white
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysHide
        GMSServices.provideAPIKey(GOOGLE_MAP_KEY) //AIzaSyDVZZhqMGMBJo_R-7eGzqRysAcaICxxGt8
        GMSPlacesClient.provideAPIKey(GOOGLE_MAP_KEY)
        self.setUpQuickLocationUpdate()
        if getUserDetail()?.success != nil {
            self.apiCallForDynamicData()
            self.sidemenu()
        }
        
        FirebaseApp.configure()
        
        //add realm
        let cachesDirectoryPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        let cachesDirectoryURL = NSURL(fileURLWithPath: cachesDirectoryPath)
        let fileURL = cachesDirectoryURL.appendingPathComponent("Default.realm")
        
        print("fileUrl:\(fileURL)")
        
//        let config = Realm.Configuration(fileURL: fileURL)
        
        let config = Realm.Configuration(fileURL: fileURL,
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 10,
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
        })
        
        print("config:\(config)")
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config

        realm = try? Realm(configuration: config)
    
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundImage = UIImage(named: "ic_header")?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
        
        // Override point for customization after application launch.
        return true
    }
    
    func sidemenu() {
        SocketIOHandler.shared.Connect()
        let mainVC = SJSwiftSideMenuController()
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        
        let sideVC_L : SidemenuVC = (storyBoard.instantiateViewController(withIdentifier: "SidemenuVC") as? SidemenuVC)!
        
        let rootVC : TabbarVC = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: "TabbarVC") as! TabbarVC
        
        SJSwiftSideMenuController.setUpNavigation(rootController: rootVC, leftMenuController: sideVC_L, rightMenuController: nil, leftMenuType: .SlideView, rightMenuType: .SlideView)
        
        SJSwiftSideMenuController.enableSwipeGestureWithMenuSide(menuSide: .LEFT)
        
        SJSwiftSideMenuController.enableDimbackground = true
        SJSwiftSideMenuController.leftMenuWidth = UIScreen.main.bounds.width - 80
        //=======================================
        
        self.window?.rootViewController = mainVC
        self.window?.makeKeyAndVisible()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Load")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    func apiCallForDynamicData() {
        let param = ["":""]
        ApiManager.shared.MakeGetAPIWithoutAuth(name: GET_ALL_DATA, params: param as [String : Any], progress: true, vc: UIViewController()) { (response, error) in
            if response != nil {
                let json = JSON(response!)
//                print(json)
                let result = LoginModelClass(JSON: json.dictionaryObject!)
                if (result?.success)! {
                    GetAllData = GetAllDataModelClass(JSON: json.dictionaryObject!)
                }
                else {
                    makeToast(strMessage: (result?.message ?? ""))
                }
            }
        }
    }

    func apiCallForUpdateLatitudeLongitude() {
        guard let userID = getUserDetail()?.data?.user?.id?.stringValue else {
            deleteJSON(key: USER_DETAILS_KEY)
            AppDelegate.shared?.openLoginScreen()
            return
        }
        
        let param = ["id": userID, "latitude": String(self.lattitude), "longitude": String(self.longitude)] as [String : Any]
        ApiManager.shared.MakePostAPI(name: UPDATE_LATITUDE_LONGITUDE, params: param as [String : Any], progress: false, vc: UIViewController(), isAuth: false) { (response, error) in
            if let response = response {
                _ = JSON(response)
                // print(json)
            }
        }
    }
    
    func openLoginScreen() {
        let obj : LoginVC = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        let nav = UINavigationController(rootViewController: obj)
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
    }
}

//MARK: - Location Delegate

extension AppDelegate:CLLocationManagerDelegate {
    func setUpQuickLocationUpdate() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10
        locationManager.activityType = .fitness
//        locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.startUpdatingLocation()
          locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let latestLocation = locations.first {
            print("latestLocation:=\(latestLocation.coordinate.latitude), *=\(latestLocation.coordinate.longitude)")
            //  KSToastView.ks_showToast("Location Update Successfully", duration: ToastDuration)
            
            //Remove delegate here from inside
            
            if lattitude != latestLocation.coordinate.latitude && longitude != latestLocation.coordinate.longitude {
                
                delegateUpadateLatLong?.updatedLatLong(lat: latestLocation.coordinate.latitude, long: latestLocation.coordinate.longitude)
                
                userCurrentLocation = latestLocation
                lattitude = latestLocation.coordinate.latitude
                longitude = latestLocation.coordinate.longitude
                print("lattitude:- \(String(describing: userCurrentLocation?.coordinate.latitude) ), longitude:- \(String(describing: userCurrentLocation?.coordinate.longitude))")
                if getUserDetail()?.success != nil && !self.isUpdated {
                    self.isUpdated = true
                    self.apiCallForUpdateLatitudeLongitude()
                }
            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error :- \(error)")
        
    }
    
}
    
