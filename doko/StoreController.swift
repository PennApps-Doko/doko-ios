//
//  StoreController.swift
//  doko
//
//  Created by Emily on 9/8/18.
//  Copyright © 2018 Emily. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class StoreController: UIViewController {
    
    var passed_name: String!
    var passed_desc: String!
    var passed_color: String!
    var passed_tags = [String]()
    var lat: Float!
    var lon: Float!
    
    @IBOutlet var background_img: UIImageView!
    @IBOutlet var store_name: UILabel!
    @IBOutlet var desc: UITextView!
    @IBOutlet var tags: UILabel!
    
    @IBAction func maps(_ sender: Any) {
        openMapForPlace(lat: lat, lon: lon)
    }
    
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
    
    func openMapForPlace(lat: Float, lon: Float) {
        
        let latitude: CLLocationDegrees = CLLocationDegrees(lat)
        let longitude: CLLocationDegrees = CLLocationDegrees(lon)
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = passed_name
        mapItem.openInMaps(launchOptions: options)
    }
    
}

class StoreCell: UITableViewCell {
}

