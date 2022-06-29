//
//  LocationModel.swift
//  ExpressAssist
//
//  Created by samar on 04/05/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

class LocationModel {
    var latitute:String?
    var longtitue:String?
    var bookingID:String?
    var driverID:String?
    var timeStamp:Any
    init(latitute:String,longtitue:String,bookingID:String,driverID:String,timeStamp:Any) {
        self.latitute = latitute
        self.longtitue = longtitue
        self.bookingID = bookingID
        self.driverID = driverID
        self.timeStamp = timeStamp
    }
    
}
