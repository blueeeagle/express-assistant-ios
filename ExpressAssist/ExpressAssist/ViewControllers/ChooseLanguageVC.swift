//
//  ChooseLanguageVC.swift
//  ExpressAssist
//
//  Created by Apple on 08/09/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class ChooseLanguageVC: UIViewController {
let appObject = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var btnArbic: UIButton!
      @IBOutlet weak var btnEng: UIButton!
    //
    
    @IBOutlet weak var labelEng: UILabel!
    @IBOutlet weak var labelAr: UILabel!
   
    @IBOutlet weak var labelEngTitle: UILabel!
    @IBOutlet weak var labelArTitle: UILabel!
    
    @IBOutlet weak var labelLanguage: UILabel!
    @IBOutlet weak var btnContinue: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelEng.text = "Choose to continue in english."
        labelAr.text = "استمر باللغة العربية"
        labelEngTitle.text = "English."
        labelArTitle.text = "عربي"
         
          let checkLanguage = UserDefaults.standard.bool(forKey:"en")
        if checkLanguage == false
        {
            btnEng.isSelected = false
            btnArbic.isSelected = true
        }
        else  {
            btnEng.isSelected = true
            btnArbic.isSelected = false
        }
     
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        labelLanguage.text = NSLocalizedString("choose_language", comment: "")
       
        btnContinue.setTitle(NSLocalizedString("continue", comment: ""), for: UIControl.State.normal)

    }
 override func viewDidDisappear(_ animated: Bool) {
   self.tabBarController?.tabBar.isHidden = false
 }
    @IBAction func btnLangEng(_ sender: Any) {
          btnEng.isSelected = true
          btnArbic.isSelected = false
        UserDefaults.standard.set(true, forKey: "en")
          UserDefaults.standard.set(false, forKey: "ar")
          Bundle.setLanguage("en")
         btnContinue.setTitle(NSLocalizedString("continue", comment: ""), for: UIControl.State.normal)
          labelLanguage.text = NSLocalizedString("choose_language", comment: "")
      }
      
      @IBAction func btnlangArbic(_ sender: Any) {
          btnArbic.isSelected = true
          btnEng.isSelected = false
          UserDefaults.standard.set(true, forKey: "ar")
          UserDefaults.standard.set(false, forKey: "en")
          Bundle.setLanguage("ar")
      btnContinue.setTitle(NSLocalizedString("continue", comment: ""), for: UIControl.State.normal)
        labelLanguage.text = NSLocalizedString("choose_language", comment: "")
      }
    @IBAction func btnContinue(_ sender: Any) {
        self.makeRoot()
    }
    @IBAction func btnBack(_ sender: Any) {
            self.navigationController?.popViewController(animated: true)
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
