//
//  ComplainVC.swift
//  ExpressAssist
//
//  Created by Apple on 29/08/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class ComplainVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

     @IBOutlet weak var imageComplain: UIImageView!
    @IBOutlet weak var tfSubject: UITextField!
    
    @IBOutlet weak var tvMessage: UITextView!
    
    @IBOutlet weak var labelComplain: UILabel!
    @IBOutlet weak var labelSubject: UILabel!
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var btnSubmit: UIButton!
    var isGetImage = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

             labelComplain.text = NSLocalizedString("complain", comment: "")
             labelSubject.text = NSLocalizedString("subject", comment: "")
             labelMessage.text = NSLocalizedString("message", comment: "")
              
         btnSubmit.setTitle(NSLocalizedString("submit", comment: ""), for: UIControl.State.normal)
        Utility.addPaddingAndBorder(to: tfSubject)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Complain(tapGestureRecognizer:)))
              imageComplain.isUserInteractionEnabled = true
              imageComplain.addGestureRecognizer(tapGestureRecognizer)
        // Do any additional setup after loading the view.
    }
      override func viewWillAppear(_ animated: Bool) {
           self.tabBarController?.tabBar.isHidden = true
       }
     override func viewDidDisappear(_ animated: Bool) {
      self.tabBarController?.tabBar.isHidden = false
    }
    @IBAction func btnSubmit(_ sender: Any) {
        if (tfSubject.text?.count)! == 0 {
                                Utility.showMessageDialog(onController: self, withTitle: "", withMessage:NSLocalizedString("enter_subject", comment: ""))
                              return
        }
        if (tvMessage.text?.count)! == 0 {
                                      Utility.showMessageDialog(onController: self, withTitle: "", withMessage:NSLocalizedString("type_your_message", comment: ""))
                                    return
              }
        tfSubject.text = tfSubject.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        tvMessage.text = tvMessage.text!.trimmingCharacters(in: .whitespacesAndNewlines)
          
        if isGetImage == false {
            Utility.showMessageDialog(onController: self, withTitle: "", withMessage:NSLocalizedString("chooseImage", comment: ""))
            return
        }
        
        self.addComplain()
    }
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func Complain(tapGestureRecognizer: UITapGestureRecognizer){
      
        self.showAlert()
        
    }
    
    func showAlert() {
          
          let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
          alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
              self.isGetImage = true
              self.getImage(fromSourceType: .camera)
          }))
          alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: {(action: UIAlertAction) in
            self.isGetImage = true
              self.getImage(fromSourceType: .photoLibrary)
          }))
          alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.isGetImage = false
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
                          
                                   imageComplain.image = pickedImage
                             
                         
                      }
                      picker.dismiss(animated: true, completion: nil)
                  }
    func addComplain()
          {
              
                 let para:[String:Any] = [
                    "title":tfSubject.text!,"description":tvMessage.text!,"user_id":AppData().ID,"language":"eg"]
              
              if Reachability.isConnectedToNetwork() {
                  startLoader(view: self.view)
              
                  DataProvider.sharedInstance.uploadImage(parameter: para as! [String : String], image: imageComplain.image!, url: "get_data/user_complanes", { (json) in
                      
                      print(json)
                      stopLoader()
                      if json["status"].stringValue == "Success" {
                        let alertController = UIAlertController(title: NSLocalizedString("express", comment: ""), message: json["Message"].stringValue, preferredStyle: .alert)
                                  
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
