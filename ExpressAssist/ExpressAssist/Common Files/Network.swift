//
//  Network.swift
//  App4Taxi
//
//  Created by MACMINI2 on 14/11/17.
//  Copyright © 2017 Udaan. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class DataProvider: NSObject {
    
    class var sharedInstance:DataProvider {
        struct Singleton {
            static let instance = DataProvider()
        }
        return Singleton.instance
    }
    //http://marketingchord.com/express
  
    let baseUrl:String = "https://expressassistapp.com/api/"
    
    //let baseUrl:String = "http://192.168.1.115:8000/"
    
    func getData( parameter:[String:Any], url:String, _ successBlock:@escaping ( _ response: JSON )->Void , errorBlock: @escaping (_ error: NSError) -> Void ){
        
        let path =  baseUrl + url
        print(path)
        print(parameter)
        
       // let headers = ["Content-Type": "application/json","translation":NSLocalizedString("langPara", comment: "")]
        Alamofire.request(path, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
    
            //print(response.data)
            print(response.description)
            print(response.result)
//
            print(response)
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    successBlock(json)
                }
            case .failure(let error):
                errorBlock(error as NSError)
            }
        }
        
    }
    
    
    func getDataWithPostMethod( parameter:[String:Any], url:String, _ successBlock:@escaping ( _ response: JSON )->Void , errorBlock: @escaping (_ error: NSError) -> Void ){
        
        let path =  baseUrl + url
        
        print(path)
        print(parameter)
        
        let headerValue =  AppData().token
        let headers = ["Authorization": headerValue]
        // let headers = ["Content-Type": "application/json","translation":NSLocalizedString("langPara", comment: "")]
        
        Alamofire.request(path, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            
            //print(response.data)
            print(response.description)
            print(response.result)
            //
            print(response)
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    successBlock(json)
                }
            case .failure(let error):
                errorBlock(error as NSError)
            }
        }
        
    }
    

    
    func postDataWithoutParameter( url:String, _ successBlock:@escaping ( _ response: JSON )->Void , errorBlock: @escaping (_ error: NSError) -> Void ){
        
        let path =  baseUrl + url
        
        print(path)
  
        let headerValue =  AppData().token
    
        let headers = ["Authorization": headerValue]
        Alamofire.request(path, method: .post, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            
            //            print(response.data)
            //            print(response.description)
            //            print(response.result)
            //            print(response.response)
            print(response)
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    successBlock(json)
                }
            case .failure(let error):
                errorBlock(error as NSError)
            }
        }
        
    }
    
    func getMethodToFetchData( url:String, _ successBlock:@escaping ( _ response: JSON )->Void , errorBlock: @escaping (_ error: NSError) -> Void ){
        
        let path =  baseUrl + url
        print(path)
        
        let headerValue =  AppData().token
             let headers = ["Authorization": headerValue]
        
//        let headers = ["Content-Type": "application/json","translation":NSLocalizedString("langPara", comment: "")]
        Alamofire.request(path, method: .get, encoding: JSONEncoding.default,headers: headers).responseJSON { response in
            
            
            /* print(response.data)
             print(response.description)
             print(response.result)
             print(response.response)
             print(response)*/
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    successBlock(json)
                }
            case .failure(let error):
                errorBlock(error as NSError)
            }
        }
        
    }
    
     func getMethodToFetchDetailsPage( url:String, _ successBlock:@escaping ( _ response: JSON )->Void , errorBlock: @escaping (_ error: NSError) -> Void ){
            
            let path =  baseUrl + url
            print(path)
            
            let headerValue =  AppData().token
                 let headers = ["Authorization": headerValue]
            
    //        let headers = ["Content-Type": "application/json","translation":NSLocalizedString("langPara", comment: "")]
            Alamofire.request(path, method: .get, encoding: JSONEncoding.default,headers: headers).responseJSON { response in
                
                
                /* print(response.data)
                 print(response.description)
                 print(response.result)
                 print(response.response)
                 print(response)*/
                switch response.result {
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        successBlock(json)
                    }
                case .failure(let error):
                    errorBlock(error as NSError)
                }
            }
            
        }
      func getMethodWithHeader( url:String, _ successBlock:@escaping ( _ response: JSON )->Void , errorBlock: @escaping (_ error: NSError) -> Void ){
            
            let path =  baseUrl + url
            print(path)
            
            let headerValue =  AppData().token
                 let headers = ["Authorization": headerValue]
            
    //        let headers = ["Content-Type": "application/json","translation":NSLocalizedString("langPara", comment: "")]
            Alamofire.request(path, method: .get, encoding: JSONEncoding.default,headers: headers).responseJSON { response in
                
                
                /* print(response.data)
                 print(response.description)
                 print(response.result)
                 print(response.response)
                 print(response)*/
                switch response.result {
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        successBlock(json)
                    }
                case .failure(let error):
                    errorBlock(error as NSError)
                }
            }
            
        }
    func getMethodToFetchDataWithHeader( url:String, _ successBlock:@escaping ( _ response: JSON )->Void , errorBlock: @escaping (_ error: NSError) -> Void ){
        
        let passToken = AppData().token   //"?access_token=a"
        
        let path =  baseUrl + url + "?access_token=" + passToken
        print(path)
        
        let headerValue = "Bearer " + AppData().token
        let headers = ["authorization": headerValue, "Content-Type": "application/json","translation":NSLocalizedString("langPara", comment: "")]
        
        Alamofire.request(path, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            
            /* print(response.data)
             print(response.description)
             print(response.result)
             print(response.response)
             print(response)*/
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    successBlock(json)
                }
            case .failure(let error):
                errorBlock(error as NSError)
            }
        }
        
    }
    
    func getMethodToFetchDataWithContentHeader( url:String, _ successBlock:@escaping ( _ response: JSON )->Void , errorBlock: @escaping (_ error: NSError) -> Void ){
        
        let passToken = AppData().token   //"?access_token=a"
        
        let path =  baseUrl + url
        print(path)
        
        //  let headerValue = "Bearer " + AppData().token
       // let headers = ["Content-Type": "application/json","translation":NSLocalizedString("langPara", comment: "")]
        
        Alamofire.request(path, method: .get, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            
            /* print(response.data)
             print(response.description)
             print(response.result)
             print(response.response)
             print(response)*/
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    successBlock(json)
                }
            case .failure(let error):
                errorBlock(error as NSError)
            }
        }
        
    }
    
    func getMethodToFetchDataWithContentForNotificationList( url:String, _ successBlock:@escaping ( _ response: JSON )->Void , errorBlock: @escaping (_ error: NSError) -> Void ){
        
        let passToken = AppData().token   //"?access_token=a"
        
        let path =  baseUrl + url
        print(path)
        
         let headerValue =  AppData().token
        let headers = ["authorization": headerValue,"Content-Type": "application/json","translation":NSLocalizedString("langPara", comment: "")]
        
        Alamofire.request(path, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            
            /* print(response.data)
             print(response.description)
             print(response.result)
             print(response.response)
             print(response)*/
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    successBlock(json)
                }
            case .failure(let error):
                errorBlock(error as NSError)
            }
        }
        
    }

    
    func postDataWithHeaderField( parameter:[String:Any]?, url:String, _ successBlock:@escaping ( _ response: JSON )->Void , errorBlock: @escaping (_ error: NSError) -> Void ){
        
        let path =  baseUrl + url
        print(path)
       
      //  let headerValue = "Bearer " + AppData().token
        
      // let headers = ["authorization": headerValue, "Content-Type": "application/json"]
      //  let headers = ["Content-Type": "application/json"]
        
            let headers = ["Content-Type": "application/json","translation":NSLocalizedString("langPara", comment: "")]
        
        Alamofire.request(path, method: .put, parameters: parameter, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    successBlock(json)
                }
            case .failure(let error):
                errorBlock(error as NSError)
            }
        }
        
    }
    
    
    func postDataWithHeaderFieldwithPost( parameter:[String:Any]?, url:String, _ successBlock:@escaping ( _ response: JSON )->Void , errorBlock: @escaping (_ error: NSError) -> Void ){
        
        let path =  baseUrl + url
        print(path)
        print("+++++++++++++++++++ this is my parameter \(String(describing: parameter))")
        
        let headerValue =  AppData().token
        let headers = ["Authorization": headerValue]
        
   
        
        Alamofire.request(path, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    successBlock(json)
                }
            case .failure(let error):
                errorBlock(error as NSError)
            }
        }
        
    }
    
    func uploadImage(parameter:[String:String], image:UIImage, url:String, _ successBlock:@escaping ( _ response: JSON )->Void , errorBlock: @escaping (_ error: NSError) -> Void ){
        
        let path =  baseUrl + url
        print(path)
       print("+++++++++++++++++++ this is my parameter with image \(String(describing: parameter))")
       // let imgData = UIImageJPEGRepresentation(image, 0.2)!
        let imgData = image.jpegData(compressionQuality: 0.2)!
//           let headers = ["Content-Type": "application/json","translation":NSLocalizedString("langPara", comment: "")]
        
        let headerValue =  AppData().token
                       let headers = ["Authorization": headerValue]
        let URL = try! URLRequest(url: path, method: .post, headers: headers)
      
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imgData, withName: "image",fileName: "file.jpg", mimeType: "file")
            
            for (key, value) in parameter {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        }, with: URL) { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    print(response.result.value)
                    if let value = response.result.value {
                        let json = JSON(value)
                        successBlock(json)
                    }
                }
                
            case .failure(let encodingError):
                print(encodingError)
                errorBlock(encodingError as NSError)
                
            }
        }
        
    }
    func uploadImagesWithDiffPara(parameter:[String:String], image1:UIImage, image2:UIImage,  url:String, _ successBlock:@escaping ( _ response: JSON )->Void , errorBlock: @escaping (_ error: NSError) -> Void ){
        
        let path =  baseUrl + url
        print(path)
        
        let headerValue =  AppData().token
        let headers = ["Authorization": headerValue]
     //   let headers = ["authorization": headerValue, "Content-Type": "application/json"]
        //let imgData = UIImageJPEGRepresentation(image, 0.2)!
        let imgData1 = image1.jpegData(compressionQuality: 0.2)!
        let imgData2 = image2.jpegData(compressionQuality: 0.2)!
     
        let URL = try! URLRequest(url: path, method: .post, headers: headers)
        
        // let parameter = ["id":AppData().ID]
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imgData1, withName: "front_image",fileName: "file.jpg", mimeType: "file")
              multipartFormData.append(imgData2, withName: "back_image",fileName: "file.jpg", mimeType: "file")
              
            
            for (key, value) in parameter {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }

            
            
        }, with: URL) { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    print(response.result.value)
                    if let value = response.result.value {
                        let json = JSON(value)
                        successBlock(json)
                    }
                }
                
            case .failure(let encodingError):
                print(encodingError)
                errorBlock(encodingError as NSError)
                
            }
        }
        
    }
    
    func uploadCupImages(parameter:[String:String], image1:UIImage, image2:UIImage, image3:UIImage,image4:UIImage,image5:UIImage, url:String, _ successBlock:@escaping ( _ response: JSON )->Void , errorBlock: @escaping (_ error: NSError) -> Void ){
        
        let path =  baseUrl + url
        print(path)
        
        let headerValue =  AppData().token
        let headers = ["Authorization": headerValue]
     //   let headers = ["authorization": headerValue, "Content-Type": "application/json"]
        //let imgData = UIImageJPEGRepresentation(image, 0.2)!
        let imgData1 = image1.jpegData(compressionQuality: 0.2)!
        let imgData2 = image2.jpegData(compressionQuality: 0.2)!
        let imgData3 = image3.jpegData(compressionQuality: 0.2)!
        let imgData4 = image4.jpegData(compressionQuality: 0.2)!
        let imgData5 = image5.jpegData(compressionQuality: 0.2)!
        let URL = try! URLRequest(url: path, method: .post, headers: headers)
        
        // let parameter = ["id":AppData().ID]
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imgData1, withName: "image1",fileName: "file.jpg", mimeType: "file")
              multipartFormData.append(imgData2, withName: "image2",fileName: "file.jpg", mimeType: "file")
              multipartFormData.append(imgData3, withName: "image3",fileName: "file.jpg", mimeType: "file")
            multipartFormData.append(imgData4, withName: "image4",fileName: "file.jpg", mimeType: "file")
           multipartFormData.append(imgData5, withName: "image5",fileName: "file.jpg", mimeType: "file")
            
            for (key, value) in parameter {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }

            
            
        }, with: URL) { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    print(response.result.value)
                    if let value = response.result.value {
                        let json = JSON(value)
                        successBlock(json)
                    }
                }
                
            case .failure(let encodingError):
                print(encodingError)
                errorBlock(encodingError as NSError)
                
            }
        }
        
    }
    func uploadTwoImages(parameter:[String:String], image1:UIImage, image2:UIImage, url:String, _ successBlock:@escaping ( _ response: JSON )->Void , errorBlock: @escaping (_ error: NSError) -> Void ){
        
        let path =  baseUrl + url
        print(path)
        
        let headerValue =  AppData().token
        let headers = ["Authorization": headerValue]
        //   let headers = ["authorization": headerValue, "Content-Type": "application/json"]
        //let imgData = UIImageJPEGRepresentation(image, 0.2)!
        let imgData1 = image1.jpegData(compressionQuality: 0.2)!
        let imgData2 = image2.jpegData(compressionQuality: 0.2)!
    
        let URL = try! URLRequest(url: path, method: .post, headers: headers)
        
        // let parameter = ["id":AppData().ID]
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imgData1, withName: "profile_image",fileName: "file.jpg", mimeType: "file")
            multipartFormData.append(imgData2, withName: "digree_img",fileName: "file.jpg", mimeType: "file")
        
            
            for (key, value) in parameter {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            
            
            
        }, with: URL) { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    print(response.result.value)
                    if let value = response.result.value {
                        let json = JSON(value)
                        successBlock(json)
                    }
                }
                
            case .failure(let encodingError):
                print(encodingError)
                errorBlock(encodingError as NSError)
                
            }
        }
        
    }
    
//    func uploadMultipleImages(parameter:[String:String], imageDataArray:[UIImage], url:String, _ successBlock:@escaping ( _ response: JSON )->Void , errorBlock: @escaping (_ error: NSError) -> Void ){
//        let path =  baseUrl + url
//        print(path)
//        print("+++++++++++++++++++ this is my parameter with Images \(String(describing: parameter))")
//        
//        
//        let URL = try! URLRequest(url: path, method: .post, headers: nil)
//        
//        Alamofire.upload(multipartFormData: { multipartFormData in
//
//
//            for i in 0..<imageDataArray.count{
//               // let imageData = UIImageJPEGRepresentation(imageDataArray[i] , 0.5)!
//                 let imageData = image.jpegData(compressionQuality: 0.5)!
//                let imageData = image.jpegData(compressionQuality: 0.5)!
//                
//                
//                multipartFormData.append(imageData, withName: "images[]", fileName: "\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpeg")
//            }
//            //}
//            for (key, value) in parameter {
//                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
//            }
//        },with: URL) { (result) in
//            switch result {
//            case .success(let upload, _, _):
//                
//                upload.uploadProgress(closure: { (progress) in
//                    print("Upload Progress: \(progress.fractionCompleted)")
//                })
//                
//                upload.responseJSON { response in
//                    print(response.result.value)
//                    if let value = response.result.value {
//                        let json = JSON(value)
//                        successBlock(json)
//                    }
//                }
//                
//            case .failure(let encodingError):
//                print(encodingError)
//                errorBlock(encodingError as NSError)
//                
//            }
//        }
//        
//        
//    }

    
}
