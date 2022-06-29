//
//  EditProfileVC.swift
//  ExpressAssist
//
//  Created by Apple on 29/08/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class EditProfileVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate  {
       @IBOutlet weak var imageUserProfile: UIImageView!
       @IBOutlet weak var tfFirstName: UITextField!
       @IBOutlet weak var tfLastName: UITextField!
       @IBOutlet weak var tfMobileNumber: UITextField!
       @IBOutlet weak var TfEmail: UITextField!
    
    @IBOutlet weak var labelEditProfile: UILabel!
    @IBOutlet weak var labelFName: UILabel!
    @IBOutlet weak var labelLastName: UILabel!
    @IBOutlet weak var labelemail: UILabel!
    @IBOutlet weak var labelMobile: UILabel!
     @IBOutlet weak var btnSave: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        labelEditProfile.text = NSLocalizedString("edit_profile", comment: "")
        labelFName.text = NSLocalizedString("first_name", comment: "")
          labelLastName.text = NSLocalizedString("last_name", comment: "")
          labelMobile.text = NSLocalizedString("mobile_number", comment: "")
          labelemail.text = NSLocalizedString("email_address", comment: "")
      
        
          btnSave.setTitle(NSLocalizedString("save", comment: ""), for: UIControl.State.normal)
              Utility.addPaddingAndBorder(to: tfFirstName)
               Utility.addPaddingAndBorder(to: tfLastName)
               Utility.addPaddingAndBorder(to: tfMobileNumber)
               Utility.addPaddingAndBorder(to: TfEmail)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTappedProfile(tapGestureRecognizer:)))
        imageUserProfile.isUserInteractionEnabled = true
        imageUserProfile.addGestureRecognizer(tapGestureRecognizer)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        tfFirstName.text = AppData().name
        tfLastName.text = AppData().lastName
        TfEmail.text = AppData().email
        tfMobileNumber.text = AppData().phone
       
        var imgURL = AppData().userprofileImage
        imgURL =  imgURL.trim().replacingOccurrences(of: " ", with: "%20")
        print(imgURL)
               
        let url = NSURL(string: imgURL)
        self.imageUserProfile.af_setImage(withURL: url! as URL)
           self.tabBarController?.tabBar.isHidden = true
       }
   
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func imageTappedProfile(tapGestureRecognizer: UITapGestureRecognizer){
         
           self.showAlert()
           
       }
    
    func showAlert() {
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .camera)
        }))
        alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    //get image from source type
       func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
           
           //Check is source type available
           if UIImagePickerController.isSourceTypeAvailable(sourceType) {
               
               let imagePickerController = UIImagePickerController()
               imagePickerController.delegate = self
               imagePickerController.sourceType = sourceType
               self.present(imagePickerController, animated: true, completion: nil)
           }
       }
    
    //MARK:-- ImagePicker delegate
               func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                   if let pickedImage = info[.originalImage] as? UIImage {
                       // imageViewPic.contentMode = .scaleToFill
                       
                                imageUserProfile.image = pickedImage
                          
                      
                   }
                   picker.dismiss(animated: true, completion: nil)
               }
    @IBAction func btnSave(_ sender: Any) {
        if (tfFirstName.text?.count)! == 0 {
                     Utility.showMessageDialog(onController: self, withTitle: "", withMessage:NSLocalizedString("enter_name", comment: ""))
                   return
               }
        if (tfLastName.text?.count)! == 0 {
                           Utility.showMessageDialog(onController: self, withTitle: "", withMessage:NSLocalizedString("enter_last_name", comment: ""))
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

        self.uploadProfileOnServer()
    }
    
    func uploadProfileOnServer()
        {
            
               let para:[String:Any] = [
                "first_name":tfFirstName.text!,"last_name":tfLastName.text!,"user_id":AppData().ID,"email":TfEmail.text!,]
            
            if Reachability.isConnectedToNetwork() {
                startLoader(view: self.view)
            
                DataProvider.sharedInstance.uploadImage(parameter: para as! [String : String], image: imageUserProfile.image!, url: "auth/update_user_profile", { (json) in
                    
                    print(json)
                    stopLoader()
                    if json["status"].stringValue == "Success" {
                        AppData().name = json["data"]["first_name"].stringValue
                        AppData().lastName = json["data"]["last_name"].stringValue
                        AppData().email = json["data"]["email"].stringValue
                        AppData().userprofileImage = json["data"]["image"].stringValue
                        var imgURL = json["data"]["image"].stringValue
                        
                                                   imgURL =  imgURL.trim().replacingOccurrences(of: " ", with: "%20")
                                                                                      print(imgURL)
                               
                                    let url = NSURL(string: imgURL)
                           
                        self.imageUserProfile.af_setImage(withURL: url! as URL)
                        
                        
                     
                        let alertController = UIAlertController(title: NSLocalizedString("express", comment: ""), message: NSLocalizedString("profile_update", comment: ""), preferredStyle: .alert)
                                  
                                  let action1 = UIAlertAction(title: "ok", style: .default) { (action:UIAlertAction) in
                                     
                                     
                                    self.navigationController?.popViewController(animated: true)
                                   
                                  }
                                  
                                  alertController.addAction(action1)
                                 
                                  self.present(alertController, animated: true, completion: nil)
                        
                    }
                    else  {
                          Utility.showMessageDialog(onController: self, withTitle: NSLocalizedString("express", comment: ""), withMessage:json["Message"].stringValue)
                    }
                    
                }
                    , errorBlock: { (error) in
                        print(error)
                        stopLoader()
                })
                
                
            }else{
                Utility.showMessageDialog(onController: self, withTitle: "Alert", withMessage: NSLocalizedString("network_issue", comment: ""))
            }
            
        }

    
}
