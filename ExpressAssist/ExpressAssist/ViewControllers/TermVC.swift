//
//  TermVC.swift
//  ExpressAssist
//
//  Created by samar on 08/06/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import WebKit

class TermVC: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webTermConditions: WKWebView!
    @IBOutlet weak var labelTerm: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelTerm.text = NSLocalizedString("termCondition", comment: "")
        let checkLanguage = UserDefaults.standard.bool(forKey:"en")
      if checkLanguage == false
      {
        if let pdf = Bundle.main.url(forResource: "En-Terms", withExtension: "pdf", subdirectory: nil, localization: nil)  {
            let req = NSURLRequest(url: pdf)
                    
            webTermConditions.load(req as URLRequest)
                    
                }
      }
      else  {
        
        if let pdf = Bundle.main.url(forResource: "AR-Terms", withExtension: "pdf", subdirectory: nil, localization: nil)  {
            let req = NSURLRequest(url: pdf)
                    
            webTermConditions.load(req as URLRequest)
                    
                }
      }

       
    }
    
    @IBAction func btnBack(_ sender: Any) {
       self.navigationController?.popViewController(animated: true)
      }
    
}
