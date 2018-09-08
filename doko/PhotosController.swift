//
//  PhotosController.swift
//  doko
//
//  Created by Emily on 9/8/18.
//  Copyright © 2018 Emily. All rights reserved.
//

import Foundation
import UIKit

class PhotosController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

class PhotoCell: UITableViewCell {
    @IBOutlet var profile_img: UIImageView!
    @IBOutlet var username: UILabel!
    @IBOutlet var geolocation: UILabel!
    @IBOutlet var liked_img: UIImageView!
    @IBOutlet var likes: UILabel!
    @IBOutlet var time_liked: UILabel!
}
