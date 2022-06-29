//
//  SignupVC.swift
//  ExpressAssist
//
//  Created by Apple on 30/08/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class SignupVC: UIViewController {

    @IBOutlet weak var tfFirstName: UITextField!
    @IBOutlet weak var tfLastName: UITextField!
    @IBOutlet weak var tfMobileNumber: UITextField!
    @IBOutlet weak var TfEmail: UITextField!
        let appObject = UIApplication.shared.delegate as! AppDelegate
    //
    @IBOutlet weak var labelWelcome: UILabel!
    @IBOutlet weak var labelFiilOut: UILabel!
    @IBOutlet weak var labelFirstName: UILabel!
    @IBOutlet weak var labelLastName: UILabel!
    @IBOutlet weak var labelMobile: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var btnRegister: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
         Utility.addPaddingAndBorder(to: tfFirstName)
         Utility.addPaddingAndBorder(to: tfLastName)
         Utility.addPaddingAndBorder(to: tfMobileNumber)
         Utility.addPaddingAndBorder(to: TfEmail)
         tfMobileNumber.text! = strMobileNumber
        
        
        labelWelcome.text = NSLocalizedString("welcome", comment: "")
        labelFiilOut.text = NSLocalizedString("fill_out", comment: "")
        labelFirstName.text = NSLocalizedString("first_name", comment: "")
        labelLastName.text = NSLocalizedString("last_name", comment: "")
        labelMobile.text = NSLocalizedString("mobile_number", comment: "")
        labelEmail.text = NSLocalizedString("email_address", comment: "")
      
         btnRegister.setTitle(NSLocalizedString("register", comment: ""), for: UIControl.State.normal)
    }
    

    @IBAction func btnRegister(_ sender: Any) {
        if (tfFirstName.text?.count)! == 0 {
                     Utility.showMessageDialog(onController: self, withTitle: "", withMessage:NSLocalizedString("enter_name", comment: ""))
                   return
               }
        if (tfLastName.text?.count)! == 0 {
                           Utility.showMessageDialog(onController: self, withTitle: "", withMessage:NSLocalizedString("enter_last_name", comment: ""))
                         return
                     }
        if (tfMobileNumber.text?.count)! == 0 {
                               Utility.showMessageDialog(onController: self, withTitle: "", withMessage:NSLocalizedString("enter_mobile", comment: ""))
                             return
                         }
        if (TfEmail.text?.count)! == 0 {
                                      Utility.showMessageDialog(onController: self, withTitle: "", withMessage:NSLocalizedString("enter_email", comment: ""))
                                    return
                                }
        if (TfEmail.text?.count)! > 0 {
            if !Utility.isValidEmail(testStr: TfEmail.text!) {
                                    
                                     Utility.showMessageDialog(onController: self, withTitle: "", withMessage:NSLocalizedString("valid_email", comment: ""))
                                   
                                    return
                       }
            }
        
        tfFirstName.text = tfFirstName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        tfLastName.text = tfLastName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        TfEmail.text = TfEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines)
       
        
        let para:[String:Any] = [
            "first_name":tfFirstName.text!,"last_name":tfLastName.text!,"phone":tfMobileNumber.text!,"email":TfEmail.text!,"firebase_token":strDeviceToken,"device_name":"ios"]
             
          
        let otp = self.storyboard?.instantiateViewController(withIdentifier: "OTPVC") as! OTPVC
        otp.dicPara = para
        otp.strPhoneNumber = tfMobileNumber.text!
        self.navigationController?.pushViewController(otp, animated: true)
    }
    
  
}
