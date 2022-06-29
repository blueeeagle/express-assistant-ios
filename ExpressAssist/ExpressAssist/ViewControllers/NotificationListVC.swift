//
//  NotificationListVC.swift
//  ExpressAssist
//
//  Created by Apple on 29/08/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell
{
   
    @IBOutlet weak var labelNotificationTitle: UILabel!
    @IBOutlet weak var labelNotificationDescription: UILabel!
     @IBOutlet weak var labelNotificationDate: UILabel!
   
    
}
class NotificationListVC: UIViewController, UITableViewDelegate,UITableViewDataSource  {
   var arrayNotification = [Any]()
    @IBOutlet weak var tableNotifications: UITableView!
    @IBOutlet weak var labelNotification: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelNotification.text = NSLocalizedString("notification", comment: "")
        tableNotifications.rowHeight = UITableView.automaticDimension
        tableNotifications.estimatedRowHeight = UITableView.automaticDimension
        self.getNotificationFromServer()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
             self.tabBarController?.tabBar.isHidden = false
             
         }
    
    //MARK: Table delegate and datasources method
            
         
            
        public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
            {
              
                return  arrayNotification.count
              
                
            }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
          {
          
                 let cell : NotificationCell? = tableView.dequeueReusableCell(withIdentifier: "cell") as? NotificationCell
            let dicData = arrayNotification[indexPath.row] as! NSDictionary
                      cell?.labelNotificationTitle.text  = (dicData.value(forKey: "title") as! String)
                      cell?.labelNotificationDescription.text  = (dicData.value(forKey: "description") as! String)
                      cell?.labelNotificationDate.text  = (dicData.value(forKey: "date") as! String)
             
              return cell!
            
          }
          func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          
            return UITableView.automaticDimension
            
          }
  
    func getNotificationFromServer()
          {
              if Reachability.isConnectedToNetwork() {
                  startLoader(view: self.view)
                  DataProvider.sharedInstance.getMethodToFetchDataWithContentForNotificationList( url: "get_data/notification_list?type=\("user")", { (response) in
                      print(response)
                      stopLoader()
                      if response["status"].stringValue == "Success" {
                          
                              self.arrayNotification = response["data"].arrayObject!
                              self.tableNotifications.reloadData()
                       
                          
                      }
                      else  {
                          Utility.showMessageDialog(onController: self, withTitle: NSLocalizedString("express", comment: ""), withMessage:NSLocalizedString(response["Message"].string!, comment: ""))
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
