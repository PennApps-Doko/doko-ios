//
//  ListController.swift
//  doko
//
//  Created by Emily on 9/8/18.
//  Copyright © 2018 Emily. All rights reserved.
//

import Foundation
import UIKit
import StitchCore

class ListController: UIViewController {
    
    private lazy var stitchClient = Stitch.defaultAppClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let client = Stitch.defaultAppClient!
        
        print("logging in anonymously")
        client.auth.login(withCredential: AnonymousCredential()) { result in
            switch result {
            case .success(let user):
                print("logged in anonymous as user \(user.id)")
                DispatchQueue.main.async {
                    // update UI accordingly
                }
            case .failure(let error):
                print("Failed to log in: \(error)")
            }
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

