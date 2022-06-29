//
//  OTPVC.swift
//  CRICART
//
//  Created by Apple on 07/06/20.
//  Copyright © 2020 Apple. All rights reserved.
//
 
import UIKit


class OTPVC: UIViewController, VPMOTPViewDelegate {
    @IBOutlet weak var imageMobileIcon: UIImageView!
    @IBOutlet weak var tfOTP: UITextField!
    @IBOutlet weak var labelMobileNumber: UILabel!
    @IBOutlet weak var otpView: VPMOTPView!
     let appObject = UIApplication.shared.delegate as! AppDelegate
    var enteredOtp: String = ""
    var strPhoneNumber  = ""
    var strOTP  = ""
    var strPaymentAmount = ""
    var dicPara = [String:Any]()
    
    var isfromMyCart = false
    //
    @IBOutlet weak var labelOTPVarification: UILabel!
    
    @IBOutlet weak var btnVerify: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        
        
        
         labelOTPVarification.text = NSLocalizedString("welcome_back", comment: "")
         labelMobileNumber.text = NSLocalizedString("we_sent", comment: "") + "\(strMobileNumber)"
         
         btnVerify.setTitle(NSLocalizedString("varify", comment: ""), for: UIControl.State.normal)
        
             otpView.otpFieldsCount = 4
             otpView.otpFieldDefaultBorderColor = UIColor.black
             otpView.otpFieldEnteredBorderColor = UIColor.black
             otpView.otpFieldErrorBorderColor = UIColor.black
             otpView.otpFieldBorderWidth = 2
             otpView.delegate = self
             otpView.shouldAllowIntermediateEditing = false
             otpView.initializeUI()
        
     
        let para:[String:Any] = [
            "phone":strPhoneNumber]

        self.getOtpFromServer(para: para)

    }
    
     @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
       }
       
    @IBAction func btnVarify(_ sender: Any) {
        
        if strOTP == enteredOtp{
            self.RegisterUser(para: dicPara)
        }
        else {
             Utility.showMessageDialog(onController: self, withTitle: "Express", withMessage:NSLocalizedString("corret_otp", comment: ""))
        }

    }
    
    func hasEnteredAllOTP(hasEntered: Bool) -> Bool {
        print("Has entered all OTP? \(hasEntered)")
        
        return enteredOtp == "12345"
    }
    
    func shouldBecomeFirstResponderForOTP(otpFieldIndex index: Int) -> Bool {
        return true
    }
    
    func enteredOTP(otpString: String) {
        enteredOtp = otpString
        print("OTPString: \(otpString)")
    }
    
   func RegisterUser(para:[String: Any])
       {
           print("Parameters send\(para)")
           if Reachability.isConnectedToNetwork() {
               startLoader(view: self.view)
               DataProvider.sharedInstance.getData(parameter: para as [String : Any], url: "auth/signup_user", { (json) in
                   print(json)
                   stopLoader()
                   
                   if json["status"].stringValue == "Success"
                   {
                     UserDefaults.standard.set(true, forKey: "isLogin")
                             
                       AppData().name = json["data"]["first_name"].stringValue
                       AppData().lastName = json["data"]["last_name"].stringValue
                        AppData().phone = json["data"]["phone"].stringValue
                       AppData().email = json["data"]["email"].stringValue
                       AppData().token = json["auth_key"].stringValue
                       AppData().vehicleNumber = json["data"]["vehicle_number"].stringValue
                       AppData().ID = json["data"]["user_id"].stringValue
                      AppData().userprofileImage = json["data"]["image"].stringValue
                      self.strOTP = json["data"]["otp"].stringValue
                      let add = self.storyboard?.instantiateViewController(withIdentifier: "AddVehicleVC") as! AddVehicleVC
                      self.navigationController?.pushViewController(add, animated: true)
                
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
    func getOtpFromServer(para:[String: Any])
            {
                print("Parameters send\(para)")
                if Reachability.isConnectedToNetwork() {
                    startLoader(view: self.view)
                    DataProvider.sharedInstance.getData(parameter: para as [String : Any], url: "auth/user_varification", { (json) in
                        print(json)
                        stopLoader()
                        
                        if json["status"].stringValue == "Success"
                        {
                           
                            self.strOTP = json["data"]["otp"].stringValue
                            AppData().checkPaid = json["data"]["is_paid"].stringValue
                        
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


