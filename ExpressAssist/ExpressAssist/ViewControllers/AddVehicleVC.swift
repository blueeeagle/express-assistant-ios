//
//  AddVehicleVC.swift
//  ExpressAssist
//
//  Created by Apple on 30/08/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class AddVehicleVC: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
       var arrayModelList = [Any]()
      var pickerModel = UIPickerView()
     @IBOutlet weak var tfModel: UITextField!
     @IBOutlet weak var tfRegistrationNumber: UITextField!
        @IBOutlet weak var imageFront: UIImageView!
       @IBOutlet weak var imageBack: UIImageView!
      var imageTag = 0
    var strVechicleID = ""
    var checkFrontImage = false
    var checkBackImage = false
    var strLangType = ""
    //
    @IBOutlet weak var labelAddNewVehicle: UILabel!
    @IBOutlet weak var labelV_type: UILabel!
    @IBOutlet weak var labelV_image: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

          tfModel.delegate = self
          pickerModel.delegate = self
          tfModel.inputView = pickerModel
        tfRegistrationNumber.placeholder = NSLocalizedString("vechicle_Number", comment: "")
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTappedFirst(tapGestureRecognizer:)))
        imageFront.isUserInteractionEnabled = true
        imageFront.addGestureRecognizer(tapGestureRecognizer)
        
        let tapGestureRecognizers = UITapGestureRecognizer(target: self, action: #selector(imageTappedSecond(tapGestureRecognizer:)))
              imageBack.isUserInteractionEnabled = true
              imageBack.addGestureRecognizer(tapGestureRecognizers)
              labelAddNewVehicle.text = NSLocalizedString("add_new_vechile", comment: "")
               labelV_type.text = NSLocalizedString("vehicle_type", comment: "")
               labelV_image.text = NSLocalizedString("vechile_image", comment: "")
           
              
         btnAdd.setTitle(NSLocalizedString("add_new_vechile", comment: ""), for: UIControl.State.normal)
     
        self.getModelFromServer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
              self.tabBarController?.tabBar.isHidden = true
          }
    @IBAction func btnBack(_ sender: Any) {
             self.navigationController?.popViewController(animated: true)
         }
    @objc func imageTappedFirst(tapGestureRecognizer: UITapGestureRecognizer){
          imageTag = 0
          self.showAlert()
          
      }
    @objc func imageTappedSecond(tapGestureRecognizer: UITapGestureRecognizer){
             imageTag = 1
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
                      if imageTag == 0 {
                             imageFront.image = pickedImage
                              checkFrontImage = true
                         }
                         else  if imageTag == 1 {
                             imageBack.image = pickedImage
                            checkBackImage = true
                         }
                   
                }
                picker.dismiss(animated: true, completion: nil)
            }
   
      
  

  
    @IBAction func btnAddNewVehicle(_ sender: Any) {
        if (tfRegistrationNumber.text?.count)! == 0 {
                           Utility.showMessageDialog(onController: self, withTitle: "", withMessage:NSLocalizedString("vehicleNumber", comment: ""))
                         return
                     }
              if (tfModel.text?.count)! == 0 {
                Utility.showMessageDialog(onController: self, withTitle: "", withMessage:NSLocalizedString("model", comment: ""))
                               return
                           }
        
        if checkFrontImage == true && checkBackImage == true  {
            self.AddVehicleDetails()
        }
        else  {
            Utility.showMessageDialog(onController: self, withTitle: "", withMessage:NSLocalizedString("chooseImage", comment: ""))
        }
        
       
    }
    
    //MARK: - Picker Delegate and DataSources method
     
     func numberOfComponents(in pickerView: UIPickerView) -> Int {
         return 1
     }
     
     func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
         
         return arrayModelList.count
         
     }
     
     func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
          let dicData = arrayModelList[row] as! NSDictionary
          return  (dicData.value(forKey: "name") as! String)
         
     }
     
     func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
      
         let dicData = arrayModelList[row] as! NSDictionary
        strVechicleID = (dicData.value(forKey: "id") as! String)
         tfModel.text =  (dicData.value(forKey: "name") as! String)
        
         
     }
    //MARK: Get Vehicle model from server....
 
     func getModelFromServer()
     {
        let checkLanguage = UserDefaults.standard.bool(forKey:"en")
      if checkLanguage == false
      {
        strLangType = "en"
      }
      else  {
        strLangType = "ar"
      }
         if Reachability.isConnectedToNetwork() {
             startLoader(view: self.view)
             DataProvider.sharedInstance.getMethodToFetchDataWithContentHeader( url: "auth/get_vehicle_details?lang_type=\(strLangType)", { (response) in
                 print(response)
                 stopLoader()
                 if response["status"].stringValue == "Success" {
                      
                    self.arrayModelList = response["data"].arrayObject!
                  
                 }
                 else  {
                     Utility.showMessageDialog(onController: self, withTitle: NSLocalizedString("express", comment: ""), withMessage:NSLocalizedString(response["Message"].string!, comment: ""))
                 }
                 
             }) { (error) in
                 print(error)
                 stopLoader()
             }
             
         }else{
             Utility.showMessageDialog(onController: self, withTitle: "Alert", withMessage: NSLocalizedString("network_issue", comment: ""))
         }
     }
    func AddVehicleDetails()
        {
      
        
            let para:[NSString:NSString] = [
                "vehicle_reg_no":tfRegistrationNumber.text! as NSString,
                "vehicle_type":strVechicleID as NSString,
            ]
            
            if Reachability.isConnectedToNetwork() {
                startLoader(view: self.view)
            
                    DataProvider.sharedInstance.uploadImagesWithDiffPara(parameter: para as [String : String], image1: imageFront.image!, image2: imageBack.image!, url: "auth/add_vehicle_type_details", { (json) in
                    
                    print(json)
                    stopLoader()
                    if json["status"].stringValue == "Success" {
                       
                       let plan = self.storyboard?.instantiateViewController(identifier: "SubscriptionPlanVC") as! SubscriptionPlanVC
                        plan.strVehicleNumber = self.tfRegistrationNumber.text!
                        plan.strVehicleId = json["data"].stringValue
                        self.navigationController?.pushViewController(plan, animated: true)
                        Utility.showMessageDialog(onController: self, withTitle: NSLocalizedString("express", comment: ""), withMessage:json["Message"].stringValue)
                        
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
                Utility.showMessageDialog(onController: self, withTitle: NSLocalizedString("express", comment: ""), withMessage: "Network is not available")
            }
            
        }
}
