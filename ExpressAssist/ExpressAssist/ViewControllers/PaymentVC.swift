//
//  PaymentVC.swift
//  ExpressAssist
//
//  Created by RV on 19/01/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import WebKit

class PaymentVC: UIViewController, WKNavigationDelegate {
 @IBOutlet weak var webView: WKWebView!
     var checkSuccess = 0
    var strCurrentDateAndTime = ""
    var strVehicleId = ""
    var isConnectWithPaymentPage = false
    var strVehicleNumber = ""
    var isfromCreditCard = false
      let appObject = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        let now = Date()
               let formatter = DateFormatter()
               formatter.timeZone = TimeZone.current
               formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
               let dateString = formatter.string(from: now)
               print(dateString)
               strCurrentDateAndTime = dateString
        webView.navigationDelegate = self
        
        let string = "https://expressassistapp.com/api/make_payment?name=\(AppData().name)&email=\(AppData().email)&mobile=\(AppData().phone)&gender=&country=bahrain&city=sitra&address=&note=&send_address=No&amount=1"
        
      let result = string.removeWhitespace()
              
        let url = URL(string: result)
        
        print(url!)
        
        webView.load(URLRequest(url: url!))
        webView.allowsBackForwardNavigationGestures = true
        
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

    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
           decisionHandler(.allow)
           guard let urlAsString = navigationAction.request.url?.absoluteString.lowercased()
            else {
               return
           }
          print(urlAsString)
        if urlAsString.contains("checkout/pay") {
            print("&&&&&&&")
            isfromCreditCard = true
           
        }
        if isfromCreditCard == true {
            if urlAsString.contains("hostedcheckout") {
                self.updatePaymentOnServer(txnID:"876567576")
            }
        }
        
       else {
      
        let breakString = urlAsString.components(separatedBy: "=")
        print(breakString)
       
            
        if urlAsString.contains("paymentcancel") {
            print("exists")
            self.makeRoot()
            return
        }
        let breakStr = urlAsString.components(separatedBy: "&")
        print(breakStr)
        if breakStr.count > 1 {
        if breakStr[1] == "api_process" {
            isConnectWithPaymentPage = true
        }
       
        }
        if isConnectWithPaymentPage == true {
            isConnectWithPaymentPage = false
            if breakStr.count > 1 {
                if breakStr[1].contains("calculated_hash"){
                    let getPaymentID = breakStr[0].components(separatedBy: "?")
                    print(getPaymentID[1])
                    let finalPaymentID = getPaymentID[1].components(separatedBy: "=")
                    print(finalPaymentID[1])
                    self.updatePaymentOnServer(txnID:"\(finalPaymentID[1])")
                return

                }
            }
        }
        if breakString.count > 1 {
         if breakString[1] == "validate" {
            self.updatePaymentOnServer(txnID:"76786755")
            return
        }
        }
        
            if breakStr.count > 1 {
                if breakStr[1].contains("calculated_hash"){
                    self.makeRoot()
                    return


                }
            
        }
   
          
        
            
         checkSuccess = checkSuccess + 1
         print(checkSuccess)
          if checkSuccess == 6 {
           
            let splits = urlAsString.components(separatedBy: "=")
            print(splits)
            if splits[0] ==  "about:blank"{
                
            }
//                else if checkSuccess == 10 {
//                self.makeRoot()
//            }
//
//            else {
//            self.updatePaymentOnServer(txnID:"\(splits[1])")
//            }
                    }
    }
//
           if urlAsString.range(of: "the url that the button redirects the webpage to") != nil {
           // do something
           }
        }
    func updatePaymentOnServer(txnID:String)
     {
     
         let para:[String:Any] = [
             "user_id":AppData().ID,"transaction_id":txnID,"amount":"5","payment_mode":"Online","payment_status":"success","payment_date":strCurrentDateAndTime,"vehicle_id":strVehicleId]
         print("Parameters send\(para)")
         if Reachability.isConnectedToNetwork() {
             startLoader(view: self.view)
             
             DataProvider.sharedInstance.getDataWithPostMethod(parameter: para as [String : Any], url: "auth/make_user_payment", { (json) in
                 print(json)
                 stopLoader()
                 
                 if json["status"].stringValue == "Success"
                 {
                    self.isfromCreditCard = false
                    AppData().vehicleNumber = self.strVehicleNumber
                    AppData().checkPaid = json["data"]["payment_status"].stringValue
                    let alertController = UIAlertController(title: NSLocalizedString("express", comment: ""), message: json["Message"].stringValue, preferredStyle: .alert)
                              
                              let action1 = UIAlertAction(title: "ok", style: .default) { (action:UIAlertAction) in
                                
                                self.makeRoot()
                               
                              }
                              
                              alertController.addAction(action1)
                             
                              self.present(alertController, animated: true, completion: nil)
                
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
extension String {
   func replace(string:String, replacement:String) -> String {
       return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
   }

   func removeWhitespace() -> String {
       return self.replace(string: " ", replacement: "")
   }
 }
