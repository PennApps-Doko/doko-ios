//
//  ListController.swift
//  doko
//
//  Created by Emily on 9/8/18.
//  Copyright © 2018 Emily. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class ListController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        getSpotById(id: "1ff3d599-02fc-ac3c-28ea-10fcdd93ea83") { spot in
            print(spot)
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

class A_Cell: UITableViewCell {
}

class B_Cell: UITableViewCell {
}

class C_Cell: UITableViewCell {
}

