//
//  LanguageVC.swift
//  ExpressAssist
//
//  Created by Apple on 07/09/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class LanguageVC: UIViewController {
    @IBOutlet weak var btnArbic: UIButton!
    @IBOutlet weak var btnEng: UIButton!
    
    @IBOutlet weak var labelChooseLanguage: UILabel!
    @IBOutlet weak var labelLanguageDes: UILabel!
    @IBOutlet weak var btnContinue: UIButton!
    
    @IBOutlet weak var labelEngBottom: UILabel!
    @IBOutlet weak var labelArBottom: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
         
                 btnEng.isSelected = true
                 btnArbic.isSelected = false
             
        labelEngBottom.text = "Choose to continue in english."
        labelArBottom.text = "استمر باللغة العربية"
      btnContinue.setTitle(NSLocalizedString("continue", comment: ""), for: UIControl.State.normal)
    }
    
   @IBAction func btnLangEng(_ sender: Any) {
       btnEng.isSelected = true
       btnArbic.isSelected = false
    UserDefaults.standard.set(true, forKey: "en")
    UserDefaults.standard.set(false, forKey: "ar")
    Bundle.setLanguage("en")
    labelChooseLanguage.text = "Choose language"
     labelLanguageDes.text = "Choose your preferred language"
btnContinue.setTitle(NSLocalizedString("continue", comment: ""), for: UIControl.State.normal)
   }
   
   @IBAction func btnlangArbic(_ sender: Any) {
       btnArbic.isSelected = true
       btnEng.isSelected = false
       UserDefaults.standard.set(true, forKey: "ar")
      UserDefaults.standard.set(false, forKey: "en")
      Bundle.setLanguage("ar")
    labelChooseLanguage.text = "اللغة المفضلة"
       labelLanguageDes.text = "اللغة المفضلة"
     btnContinue.setTitle(NSLocalizedString("continue", comment: ""), for: UIControl.State.normal)
   }
    
    @IBAction func btnContinue(_ sender: Any) {
      
        let login = self.storyboard?.instantiateViewController(identifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(login, animated: true)
    }
    
}
