//
//  Utils.swift
//  App4Taxi
//
//  Created by MACMINI2 on 14/11/17.
//  Copyright © 2017 Udaan. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class Utility: NSObject {
    class func removeWhiteSpace(_ str:String) -> String {
        return str.trimmingCharacters(in: CharacterSet.whitespaces)
    }

    
    
    class func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    
    class func showMessageDialog( onController controller: UIViewController, withTitle title: String?,  withMessage message: String?, withError error: NSError? = nil, onClose closeAction: (() -> Void)? = nil) {
        var mesg: String?
        if let err = error {
            mesg = "\(String(describing: message))\n\n\(err.localizedDescription)"
            NSLog("Error: %@ (error=%@)", message!, (error ?? ""))
        } else {
            mesg = message
        }
        
        let alert = UIAlertController(title: title, message: mesg, preferredStyle: .alert)
      
        
//        alert.addAction(UIAlertAction(title: "OK", style: .cancel) { (_) in
//            if let action = closeAction {
//                action()
//            }
//        })
        
        alert.view.tintColor = #colorLiteral(red: 0.9813671708, green: 0.6461395025, blue: 0.1477707922, alpha: 1)
        controller.present(alert, animated: true, completion: nil)
        
        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when){
            // your code with delay
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
  class  func addPaddingAndBorder(to textfield: UITextField) {
        textfield.layer.cornerRadius =  5
//        textfield.layer.borderColor = UIColor.clear.cgColor
//        textfield.layer.borderWidth = 1
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 8.0, height: 2.0))
        leftView.backgroundColor = UIColor.clear
        textfield.leftView = leftView
        textfield.leftViewMode = .always
    }
    
    
    
    class func resizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
}
}

extension String
{
    func trim() -> String
    {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
}

class paddingLabel: UILabel {
    
    override func draw(_ rect: CGRect) {
        let inset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        super.drawText(in: rect.inset(by: inset))
    }
}

