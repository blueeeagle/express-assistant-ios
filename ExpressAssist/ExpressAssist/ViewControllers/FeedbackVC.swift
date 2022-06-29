//
//  FeedbackVC.swift
//  ExpressAssist
//
//  Created by Apple on 30/08/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class FeedbackVC: UIViewController,UITextViewDelegate,FloatRatingViewDelegate {
  let appObject = UIApplication.shared.delegate as! AppDelegate
    
    //
    @IBOutlet weak var tvDescription: UITextView!
    @IBOutlet weak var labelThanx: UILabel!
    @IBOutlet weak var labelDes: UILabel!
      @IBOutlet weak var labelConfirm: UILabel!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnSkip: UIButton!
    let placeholderText = "Feedback"
    
    @IBOutlet weak var btnConfirm: UIButton!
     @IBOutlet weak var viewProvideRating: FloatRatingView!
     var Rating = 2.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnConfirm.isSelected = true
        viewProvideRating.delegate = self
                 viewProvideRating.contentMode = UIView.ContentMode.scaleAspectFit
                   viewProvideRating.type = .halfRatings
                    viewProvideRating.type = .halfRatings
      
          btnSkip.setTitle(NSLocalizedString("skip", comment: ""), for: UIControl.State.normal)
               labelThanx.text = NSLocalizedString("thank_you", comment: "")
               labelDes.text = NSLocalizedString("we_are_glad", comment: "")
            
          btnSubmit.setTitle(NSLocalizedString("submit", comment: ""), for: UIControl.State.normal)
        
        labelConfirm.text = NSLocalizedString("confirm", comment: "")
        // Do any additional setup after loading the view.
    }
    
    // MARK: FloatRatingViewDelegate
        
        func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
            print(rating)
            Rating = rating
            print(Rating)
        }
        
        func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
             print(rating)
             print(Rating)
        }
    @IBAction func btnSubmit(_ sender: Any) {
        if  btnConfirm.isSelected == false {
            Utility.showMessageDialog(onController: self, withTitle: NSLocalizedString("express", comment: ""), withMessage:"Please select confirm button ")
            return
        }
        else {
        self.sendRatingOnServer()
        }
    }
    
    @IBAction func btnSkip(_ sender: Any) {
        self.makeRoot()
    }
    
    @IBAction func btnConfirm(_ sender: Any) {
        if  btnConfirm.isSelected == false {
            btnConfirm.isSelected = true
        }
        else {
            btnConfirm.isSelected = false
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text == placeholderText {
            textView.text = ""
        }
        return true
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderText
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
    
    func sendRatingOnServer()
          {
            
              let para:[String:String] = ["rating":"\(Rating)","description":tvDescription.text]
              
              if Reachability.isConnectedToNetwork() {
                  startLoader(view: self.view)
                DataProvider.sharedInstance.postDataWithHeaderFieldwithPost(parameter: para as [String : String], url: "get_data/user_rating", { (json) in
              
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
}
