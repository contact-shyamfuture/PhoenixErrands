//
//  AppDelegate.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 06/08/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import AVFoundation
import Alamofire
import GoogleMaps
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import UserNotifications
import Braintree
import Stripe
import Fabric
import Crashlytics
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate,MessagingDelegate {

    var window: UIWindow?
    var navigationController: UINavigationController?
    let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.google.com")
    let googleApiKey = "AIzaSyDWx4G3isBWcBaaokwBPZ5UCIYx93bWBjI"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.enable = true
        UINavigationBar.appearance().barTintColor = Constants.App.navigationBarColor
        UINavigationBar.appearance().tintColor = UIColor.darkGray
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.darkGray]
        let loggedInStatus = AppPreferenceService.getInteger(PreferencesKeys.loggedInStatus)
        if loggedInStatus == IS_LOGGED_IN {
            self.openHomeViewController()
        } else {
            self.openSignInViewController()
        }
        
        Stripe.setDefaultPublishableKey("pk_live_93dQgXPBBDqFnoegxjW3O5tM00nh8nZrin")
//        Stripe.setDefaultPublishableKey("pk_test_435bFSr9yOV0nLQRUKiVinYo00OAxhRgNj")
        
        BTAppSwitch.setReturnURLScheme("com.PhoenixErrands.payments")
        Thread.sleep(forTimeInterval: 2.0)
        GMSServices.provideAPIKey(googleApiKey)
        
        //"pk_test_Dtr8UxWla8muiZMcxqdLc3IT00K7qZyDiN"
        //pk_live_93dQgXPBBDqFnoegxjW3O5tM00nh8nZrin
        
        //Sam account
        // pk_test_435bFSr9yOV0nLQRUKiVinYo00OAxhRgNj
        //sk_test_bVtEHlHruzVtZQ2MYg6Ylqwh00a9BoeT0d
        
        //4000002500003155
        
        FirebaseApp.configure()
        Fabric.with([Crashlytics.self])
        Fabric.sharedSDK().debug = true
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        UNUserNotificationCenter.current().delegate = self
        application.registerForRemoteNotifications()
        //FirebaseApp.configure()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.tokenRefreshNotification), name: Notification.Name.MessagingRegistrationTokenRefreshed, object: nil)
        
        //GIDSignIn.sharedInstance().clientID = "321505110953-rrdi1bhiec35e9usncs01si24sdoh67j.apps.googleusercontent.com"
        return true
    }

    @objc func tokenRefreshNotification(_ notification: Notification) {
        
        var token = String()
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            } else if let result = result {
                token = result.token
                print("Remote instance ID token: \(result.token)")
                UserDefaults.standard.setValue(token, forKey: PreferencesKeys.userToken)
            }
        }
        connectToFcm()
    }

    func connectToFcm() {
        Messaging.messaging().delegate = self
//        Messaging.messaging().connect { (error) in
//            if error != nil {
//                print("Unable to connect with FCM. \(error)")
//            } else {
//                print("Connected to FCM.")
//            }
//        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("APNs device token: \(deviceTokenString)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
        if let messageID = userInfo["gcm.message_id"] {
            print("Message ID: \(messageID)")
        }
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if let messageType = userInfo["type"] {
            print("Message ID: \(messageType)")
            getNotificationMessageType(messageType: messageType as! String)
        }
        let state = application.applicationState
        switch state {
        case .inactive:
            print("Inactive")
        case .background:
            print("Background")
            // update badge count here
            application.applicationIconBadgeNumber = application.applicationIconBadgeNumber + 1
        case .active:
            print("Active")
        }
        
//        let notificationType = userInfo["aps"]!["alert"]!!["some-key-I-Need"]! as! String
        
        
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.alert, .badge, .sound])
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
        application.applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let stripeHandled = Stripe.handleURLCallback(with: url)
        if (stripeHandled) {
            return true
        } else {
            // This was not a stripe url – do whatever url handling your app
            // normally does, if any.
        }
        return false
    }

//    // This method handles opening universal link URLs (e.g., "https://example.com/stripe_ios_callback")
//    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
//        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
//            if let url = userActivity.webpageURL {
//                let stripeHandled = Stripe.handleURLCallback(with: url)
//                if (stripeHandled) {
//                    return true
//                } else {
//                    // This was not a stripe url – do whatever url handling your app
//                    // normally does, if any.
//                }
//            }
//        }
//        return false
//    }
    
    
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        return ApplicationDelegate.shared.application(app, open: url, options: options)
//    }
    
    func getNotificationMessageType(messageType : String){
        switch messageType {
        case "NewService":
            self.openAddServiceVCController()
        case "MakeProposal":
            self.openActivityVCController()
        case "AcceptProposal":
            self.openAddServiceVCController()
        default:
            break
        }
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Phoenix_Errands")
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
    
    public func openSignInViewController(){
        AppPreferenceService.setInteger(IS_LOGGED_OUT, key: PreferencesKeys.loggedInStatus)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "IntroVC") as! IntroVC
        navigationController = UINavigationController.init(rootViewController: controller)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.isHidden = true
       // UIApplication.shared.statusBarView?.backgroundColor =  UIColor.white
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.default
        nav?.tintColor = UIColor.black
    }
    
    public func openLoginInViewController(){
        AppPreferenceService.setInteger(IS_LOGGED_OUT, key: PreferencesKeys.loggedInStatus)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        navigationController = UINavigationController.init(rootViewController: controller)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.isHidden = true
       // UIApplication.shared.statusBarView?.backgroundColor =  UIColor.white
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.default
        nav?.tintColor = UIColor.black
    }
    
    public func openHomeViewController(){
        let storyBoard = UIStoryboard(name: "Dashboard", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
        navigationController = UINavigationController.init(rootViewController: controller)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor.blue
    }
    
    public func openAddServiceVCController(){
        let storyBoard = UIStoryboard(name: "Profile", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "AddServiceVC") as! AddServiceVC
        navigationController = UINavigationController.init(rootViewController: controller)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor.blue
    }
    public func openActivityVCController(){
        let storyBoard = UIStoryboard(name: "Activity", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "ActivityVC") as! ActivityVC
        navigationController = UINavigationController.init(rootViewController: controller)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor.blue
    }
    
    public static func appDelagate() -> AppDelegate{
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func isReachable() -> Bool{
        if let isReachable = reachabilityManager?.isReachable {
            return isReachable
        }
        return false
    }
    func startNetworkReachabilityObserver() {
        reachabilityManager?.listener = { status in
            
            switch status {
                
            case .notReachable:
                print("The network is not reachable")
                
            case .unknown :
                print("It is unknown whether the network is reachable")
                
            case .reachable(.ethernetOrWiFi):
                print("The network is reachable over the WiFi connection")
                
            case .reachable(.wwan):
                print("The network is reachable over the WWAN connection")
            }
        }
        reachabilityManager?.startListening()
    }
}

