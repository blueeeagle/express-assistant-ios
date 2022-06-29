//
//  SubscriptionPlanVC.swift
//  ExpressAssist
//
//  Created by Apple on 30/08/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class SubscriptionPlanVC: UIViewController {
  let appObject = UIApplication.shared.delegate as! AppDelegate
    var strCurrentDateAndTime = ""
    var strVehicleId = ""
    var strVehicleNumber = ""
    //
    @IBOutlet weak var labelPlan: UILabel!
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var labelDuration: UILabel!
    @IBOutlet weak var labelOneTime: UILabel!
    @IBOutlet weak var labelunlimited: UILabel!
    @IBOutlet weak var labelSecure: UILabel!
    @IBOutlet weak var labelSupport: UILabel!
    @IBOutlet weak var labelNoExtra: UILabel!
    @IBOutlet weak var btnPay: UIButton!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = formatter.string(from: now)
        print(dateString)
        strCurrentDateAndTime = dateString
        
            labelPlan.text = NSLocalizedString("subscription_plan", comment: "")
         //    labelAmount.text = NSLocalizedString("last_name", comment: "")
             labelDuration.text = NSLocalizedString("charged_yearly", comment: "")
             labelOneTime.text = NSLocalizedString("one_time_payment", comment: "")
             labelunlimited.text = NSLocalizedString("unlimited", comment: "")
             labelSecure.text = NSLocalizedString("secure", comment: "")
             labelSupport.text = NSLocalizedString("support", comment: "")
             labelNoExtra.text = NSLocalizedString("no_extra", comment: "")
            
        btnPay.setTitle(NSLocalizedString("pay", comment: ""), for: UIControl.State.normal)

        // Do any additional setup after loading the view.
    }
     override func viewWillAppear(_ animated: Bool) {
           self.tabBarController?.tabBar.isHidden = true
       }
    override func viewDidDisappear(_ animated: Bool) {
      self.tabBarController?.tabBar.isHidden = false
    }

    @IBAction func ChoosePlan(_ sender: Any) {
        self.makePayment()
    }
    func makePayment() {
        let pay = self.storyboard?.instantiateViewController(withIdentifier: "PaymentVC") as! PaymentVC
        pay.strVehicleNumber = strVehicleNumber
        pay.strVehicleId = strVehicleId
            self.navigationController?.pushViewController(pay, animated: true)
           
    }
    
    func updatePaymentOnServer()
    {
    
        let para:[String:Any] = [
            "user_id":AppData().ID,"transaction_id":"fhgf67","amount":"5","payment_mode":"Online","payment_status":"success","payment_date":strCurrentDateAndTime,"vehicle_id":strVehicleId]
        print("Parameters send\(para)")
        if Reachability.isConnectedToNetwork() {
            startLoader(view: self.view)
            
            DataProvider.sharedInstance.getDataWithPostMethod(parameter: para as [String : Any], url: "auth/make_user_payment", { (json) in
                print(json)
                stopLoader()
                
                if json["status"].stringValue == "Success"
                {
               AppData().checkPaid = json["data"]["payment_status"].stringValue
                    self.makeRoot()
                //  Utility.showMessageDialog(onController: self, withTitle: NSLocalizedString("express", comment: ""), withMessage:json["Message"].string)
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

    
    func makeRoot() {
               let getTab = appObject.manageTabBar()
                   let storyBoard = UIStoryboard(name: "Main", bundle: nil) as UIStoryboard
                       var objNavigation = UINavigationController()
                          let dis = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as? HomeVC
               
                           objNavigation = UINavigationController(rootViewController: dis!)
               
                          objNavigation.navigationBar.isHidden = true
                           
                         appObject.window?.rootViewController = getTab
           }
}
