//
//  MyVehicleVC.swift
//  ExpressAssist
//
//  Created by Apple on 29/08/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage
import AlamofireImage
class VehicleCell: UITableViewCell
{
    @IBOutlet weak var imageVehicle: UIImageView!
    @IBOutlet weak var labelRegistrationDate: UILabel!
    @IBOutlet weak var labelVechicleNumber: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
     @IBOutlet weak var btnRenew: UIButton!
}

class MyVehicleVC: UIViewController, UITableViewDelegate,UITableViewDataSource  {
    @IBOutlet weak var tableVechicle: UITableView!
    var  arrayServerDic =
                  [String:JSON] ()
       var arrayCarList = [Any]()
     @IBOutlet weak var labelMyVechicle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      labelMyVechicle.text = NSLocalizedString("my_vechile", comment: "")

        // Do any additional setup after loading the view.
    }
   
    
    override func viewWillAppear(_ animated: Bool) {
          self.tabBarController?.tabBar.isHidden = false
           self.UserVehicleListFromServer()
      }
    @IBAction func btnAddVehicle(_ sender: Any) {
        let add = self.storyboard?.instantiateViewController(identifier: "AddVehicleVC") as! AddVehicleVC
        self.navigationController?.pushViewController(add, animated: true)
    }
    
       //MARK: Table delegate and datasources method
            
         
            
        public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
            {
              
                return arrayCarList.count
              
                
            }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
          {
          
                 let cell : VehicleCell? = tableView.dequeueReusableCell(withIdentifier: "cell") as? VehicleCell
             let dicData = arrayCarList[indexPath.row] as! NSDictionary
              cell?.labelVechicleNumber.text  = (dicData.value(forKey: "vehicle_reg_no") as! String)
             cell?.labelRegistrationDate.text  = (dicData.value(forKey: "payment_date") as! String)
            var imgURL = dicData.value(forKey: "front_image") as! String
                                                                      imgURL =  imgURL.trim().replacingOccurrences(of: " ", with: "%20")
                                                                      print(imgURL)
             
                                                                      let url = NSURL(string: imgURL)
           
            
        
            
            cell?.imageVehicle.af_setImage(withURL: url! as URL)
            cell?.btnDelete.tag = indexPath.row
            cell?.btnRenew.tag = indexPath.row
             cell?.btnDelete.addTarget(self, action: #selector(self.deleteMessage(_:)), for: .touchUpInside)
            let strCheckExpiryDate =  (dicData.value(forKey: "is_expired") as! String)
            if strCheckExpiryDate == "no" {
                cell?.btnRenew.isHidden = true
            }
            else {
                cell?.btnRenew.isHidden = false
              cell?.btnRenew.addTarget(self, action: #selector(self.PurchasePlan(_:)), for: .touchUpInside)
            
            }
        
              return cell!
            
          }
          func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          
              return 70.0
            
          }
    
    @objc func PurchasePlan(_ sender: UIButton)
           {
                let dicData = arrayCarList[sender.tag] as! NSDictionary
            let plan = self.storyboard?.instantiateViewController(identifier: "SubscriptionPlanVC") as! SubscriptionPlanVC
            plan.strVehicleId = dicData.value(forKey: "id") as! String
                                   self.navigationController?.pushViewController(plan, animated: true)
    }
    @objc func deleteMessage(_ sender: UIButton)
        {

          let dicData = arrayCarList[sender.tag] as! NSDictionary
        
            
      let alertController = UIAlertController(title: NSLocalizedString("express", comment: ""), message: NSLocalizedString("delete_vechicle", comment: ""), preferredStyle: .alert)
      let action1 = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction) in
        self.deleteVehicleFromServer(userId: Int(dicData.value(forKey: "user_id") as! String)!, vechicleId: Int(dicData.value(forKey: "id") as! String)!)
      }
      
      let action2 = UIAlertAction(title: "No", style: .cancel) { (action:UIAlertAction) in
          print("You've pressed cancel");
          
      }
      alertController.addAction(action1)
      alertController.addAction(action2)
      self.present(alertController, animated: true, completion: nil)
           
        }

  func UserVehicleListFromServer()
  {
      let para:[String:Any] = [
        "id":AppData().ID]
      print("Parameters send\(para)")
      if Reachability.isConnectedToNetwork() {
          startLoader(view: self.view)
          
          DataProvider.sharedInstance.getDataWithPostMethod(parameter: para as [String : Any], url: "auth/get_user_vehicle_list", { (json) in
              print(json)
              stopLoader()
              
              if json["status"].stringValue == "Success"
              {
                   
                    self.arrayServerDic = json["data"].dictionaryValue
                  self.arrayCarList = (self.arrayServerDic["vehicle_list"]?.arrayObject!)!
                let dicData = self.arrayCarList[0] as! NSDictionary
                AppData().vehicleNumber = (dicData.value(forKey: "vehicle_reg_no") as! String)
               
                  self.tableVechicle.reloadData()
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
    
    func deleteVehicleFromServer(userId:NSInteger,vechicleId:NSInteger)
     {
         let para:[String:Any] = [
            "vehicle_id":vechicleId,"user_id":userId]
         print("Parameters send\(para)")
         if Reachability.isConnectedToNetwork() {
             startLoader(view: self.view)
             
             DataProvider.sharedInstance.getDataWithPostMethod(parameter: para as [String : Any], url: "auth/delete_user_vehicles", { (json) in
                 print(json)
                 stopLoader()
                 
                 if json["status"].stringValue == "Success"
                 {
                    self.UserVehicleListFromServer()
                 }
                 else
                 {
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
