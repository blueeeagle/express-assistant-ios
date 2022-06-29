//
//  OrderVC.swift
//  ExpressAssist
//
//  Created by Apple on 29/08/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
class MyOrderCell: UITableViewCell
{
  
    @IBOutlet weak var labelOrderID: UILabel!
    @IBOutlet weak var btnSeeDeatils: UIButton!
    
}
class OrderVC: UIViewController, UITableViewDelegate,UITableViewDataSource,UITextViewDelegate {

    @IBOutlet weak var labelMyOrder: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    //MARK: Table delegate and datasources method
              
           
              
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
              {
                
                  return 4
                
                  
              }
              
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
              {
              
                     let cell : MyOrderCell? = tableView.dequeueReusableCell(withIdentifier: "cellOrder") as? MyOrderCell

    //
                  return cell!
                
              }

              func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
              
                return 120
                
              }


}
