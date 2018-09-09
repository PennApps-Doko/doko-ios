//
//  PhotosController.swift
//  doko
//
//  Created by Emily on 9/8/18.
//  Copyright © 2018 Emily. All rights reserved.
//

import Foundation
import UIKit

class PhotosController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var data: [Spot] = []

    //??

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        getPostsByLocation(lat: -75.19211, lon: 39.953321) { posts in
            self.data = []
            print(posts)
            print(posts[0].spotId)
            posts.forEach({ post in
                getSpotById(id: post.spotId) { spot in
                    self.data.append(spot)
                    self.tableView.reloadData()
                }
            })
            
        }
        
        let cellReuseIdentifier = "cell";
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier);
        tableView.delegate = self;
        tableView.dataSource = self;
        
    
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count;
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PhotoCell = self.tableView.dequeueReusableCell(withIdentifier: "PhotoCell") as! PhotoCell
        
        cell.username.text = self.data[indexPath.row].name;
        cell.profile_img.image = #imageLiteral(resourceName: "temp")
        cell.geolocation.text = self.data[indexPath.row].id
        cell.liked_img.image = #imageLiteral(resourceName: "temp")
        cell.likes.text = "Yunno"
        cell.time_liked.text = "Liked two days ago"
        
        return cell;
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        performSegue(withIdentifier: "photo_store", sender: cell)
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
