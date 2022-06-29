//
//  CancelRideVC.swift
//  ExpressDriver
//
//  Created by Apple on 16/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class CancelRideVC: UIViewController {
@IBOutlet weak var tvMessage: UITextView!
      @IBOutlet weak var labelCancel: UILabel!
    @IBOutlet weak var labelReason: UILabel!
    @IBOutlet weak var btnSubmit: UIButton!
    var strReqID = ""
      let appObject = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()

        
        labelCancel.text = NSLocalizedString("cancel", comment: "")
        labelReason.text = NSLocalizedString("reason", comment: "")
        
          btnSubmit.setTitle(NSLocalizedString("submit", comment: ""), for: UIControl.State.normal)
        // Do any additional setup after loading the view.
    }
    
      override func viewWillAppear(_ animated: Bool) {
           self.tabBarController?.tabBar.isHidden = true
       }
    override func viewDidDisappear(_ animated: Bool) {
      self.tabBarController?.tabBar.isHidden = false
    }
    @IBAction func btnSubmit(_ sender: Any) {
        if (tvMessage.text?.count)! == 0 {
                                             Utility.showMessageDialog(onController: self, withTitle: "", withMessage:NSLocalizedString("type_your_message", comment: ""))
                                           return
                     }
        self.CancelRequestByUser()
    }
    @IBAction func btnBack(_ sender: Any) {
               self.navigationController?.popViewController(animated: true)
           }
    func CancelRequestByUser()
          {
//
//              let para:[NSString:NSString] = ["request_id":"",
//                  "reasonof_cancel":tvMessage.text,"status":"Cancel"]
            
            let para:[NSString:Any] = [
                             "request_id":strReqID,
                             "reasonof_cancel":tvMessage.text!,"status":"cancelled"
                         ]
              
              if Reachability.isConnectedToNetwork() {
                  startLoader(view: self.view)
                DataProvider.sharedInstance.postDataWithHeaderFieldwithPost(parameter: para as! [String : String], url: "get_data/booking_request_cancel_by_user", { (json) in
              
                      print(json)
                      stopLoader()
                      if json["status"].stringValue == "Success" {
                        self.makeRoot()
                       
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
                  Utility.showMessageDialog(onController: self, withTitle: "Alert", withMessage: NSLocalizedString("network_issue", comment: ""))
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
