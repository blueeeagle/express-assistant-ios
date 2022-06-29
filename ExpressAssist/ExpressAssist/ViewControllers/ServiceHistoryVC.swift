//
//  ServiceHistoryVC.swift
//  ExpressAssist
//
//  Created by Apple on 29/08/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
class ServiceCell: UITableViewCell
{
         @IBOutlet weak var labelUserVehicleNumber: UILabel!
          @IBOutlet weak var labelUserVehicleRegistrationDate: UILabel!
         @IBOutlet weak var labelDriverVehicleLocation: UILabel!
         @IBOutlet weak var labelDriverVehicleSubLocation: UILabel!
         @IBOutlet weak var labelUserVehicleLocation: UILabel!
         @IBOutlet weak var labelUserVehicleSubLocation: UILabel!
        @IBOutlet weak var labelStatus: UILabel!
}

class ServiceHistoryVC: UIViewController, UITableViewDelegate,UITableViewDataSource  {
 @IBOutlet weak var labelServiceHistory: UILabel!
    var arrayServiceList = [Any]()
    @IBOutlet weak var tableService: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        labelServiceHistory.text = NSLocalizedString("service_history", comment: "")
        self.getServiceList()
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
    
    //MARK: Table delegate and datasources method
               
           public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
               {
                 
                   return arrayServiceList.count
                 
                   
               }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
             {
             
                    let cell : ServiceCell? = tableView.dequeueReusableCell(withIdentifier: "cell") as? ServiceCell
                let dicData = arrayServiceList[indexPath.row] as! NSDictionary
                   
                   cell?.labelUserVehicleNumber.text  = (dicData.value(forKey: "user_vehicle_no") as! String)
                   cell?.labelUserVehicleRegistrationDate.text  = (dicData.value(forKey: "service_date") as! String)
                   cell?.labelDriverVehicleLocation.text  = (dicData.value(forKey: "user_end_loc") as! String)
                   cell?.labelDriverVehicleSubLocation.text  = (dicData.value(forKey: "user_end_loc") as! String)
                   cell?.labelUserVehicleLocation.text  = (dicData.value(forKey: "user_start_loc") as! String)
                   cell?.labelUserVehicleSubLocation.text  = (dicData.value(forKey: "user_start_loc") as! String)
                     cell?.labelStatus.text  = (dicData.value(forKey: "status") as! String)
                
                 return cell!
               
             }
             func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
             
                return 200.0
               
             }

   func getServiceList()
      {
          if Reachability.isConnectedToNetwork() {
              startLoader(view: self.view)
              
                  DataProvider.sharedInstance.postDataWithoutParameter(url: "get_data/get_user_services", { (json) in
                  print(json)
                  stopLoader()
                  if json["status"].stringValue == "Success" {
                      
                          self.arrayServiceList = json["data"].arrayObject!
                      self.tableService.reloadData()
                   
                      
                  }
                  else  {
                      Utility.showMessageDialog(onController: self, withTitle: NSLocalizedString("express", comment: ""), withMessage:NSLocalizedString(json["Message"].string!, comment: ""))
                  }
                  
              }) { (error) in
                  print(error)
                  stopLoader()
              }
              
          }else{
              Utility.showMessageDialog(onController: self, withTitle: NSLocalizedString("express", comment: ""), withMessage: NSLocalizedString("network_issue", comment: ""))
          }
      }
}
