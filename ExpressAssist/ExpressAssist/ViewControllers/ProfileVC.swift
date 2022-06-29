//
//  ProfileVC.swift
//  ExpressAssist
//
//  Created by Apple on 29/08/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

    @IBOutlet weak var imageUserProfile: UIImageView!
    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var labelPhone: UILabel!
    //
    
    @IBOutlet weak var labelProfile: UILabel!
    @IBOutlet weak var labelS_History: UILabel!
    @IBOutlet weak var labelS_HistoryCount: UILabel!
    
    @IBOutlet weak var labelNotification: UILabel!
    @IBOutlet weak var label_Ncount: UILabel!
    
    @IBOutlet weak var labelComplain: UILabel!
    @IBOutlet weak var labelComplainDesription: UILabel!
    
    @IBOutlet weak var labelchooseLanguage: UILabel!
    @IBOutlet weak var labelLangName: UILabel!
    
    @IBOutlet weak var labelLogout: UILabel!
    @IBOutlet weak var labelLogoutText: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

         labelProfile.text = NSLocalizedString("my_profile", comment: "")
         labelS_History.text = NSLocalizedString("service_history", comment: "")
         labelS_HistoryCount.text = NSLocalizedString("service", comment: "")
         labelNotification.text = NSLocalizedString("notification", comment: "")
         label_Ncount.text = NSLocalizedString("notification_des", comment: "")
         labelComplain.text = NSLocalizedString("complain", comment: "")
         labelComplainDesription.text = NSLocalizedString("complains", comment: "")
         labelchooseLanguage.text = NSLocalizedString("choose_language", comment: "")
         labelLangName.text = NSLocalizedString("language", comment: "")
         labelLogout.text = NSLocalizedString("logout", comment: "")
         labelLogoutText.text = NSLocalizedString("logout_des", comment: "")
            
    
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        var imgURL = AppData().userprofileImage
            imgURL =  imgURL.trim().replacingOccurrences(of: " ", with: "%20")
            print(imgURL)
                   
            let url = NSURL(string: imgURL)
            self.imageUserProfile.af_setImage(withURL: url! as URL)
            //imageUserProfile.text = AppData().name
            labelUserName.text = AppData().name + " " +  AppData().lastName
            labelEmail.text = AppData().email
            labelPhone.text = AppData().phone
            self.tabBarController?.tabBar.isHidden = false
        }
    @IBAction func btnEditProfile(_ sender: Any) {
        let edit = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
              self.navigationController?.pushViewController(edit, animated: true)
    }
    
    @IBAction func btnComplain(_ sender: Any) {
        let complain = self.storyboard?.instantiateViewController(withIdentifier: "ComplainVC") as! ComplainVC
        self.navigationController?.pushViewController(complain, animated: true)
    }
    @IBAction func btnService(_ sender: Any) {
        let service = self.storyboard?.instantiateViewController(withIdentifier: "ServiceHistoryVC") as! ServiceHistoryVC
         self.navigationController?.pushViewController(service, animated: true)
    }
    
    @IBAction func btnNotification(_ sender: Any) {
        let notification = self.storyboard?.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
              self.navigationController?.pushViewController(notification, animated: true)
    }
    
    @IBAction func btnLanguage(_ sender: Any) {
        let language = self.storyboard?.instantiateViewController(withIdentifier: "ChooseLanguageVC") as! ChooseLanguageVC
                     self.navigationController?.pushViewController(language, animated: true)
    }
    @IBAction func btnLogout(_ sender: Any) {
        let alertController = UIAlertController(title: "Logout", message: "Do you Want to Logout!", preferredStyle: .alert)
                  
                  let action1 = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction) in
                    self.updateNotificationOnServer()
                      
                  }
                  
                  let action2 = UIAlertAction(title: "No", style: .cancel) { (action:UIAlertAction) in
                      print("You've pressed cancel");
                      
                  }
                  alertController.addAction(action1)
                  alertController.addAction(action2)
                  self.present(alertController, animated: true, completion: nil)
    }
    func myHandler(){
           let storyBoard = UIStoryboard(name: "Main", bundle: nil) as UIStoryboard
           UserDefaults.standard.set(false, forKey: "isLogin")
           let appDelegate  = UIApplication.shared.delegate as! AppDelegate
           let login = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
           if let aLogin = login
           {
               appDelegate.objNavigation = UINavigationController(rootViewController: aLogin)
           }
          
           appDelegate.objNavigation?.navigationBar.isHidden = true
           appDelegate.window?.rootViewController = appDelegate.objNavigation
           print("You tapped")
       }
    
    func updateNotificationOnServer()
    {
        let para:[String:Any] = [
          "notification":"disabled"]
        print("Parameters send\(para)")
        if Reachability.isConnectedToNetwork() {
            startLoader(view: self.view)
            
            DataProvider.sharedInstance.getDataWithPostMethod(parameter: para as [String : Any], url: "get_data/notification_status", { (json) in
                print(json)
                stopLoader()
                
                if json["status"].stringValue == "Success"
                {
                 self.myHandler()
                  
                    }
                  
                 
                
                else {
                    stopLoader()
                    Utility.showMessageDialog(onController: self, withTitle: NSLocalizedString("express", comment: ""), withMessage:json["Message"].string)
                }
                
            }) { (error) in
                print(error)
                stopLoader()
            }
            
            
        }else
        {
            Utility.showMessageDialog(onController: self, withTitle: NSLocalizedString("express", comment: ""), withMessage:NSLocalizedString("network_issue", comment: ""))
            stopLoader()
        }
        
    }
}
