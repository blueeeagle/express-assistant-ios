//
//  AppDelegate.swift
//  ExpressAssist
//
//  Created by Apple on 26/08/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import GoogleMaps
import FirebaseMessaging
import Firebase
var strDeviceToken = ""
var isShowPaymtPop = false

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UITabBarControllerDelegate, MessagingDelegate {

    var selectTab = 0
    var objNavigation: UINavigationController!
     var tabBarController: UITabBarController!
     var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
         
        print("***************")
        
         GMSServices.provideAPIKey("AIzaSyBXZ_3YlzUov8dwwDYpbT5XxTodQckgtHY")
        FirebaseApp.configure()

               // [START set_messaging_delegate]
               Messaging.messaging().delegate = self

                  if #available(iOS 10.0, *) {
                      // For iOS 10 display notification (sent via APNS)
                      UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate

                      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                      UNUserNotificationCenter.current().requestAuthorization(
                          options: authOptions,
                          completionHandler: {_, _ in })
                  } else {
                      let settings: UIUserNotificationSettings =
                          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                      application.registerUserNotificationSettings(settings)
                  }

                  application.registerForRemoteNotifications()
        
        let checkLanguage = UserDefaults.standard.bool(forKey:"ar")
              if checkLanguage == false
              {
                  Bundle.setLanguage("en")
              }
              else
              {
                  Bundle.setLanguage("ar")
              }
           self.setRootVC()
        return true
    }
    func setRootVC()
         {
             let storyBoard = UIStoryboard(name: "Main", bundle: nil) as UIStoryboard
             let loginCheck : Bool = UserDefaults.standard.bool(forKey: "isLogin")
             print(loginCheck)
            
            let check = UserDefaults.standard.bool(forKey:"isFirstTime")
                   if check == false
                   {
                        UserDefaults.standard.set(true, forKey: "isFirstTime")
                        let langugage = storyBoard.instantiateViewController(withIdentifier: "LanguageVC") as? LanguageVC
                        objNavigation = UINavigationController(rootViewController: langugage!)
                        objNavigation?.navigationBar.isHidden = true
                        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.window?.rootViewController = objNavigation
                   }
                   else
                   {
                 
                  if AppData().checkPaid == "no" {
                       
                        let add = storyBoard.instantiateViewController(withIdentifier: "AddVehicleVC") as? AddVehicleVC
                                    
                                                     objNavigation = UINavigationController(rootViewController: add!)
                                    
                                                     objNavigation?.navigationBar.isHidden = true
                                                     let appDelegate  = UIApplication.shared.delegate as! AppDelegate
                                                     appDelegate.window?.rootViewController = objNavigation
                        return
                        
                    }
                    if  loginCheck == false
                                                  {
                                                      let login = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
                                     
                                                      objNavigation = UINavigationController(rootViewController: login!)
                                     
                                                      objNavigation?.navigationBar.isHidden = true
                                                      let appDelegate  = UIApplication.shared.delegate as! AppDelegate
                                                      appDelegate.window?.rootViewController = objNavigation
                                     return
                                     
                                                  }
                                 else
                                 {
                                     objNavigation = UINavigationController()
                                    let home = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as? HomeVC
                         //
                                     objNavigation = UINavigationController(rootViewController: home!)
                         //
                                    objNavigation?.navigationBar.isHidden = true
                                     let appDelegate  = UIApplication.shared.delegate as! AppDelegate
                                   appDelegate.window?.rootViewController = self.manageTabBar()
                                    return
                    
                                 }
            }

         }
    func manageTabBar()-> UITabBarController {
              
              let nav1 = UINavigationController()
              let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
              
              let home:HomeVC = mainStoryboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
              nav1.viewControllers = [home]
              home.tabBarItem.image = image(with: #imageLiteral(resourceName: "icon-home"), scaledTo: CGSize(width: 30, height: 30));
              home.tabBarItem.selectedImage = image(with:#imageLiteral(resourceName: "icon-home-active"), scaledTo: CGSize(width: 30, height: 30))
              
            
              home.tabBarItem.title = NSLocalizedString("home", comment: "")
              nav1.setNavigationBarHidden(true, animated: true)
              
              let nav2 = UINavigationController()
              let Vehicle: MyVehicleVC = mainStoryboard.instantiateViewController(withIdentifier: "MyVehicleVC") as! MyVehicleVC
              nav2.viewControllers = [Vehicle]
              Vehicle.tabBarItem.image = image(with: #imageLiteral(resourceName: "icon-car"), scaledTo: CGSize(width: 30, height: 30));
              Vehicle.tabBarItem.selectedImage = image(with: #imageLiteral(resourceName: "icon-car-active"), scaledTo: CGSize(width: 30, height: 30))
              Vehicle.tabBarItem.title = NSLocalizedString("my_vechile", comment: "")
              nav2.setNavigationBarHidden(true, animated: true)
              
              
           
              
            
              let nav4 = UINavigationController()
              let notificationList = mainStoryboard.instantiateViewController(withIdentifier: "NotificationListVC") as! NotificationListVC
              nav4.viewControllers = [notificationList]
              notificationList.tabBarItem.image = image(with: #imageLiteral(resourceName: "icon-notification"), scaledTo: CGSize(width: 30, height: 30))
              notificationList.tabBarItem.selectedImage = image(with:#imageLiteral(resourceName: "icon-notification-active"), scaledTo: CGSize(width: 30, height: 30))
              notificationList.tabBarItem.title = NSLocalizedString("notification", comment: "")
              nav4.setNavigationBarHidden(true, animated: true)
              
              
              let nav5 = UINavigationController()
              let profile = mainStoryboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
              nav5.viewControllers = [profile]
              profile.tabBarItem.image = image(with: #imageLiteral(resourceName: "icon-user"), scaledTo: CGSize(width: 30, height: 30))
              profile.tabBarItem.selectedImage = image(with: #imageLiteral(resourceName: "icon-user-active"), scaledTo: CGSize(width: 30, height: 30))
              profile.tabBarItem.title = NSLocalizedString("profile", comment: "")
              nav5.setNavigationBarHidden(true, animated: true)
              
              let tabBarController = UITabBarController()
              tabBarController.viewControllers = [nav1,nav2,nav4,nav5]
              tabBarController.selectedIndex = selectTab
              self.tabBarController?.delegate = self
              tabBarController.tabBar.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
              tabBarController.tabBar.unselectedItemTintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
              return tabBarController
              
          }
    
          func image(with image: UIImage?, scaledTo newSize: CGSize) -> UIImage? {
              UIGraphicsBeginImageContextWithOptions(newSize, _: false, _: 0.0)
              image?.draw(in: CGRect(x: 0, y: 4, width: newSize.width, height: newSize.height))
              let newImage = UIGraphicsGetImageFromCurrentImageContext()
              UIGraphicsEndImageContext()
              return newImage
          }
    
    func getDelegate() -> AppDelegate {
             return UIApplication.shared.delegate as! AppDelegate
     }
     
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {

        print("Firebase registration token: \(fcmToken)")
        strDeviceToken = "\(fcmToken)"
        // let dataDict:[String: String] = ["token": fcmToken]

        //        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)

        UserDefaults.standard.set(fcmToken, forKey: "fcmToken")

        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.

    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
         // If you are receiving a notification message while your app is in the background,
         // this callback will not be fired till the user taps on the notification launching the application.
         // TODO: Handle data of notification

         // With swizzling disabled you must let Messaging know about the message, for Analytics
         // Messaging.messaging().appDidReceiveMessage(userInfo)

         // Print message ID.
         if let messageID = userInfo[gcmMessageIDKey] {
             print("Message ID1: \(messageID)")
         }

         // Print full message.
         print(userInfo)
     }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification
      // With swizzling disabled you must let Messaging know about the message, for Analytics
      // Messaging.messaging().appDidReceiveMessage(userInfo)
      // Print message ID.
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }
         // Print full message.
          print(userInfo)

          completionHandler(UIBackgroundFetchResult.newData)
        }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
           print("APNs token retrieved: \(deviceToken.map { String(format: "%02.2hhx", $0) }.joined())")
           //        let token = InstanceID.instanceID().token()
           //        Auth.auth().setAPNSToken(deviceToken, type: AuthAPNSTokenType.sandbox)

           //        device_token = InstanceID.instanceID().token()!//deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
           // With swizzling disabled you must set the APNs token here.
           // Messaging.messaging().apnsToken = deviceToken
       }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
      print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("!!!!!!!!!!!")
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("&&&&&&&&&")
    
   
       
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
//        print("$$$$$$$$$$")
//        let bookingId =  UserDefaults.standard.string(forKey: "bookingID")
//
//            if bookingId == nil {
//
//
//            }
//            else {
//                let driverID =  UserDefaults.standard.string(forKey: "DriverID")
//                NotificationCenter.default.post(name: Notification.Name("checkBooking"), object: nil, userInfo: ["driverid":driverID!,"bookingID":bookingId!])
//            }
//        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let notification = mainStoryboard.instantiateViewController(withIdentifier: "CancelRideVC") as! CancelRideVC
//        objNavigation = UINavigationController(rootViewController: notification)
//
//        objNavigation?.navigationBar.isHidden = true
//        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.window?.rootViewController = objNavigation

       
    }
    func applicationWillTerminate(_ application: UIApplication) {
        print("++++++++++++")
    }
    func applicationWillResignActive(_ application: UIApplication) {
       

    }
    
 
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // when app is onpen and in foregroud
        completionHandler(.alert)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // get the notification identifier to respond accordingly
        let identifier = response.notification.request.identifier
        
        // do what you need to do
        print(identifier)
        // ...
    }
}
