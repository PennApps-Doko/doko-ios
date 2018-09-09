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
    var url: String! // for the image
    var source: String! // compnany url
    
    @IBOutlet var background_img: UIImageView!
    @IBOutlet var store_name: UILabel!
    @IBOutlet var desc: UITextView!
    @IBOutlet var tags: UILabel!
    
    @IBAction func maps(_ sender: Any) {
        openMapForPlace(lat: lat, lon: lon)
    }
    
    @IBAction func visit_source(_ sender: Any) {
        guard let url = URL(string: source) else { return }
        UIApplication.shared.open(url)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        store_name.text = passed_name
        desc.text = passed_desc
        tags.text = "tags: " + passed_tags.joined(separator: " ")
        
        if let url = URL(string: url) {
            background_img.contentMode = .scaleAspectFit
            downloadImage(from: url)
            print(url)
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.background_img.image = UIImage(data: data)
            }
        }
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

