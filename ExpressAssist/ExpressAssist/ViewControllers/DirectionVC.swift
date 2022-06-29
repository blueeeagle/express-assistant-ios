//
//  DirectionVC.swift
//  ExpressAssist
//
//  Created by Apple on 09/09/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import GoogleMaps
import SwiftyJSON
import CoreLocation
import Firebase
class DirectionVC: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate  {
    @IBOutlet weak var viewMap: GMSMapView!
        var locationManager = CLLocationManager()
    var arrayPolyline = [GMSPolyline]()
    var selectedRought:String!
    var iPosition = 0
    var stepCoords:[CLLocationCoordinate2D] = []
    var timer:Timer?
   // var marker:GMSMarker?
    var  markerSoucres = GMSMarker()
    let markerDestination = GMSMarker()
    
    var strCurrentLocation = ""
    var strDestination = ""
    var strImageUrl = ""
    var strPlaceName = ""
    //
    
    //
      var strBookingID = ""
        
      var strDriverName = ""
      var strUserPhoneNumber = ""
      var strUserVehicleNumber = ""
      
      var strDriverVehicleNumber = ""
    
      var strUserRegistrationdate = ""
      var strDriverLocation = ""
      var strDriverSubLocation = ""
      var strUserLocation = ""
      var strUserSubLocation = ""
   
     @IBOutlet weak var labelDriverVehicleNumber: UILabel!
    @IBOutlet weak var imageDriverProfile: UIImageView!
    @IBOutlet weak var labelDriverName: UILabel!
    
  //  var strGetBookingId = ""
    
    var strUserBookingLocation = ""
    var strDriverPickUpLocation = ""
   
    var strPhoneNumber = ""
    var strUserVechuleNumber = ""
    var strDriverPhoneNumber = ""
    
    @IBOutlet weak var labeluserPickLocation: UILabel!

    let appObject = UIApplication.shared.delegate as! AppDelegate
    
    //
     @IBOutlet weak var labelUserVechicleNumber: UILabel!
         @IBOutlet weak var labelUserVehicleRegistrationDate: UILabel!
        @IBOutlet weak var labelUserVehicleLocation: UILabel!
        @IBOutlet weak var labelUserVehicleSubLocation: UILabel!
        @IBOutlet weak var labelDriverVehicleLocation: UILabel!
        @IBOutlet weak var labelDriverVehicleSubLocation: UILabel!
       @IBOutlet weak var labelDistanceTime: UILabel!
         @IBOutlet weak var labelTopUserName: UILabel!
       @IBOutlet weak var btnCancel: UIButton!
  
    override func viewDidLoad() {
        super.viewDidLoad()
         
       // self.timer =  Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)

        
        let data    = self.strDestination
        let dataArray = data.components(separatedBy: ",")
        print(dataArray)
        
        let lat    = dataArray[0]
        let long = dataArray[1]
        print(lat)
        print(long)
        self.convertLatLongToAddress(latitude: Double(lat)!, longitude: Double(long)!)
       
        btnCancel.setTitle(NSLocalizedString("cancel", comment: ""), for: UIControl.State.normal)
        
        labelDriverName.text = strDriverName
         labelDriverVehicleNumber.text = strDriverVehicleNumber
        labelUserVechicleNumber.text = AppData().vehicleNumber
        labelUserVehicleRegistrationDate.text = strUserRegistrationdate
        
        //
//         labelUserVehicleLocation.text = strDriverLocation
//         labelUserVehicleSubLocation.text = strUserLocation
//
//        labelDriverVehicleLocation.text = strDriverLocation
//        labelDriverVehicleSubLocation.text = strDriverLocation
        
    
         labelTopUserName.text = "Meet \(strDriverName) at the pickup points"
        if strImageUrl == "" {
                       self.imageDriverProfile.image = UIImage(named: "dummy_user.png")
                   }
                   else {
                                      strImageUrl =  strImageUrl.trim().replacingOccurrences(of: " ", with: "%20")
                                      print(strImageUrl)
                                             
                                      let url = NSURL(string: strImageUrl)
                                      self.imageDriverProfile.af_setImage(withURL: url! as URL)
                   }
       
        
   
            //viewMap.settings.myLocationButton = true
             viewMap.isMyLocationEnabled = false
             locationManager.delegate = self
             locationManager.requestWhenInUseAuthorization()
             locationManager.desiredAccuracy = kCLLocationAccuracyBest
             locationManager.startUpdatingLocation()
           //  viewMap.settings.compassButton = true
           //  viewMap.isMyLocationEnabled = true
           //  viewMap.settings.myLocationButton = true
        
        let notificationCenter = NotificationCenter.default
                   notificationCenter.addObserver(self, selector: #selector(checkRide), name: UIApplication.willEnterForegroundNotification, object: nil)
             
          //   labelPlaceName.text = strPlaceName
           //   let url = NSURL(string: strImageUrl)
           //  imagePlace.af_setImage(withURL: url! as URL)
    }
    
    override func viewWillAppear(_ animated: Bool) {
         self.tabBarController?.tabBar.isHidden = true
        
        
        Database.database().reference().child("Location").child(strBookingID).observe(.value, with: { snapshot in
          // This is the snapshot of the data at the moment in the Firebase database
          // To get value from the snapshot, we user snapshot.value
          print(snapshot.value! as Any)
        print("&&&&&&&&&&&&&&&&&&&&&")
            let dicFireBase = snapshot.value as? NSDictionary
            let lat = dicFireBase?["lat"] as? String ?? "0.0"
            let long = dicFireBase?["long"] as? String ?? "0.0"
            self.markerDestination.position = CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(long)!)
           // self.markerSoucres.icon = UIImage(named: "Car")
            self.markerDestination.map = self.viewMap
            self.strDestination = lat + "," + long

        })
      }
      override func viewWillDisappear(_ animated: Bool) {
         self.tabBarController?.tabBar.isHidden = false
      }
    @objc func updateCounter() {
        self.LoadMapRoute()
    }
    
    @objc func checkRide() {
           print("app enters foreground")
           self.checkRideStatus()
       }
    @IBAction func btnCancel(_ sender: Any) {
        self.timer!.invalidate()
               self.makeRoot()
           }
    @IBAction func btnCallinguser(_ sender: Any) {
          if let url = URL(string: "tel://\(strDriverPhoneNumber)"),
            UIApplication.shared.canOpenURL(url) {
               if #available(iOS 10, *) {
                 UIApplication.shared.open(url, options: [:], completionHandler:nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            } else {
                     // add error message here
            }
      }
    @IBAction func btnCancelRide(_ sender: Any) {
        
        let cancel = self.storyboard?.instantiateViewController(identifier: "CancelRideVC") as! CancelRideVC
        cancel.strReqID = strBookingID
        self.navigationController?.pushViewController(cancel, animated: true)
    }
    @IBAction func btnCalling(_ sender: Any) {
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
    func LoadMapRoute()
       {
           print(strCurrentLocation)
           print(strDestination)
      
//        strCurrentLocation = "26.10322,50.48397"
        //strDestination = "26.13697,50.61013"
           let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(strCurrentLocation)&destination=\(strDestination)&mode=driving&key=AIzaSyCZUjAFh5Q4SUIWmHj8D2dl_UlSMGulAp0"

           let url = URL(string: urlString)
           URLSession.shared.dataTask(with: url!, completionHandler:
               {
               (data, response, error) in
               if(error != nil)
               {
                   print("error")
               }
               else
               {
                   
                   do{
                       let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                       let arrRouts = json["routes"] as! NSArray
                       print(arrRouts)
                       
                       guard let route = arrRouts[0] as? [String: Any] else {
                                 return
                             }
//
                        let dicRoute = route["overview_polyline"] as! NSDictionary
                     let points = (dicRoute["points"] as! String)
                    let path = GMSPath.init(fromEncodedPath: points)
                      let polyline = GMSPolyline.init(path: path)
                      polyline.map = self.viewMap
        
                    //self.stepCoords =
                              let legs = route["legs"] as! NSArray
                              print(legs)
                                  let dicMain = legs[0] as! NSDictionary
                                  let disDistance = dicMain["distance"] as! NSDictionary
                       let dicDuration = dicMain["duration"] as! NSDictionary
                       print(disDistance["text"] as! String)
                      
                       DispatchQueue.main.sync {
                          self.labelDistanceTime.text = " Towing truck arriving in " + (dicDuration["text"] as! String)
                         //  self.labelTime.text =  "Total Time: " + (dicDuration["text"] as! String)
                       }
                
                       for  polyline in self.arrayPolyline
                       {
                           polyline.map = nil;
                       }

                       self.arrayPolyline.removeAll()

                       let pathForRought:GMSMutablePath = GMSMutablePath()

                       if (arrRouts.count == 0)
                       {
                           let data    = self.strCurrentLocation
                           let dataArray = data.components(separatedBy: ",")
                           print(dataArray)
                           
                           let lat    = dataArray[0]
                           let long = dataArray[1]
                           print(lat)
                           print(long)
                           
                           let dataDestination    = self.strDestination
                           let destination = dataDestination.components(separatedBy: ",")
                           print(destination)
                           
                           let latDes    = destination[0]
                           let longDes = destination[1]
                           print(latDes)
                           print(longDes)

                           
                           
                           let distance:CLLocationDistance = CLLocation.init(latitude: Double(lat)!, longitude: Double(long)!).distance(from: CLLocation.init(latitude:  Double(latDes)!, longitude:  Double(longDes)!))
                           print("++++++++++\(distance)")

                          // pathForRought.add(self.source)
                      //     pathForRought.add(self.destination)

                           let polyline = GMSPolyline.init(path: pathForRought)
                           self.selectedRought = pathForRought.encodedPath()
                           polyline.strokeWidth = 5
                           polyline.strokeColor = UIColor.blue
                           polyline.isTappable = true

                           self.arrayPolyline.append(polyline)

                           if (distance > 8000000)
                           {
                               polyline.geodesic = false
                           }
                           else
                           {
                               polyline.geodesic = true
                           }

                           polyline.map = self.viewMap;
                       }
                       else
                       {
                           for (index, element) in arrRouts.enumerated()
                           {
                               let dicData:NSDictionary = element as! NSDictionary
                               
                                

                               let routeOverviewPolyline = dicData["overview_polyline"] as! NSDictionary

                               let path =  GMSPath.init(fromEncodedPath: routeOverviewPolyline["points"] as! String)

                               let polyline = GMSPolyline.init(path: path)

                               polyline.isTappable = true

                               self.arrayPolyline.append(polyline)

                               polyline.strokeWidth = 5

                               if index == 0
                               {
                                   self.selectedRought = routeOverviewPolyline["points"] as? String

                                   polyline.strokeColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
                               }
                               else
                               {
                                   polyline.strokeColor = UIColor.darkGray;
                               }

                               polyline.geodesic = true;
                           }

                           for po in self.arrayPolyline.reversed()
                           {
                               po.map = self.viewMap;
                           }
                       }

                       DispatchQueue.main.asyncAfter(deadline: .now() + 0.5)
                       {
                           let bounds:GMSCoordinateBounds = GMSCoordinateBounds.init(path: GMSPath.init(fromEncodedPath: self.selectedRought)!)

                           self.viewMap.animate(with: GMSCameraUpdate.fit(bounds))
                       }
                   }
                   catch let error as NSError
                   {
                       print("error:\(error)")
                   }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                              self.checkRideStatus()
                                         }
                
               }
           }).resume()
       }
      func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
                   
                //  let userLocation :CLLocation = locations[0] as CLLocation
//
//                   print("user latitude = \(userLocation.coordinate.latitude)")
//                   print("user longitude = \(userLocation.coordinate.longitude)")
               //  strCurrentLocation = "\(userLocation.coordinate.latitude)" + "," + "\(userLocation.coordinate.longitude)"
                 
        let userCurrentLocation    = self.strCurrentLocation
        let location = userCurrentLocation.components(separatedBy: ",")
        print(location)
        
        let latUserBookingTime    = location[0]
        let longUserBookingTime = location[1]
        print(latUserBookingTime)
        print(longUserBookingTime)
                
        
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: Double(latUserBookingTime)!, longitude: Double(longUserBookingTime)!, zoom: Float(10.0))
        self.viewMap.animate(to: camera)
                
               
        markerSoucres.position = CLLocationCoordinate2D(latitude: Double(latUserBookingTime)!, longitude: Double(longUserBookingTime)!)
       // self.markerSoucres.icon = UIImage(named: "Bike")
        markerSoucres.map = viewMap
                
    
                let dataDestination    = self.strDestination
                let destination = dataDestination.components(separatedBy: ",")
                print(destination)
                
                let latDes    = destination[0]
                let longDes = destination[1]
                print(latDes)
                print(longDes)

        markerDestination.position = CLLocationCoordinate2D(latitude: Double(latDes)!, longitude: Double(longDes)!)
       // markerDestination.icon = UIImage(named: "Car")
        markerDestination.map = viewMap
                //viewMap.selectedMarker = markerDestinatiom
                
                
                
                self.LoadMapRoute()
                self.locationManager.stopUpdatingLocation()

   
               }
               func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
                   print("Error \(error)")
               }
//    func playAnimation()
//    {
//        if iPosition <= 2 {
//            let position = self.stepCoords[iPosition]
//            self.marker?.position = position
//            viewMap.camera = GMSCameraPosition(target: position, zoom: 15, bearing: 0, viewingAngle: 0)
//            self.marker!.groundAnchor = CGPoint(x: CGFloat(0.5), y: CGFloat(0.5))
//
//            if iPosition != 2 {
//                self.marker!.rotation = CLLocationDegrees(exact)
//            }
//
//        }
//    }
    
    func checkRideStatus()
            {
              
                let para:[NSString:Any] = [
                    "booking_id":strBookingID,
                
                ]
                
                if Reachability.isConnectedToNetwork() {
//                    startLoader(view: self.view)
                    DataProvider.sharedInstance.postDataWithHeaderFieldwithPost(parameter: para as! [String : String], url: "get_data/check_status_after_accept_booking", { (json) in
                
                        print(json)
                        stopLoader()
                        if json["status"].stringValue == "Success" {
                             if json["data"].stringValue == "accepted" {
                                self.checkRideStatus()
                            }
                                if json["data"].stringValue == "completed"  {
                                let feed = self.storyboard?.instantiateViewController(withIdentifier: "FeedbackVC") as! FeedbackVC
                                    self.navigationController?.pushViewController(feed, animated: true)
                                      return
                                    }
                                    if json["data"].stringValue == "started" || json["data"].stringValue == "reached" {
                                        self.checkRideStatus()
                                    }
                            if json["data"].stringValue == "cancelled"  {
                                self.navigationController?.popViewController(animated: false)
                                return
                                                               }
                             
                            
                        }
                        else  {
                              Utility.showMessageDialog(onController: self, withTitle: NSLocalizedString("express", comment: ""), withMessage:json["Message"].stringValue)
                        }
                        
                    }
                        , errorBlock: { (error) in
                            print(error)
                           // stopLoader()
                    })
                    
                    
                }else{
                    Utility.showMessageDialog(onController: self, withTitle: "Alert", withMessage: NSLocalizedString("network_issue", comment: ""))
                }
                
            }
    

    func convertLatLongToAddress(latitude:Double,longitude:Double){
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in

            if (error != nil){
                print("error in reverseGeocode")
            }
            else {
            let placemark = placemarks! as [CLPlacemark]
            if placemark.count>0{
                let placemark = placemarks![0]
                print(placemark.name!)
            //  print(placemark.subLocality!)
               // print(placemark.administrativeArea!)
                print(placemark.country!)
                
                self.strDriverLocation = "\(placemark.name!), \(placemark.country!)"
                self.labelUserVehicleLocation.text = self.strDriverLocation
             
                }
              
            }

//            // Place details
//            var placeMark: CLPlacemark!
//            placeMark = placemarks?[0]
//
//            // Location name
//            if let locationName = placeMark.location {
//               print("_______\(locationName)")
//            }
//            // Street address
//            if let street = placeMark.thoroughfare {
//                print("+++++++++\(street)")
//                self.DriverCurrentAddress = "\(street)"
//            }
//            // City
//            if let city = placeMark.subAdministrativeArea {
//                print("*********\(city)")
//              //  self.DriverCurrentAddress = self.DriverCurrentAddress + " " + "\(city)"
//            }
//            // Zip code
//            if let zip = placeMark.isoCountryCode {
//                print("&&&&&&&&&\(zip)")
//            }
//            // Country
//            if let country = placeMark.country {
//                print(country)
//            }
            
        })

    }
    func getDriverLocation() {
      
        Database.database().reference().child("Location").child("19").observe(.value, with: { snapshot in
              // This is the snapshot of the data at the moment in the Firebase database
              // To get value from the snapshot, we user snapshot.value
              print(snapshot.value! as Any)
            
            print("&&&&&&&&&&&&&&&&&&&&&")
            
            let dicFireBase = snapshot.value as? NSDictionary
            let lat = dicFireBase?["lat"] as? String ?? "0.0"
            let long = dicFireBase?["long"] as? String ?? "0.0"
            self.markerSoucres.position = CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(long)!)
           // self.markerSoucres.icon = UIImage(named: "Car")
            self.markerSoucres.map = self.viewMap
            
            })
            }
    
}
