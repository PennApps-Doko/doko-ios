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

class ListController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private lazy var stitchClient = Stitch.defaultAppClient!
    
    var data = ["one", "two", "three"]
    
    @IBOutlet var tableView_200: UITableView!
    @IBOutlet var tableView_500: UITableView!
    @IBOutlet var tableView_1000: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let cellReuseIdentifier = "cell";
        self.tableView_200.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier);
        tableView_200.delegate = self;
        tableView_200.dataSource = self;
        
        self.tableView_500.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier);
        tableView_500.delegate = self;
        tableView_500.dataSource = self;
        
        self.tableView_1000.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier);
        tableView_1000.delegate = self;
        tableView_1000.dataSource = self;
        
        let client = Stitch.defaultAppClient!
        
        print("logging in anonymously")
        client.auth.login(withCredential: AnonymousCredential()) { result in
            switch result {
            case .success(let user):
                print("logged in anonymous as user \(user.id)")
                DispatchQueue.main.async {
                    // update UI accordingly
                    
                    Stitch.defaultAppClient!.callFunction(withName: "getRecentPosts", withArgs: [1.0, 1.0]) { result in
                        switch result {
                        case .success(let stringResult):
                            print("String result: \(stringResult)")
                        case .failure(let error):
                            print("Error retrieving String: \(String(describing: error))")
                        }
                    }
                    
                }
            case .failure(let error):
                print("Failed to log in: \(error)")
            }
        }
    }

    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(tableView) {
        case tableView_200:
            return data.count;
            break;
        case tableView_500:
            return data.count;
            break;
        default:
            return data.count;
        }

    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: A_Cell = tableView.dequeueReusableCell(withIdentifier: "A_Cell") as! A_Cell
        
//        switch(tableView) {
//        case tableView_200:
//            cell.store_name.text = "200";
//            cell.store_img.image = #imageLiteral(resourceName: "temp")
//            break;
//        case tableView_500:
//            cell.store_name.text = "500";
//            cell.store_img.image = #imageLiteral(resourceName: "temp")
//            break;
//        default:
            cell.store_name.text = "100+";
            cell.store_img.image = #imageLiteral(resourceName: "temp")
//        }

        return cell;
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.present(StoreController(), animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

class A_Cell: UITableViewCell {
    @IBOutlet var store_img: UIImageView!
    @IBOutlet var store_name: UILabel!
}

