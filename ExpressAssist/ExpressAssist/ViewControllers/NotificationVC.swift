//
//  NotificationVC.swift
//  ExpressAssist
//
//  Created by Apple on 29/08/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class NotificationVC: UIViewController {
     @IBOutlet weak var labelNotification: UILabel!
     @IBOutlet weak var labelBookingRequest: UILabel!
     @IBOutlet weak var labelBookingConfirmation: UILabel!
     @IBOutlet weak var labelPayment: UILabel!
     @IBOutlet weak var labelPushNotification: UILabel!
    @IBOutlet weak var switchNotification: UISwitch!
     var checkNotification = ""
    override func viewDidLoad() {
        super.viewDidLoad()

         labelNotification.text = NSLocalizedString("notification", comment: "")
         labelBookingRequest.text = NSLocalizedString("booking_request", comment: "")
         labelBookingConfirmation.text = NSLocalizedString("booking_confirmation", comment: "")
         labelPayment.text = NSLocalizedString("service_history", comment: "")
         labelPushNotification.text = NSLocalizedString("push_notification", comment: "")
    }
    
      override func viewWillAppear(_ animated: Bool) {
           self.tabBarController?.tabBar.isHidden = true
       }
    override func viewDidDisappear(_ animated: Bool) {
      self.tabBarController?.tabBar.isHidden = false
    }
   @IBAction func btnBack(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
    }
    @IBAction func switchBookingRequest(_ sender: Any) {
               if switchNotification.isOn    {
                      checkNotification = "enabled"
           
                       print("++++")
                    self.updateNotificationOnServer()
                   }
                   else {
                       checkNotification = "disabled"
                     
                       print("----")
                   self.updateNotificationOnServer()
                      
                   }
       }
    func updateNotificationOnServer()
    {
        let para:[String:Any] = [
          "notification":checkNotification]
        print("Parameters send\(para)")
        if Reachability.isConnectedToNetwork() {
            startLoader(view: self.view)
            
            DataProvider.sharedInstance.getDataWithPostMethod(parameter: para as [String : Any], url: "get_data/notification_status", { (json) in
                print(json)
                stopLoader()
                
                if json["status"].stringValue == "Success"
                {
                  
                    Utility.showMessageDialog(onController: self, withTitle: NSLocalizedString("express", comment: ""), withMessage:json["Message"].string)
                  
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
