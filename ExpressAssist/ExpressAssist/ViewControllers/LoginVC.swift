//
//  LoginVC.swift
//  ExpressAssist
//
//  Created by Apple on 30/08/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

var strMobileNumber = ""
class LoginVC: UIViewController {
 @IBOutlet weak var tfMobileNumber: UITextField!
    
    @IBOutlet weak var labelLoginTomange: UILabel!
    //
    @IBOutlet weak var labelWelcome: UILabel!
    @IBOutlet weak var labelLoginManage: UILabel!
    @IBOutlet weak var labelMobile: UILabel!
    @IBOutlet weak var btnSendOTP: UIButton!
    @IBOutlet weak var btnCheckMark: UIButton!
    
    @IBOutlet weak var btnTermConditions: UIButton!
   
    
    let appObject = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnCheckMark.isSelected = true
        btnTermConditions.setTitle(NSLocalizedString("term", comment: ""), for: UIControl.State.normal)
        
        labelLoginTomange.text = NSLocalizedString("login_manage", comment: "")
        labelWelcome.text = NSLocalizedString("welcome_back", comment: "")
        labelMobile.text = NSLocalizedString("mobile", comment: "")
        btnSendOTP.setTitle(NSLocalizedString("send_otp", comment: ""), for: UIControl.State.normal)
        
        // Do any additional setup after loading the view.
    }
    @IBAction func btnTerm(_ sender: Any) {
    let term = self.storyboard?.instantiateViewController(withIdentifier: "TermVC") as! TermVC
     self.navigationController?.pushViewController(term, animated: true)
    }
    
   
    @IBAction func btnSendOTP(_ sender: Any) {
        
        if (tfMobileNumber.text?.count)! == 0 {
                           Utility.showMessageDialog(onController: self, withTitle: "", withMessage:NSLocalizedString("enter_mobile", comment: ""))
                         return
                     }
        if (tfMobileNumber.text?.count)! <= 7 {
                                 Utility.showMessageDialog(onController: self, withTitle: "", withMessage:NSLocalizedString("digit_check", comment: ""))
                               return
                           }
        
        if btnCheckMark.isSelected == false {
            Utility.showMessageDialog(onController: self, withTitle: "", withMessage:NSLocalizedString("termCheckMark", comment: ""))
          return
        }
        strMobileNumber = tfMobileNumber.text!
    let para:[String:Any] = [
                      "phone":strMobileNumber,"firebase_token":strDeviceToken,"device_name":"ios"]
                  self.login(para: para)
    
    }
    
    func login(para:[String: Any])
            {
                print("Parameters send\(para)")
                if Reachability.isConnectedToNetwork() {
                    startLoader(view: self.view)
                    DataProvider.sharedInstance.getData(parameter: para as [String : Any], url: "auth/login", { (json) in
                        print(json)
                        stopLoader()
                        
                        if json["status"].stringValue == "Success"
                        {
                           
                           let strCheckUserExit =  json["availabe"].stringValue
                           let strPaidUser =  json["data"]["is_paid"].stringValue
                           AppData().checkPaid = json["data"]["is_paid"].stringValue
                        
                            
                            if strCheckUserExit == "yes" {
                             UserDefaults.standard.set(true, forKey: "isLogin")
                                if strPaidUser == "no" {
                                                                            
                                                                                                      AppData().name = json["data"]["first_name"].stringValue
                                                                                                      AppData().lastName = json["data"]["last_name"].stringValue
                                                                                                      AppData().email = json["data"]["email"].stringValue
                                                                                                      AppData().token = json["auth_key"].stringValue
                                                                                                      AppData().phone = json["data"]["phone"].stringValue
                                                                                                      AppData().ID = json["data"]["user_id"].stringValue
                                                                                                      AppData().vehicleNumber = json["data"]["vehicle_number"].stringValue
                                                                                                      
                                                                                                        AppData().userprofileImage = json["data"]["image"].stringValue
                                                                             let add = self.storyboard?.instantiateViewController(withIdentifier: "AddVehicleVC") as! AddVehicleVC
                                                                             self.navigationController?.pushViewController(add, animated: true)
                                                                             return
                                                                         }
                                
                                else {
                            AppData().name = json["data"]["first_name"].stringValue
                            AppData().lastName = json["data"]["last_name"].stringValue
                            AppData().email = json["data"]["email"].stringValue
                            AppData().token = json["auth_key"].stringValue
                                                         AppData().phone = json["data"]["phone"].stringValue
                                                         AppData().ID = json["data"]["user_id"].stringValue
                                                         AppData().vehicleNumber = json["data"]["vehicle_number"].stringValue
                                                         
                                                           AppData().userprofileImage = json["data"]["image"].stringValue
                                                         self.makeRoot()
                                                     }
                            }
                           
                           else  {
                            let signup = self.storyboard?.instantiateViewController(withIdentifier: "SignupVC") as! SignupVC
                                      self.navigationController?.pushViewController(signup, animated: true)
                           }
                        
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
