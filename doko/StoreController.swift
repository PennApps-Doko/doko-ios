//
//  StoreController.swift
//  doko
//
//  Created by Emily on 9/8/18.
//  Copyright © 2018 Emily. All rights reserved.
//

import Foundation
import UIKit

class StoreController: UIViewController {
    
    var passed_name: String!
    var passed_desc: String!
    var passed_color: String!
    var passed_tags = [String]()
    
    @IBOutlet var background_img: UIImageView!
    @IBOutlet var store_name: UILabel!
    @IBOutlet var desc: UITextView!
    @IBOutlet var tags: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        store_name.text = passed_name
        desc.text = passed_desc
        tags.text = passed_tags.joined(separator: " ")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

class StoreCell: UITableViewCell {
}

