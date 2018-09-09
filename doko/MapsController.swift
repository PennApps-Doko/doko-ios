//
//  MapsController.swift
//  doko
//
//  Created by Emily on 9/8/18.
//  Copyright © 2018 Emily. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class MapsController: UIViewController, CLLocationManagerDelegate,MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource
 {
    
    @IBOutlet var tableView: UITableView!
    
    var data = ["one", "two", "three"]
    var resturant_names: [String] = []
    
//    var initialLocation = CLLocation(latitude: 51.5001524, longitude: -0.1262362)
    let regionRadius: CLLocationDistance = 1000
//    var locationManager: CLLocationManager!
    let locationManager = CLLocationManager()

    
    func centerMapOnLocation(location:CLLocation) {
        let coordianteRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        map.setRegion(coordianteRegion, animated: true)
    }
    
    @IBOutlet var map: MKMapView!

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        map.mapType = MKMapType.standard
        
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: locValue, span: span)
        map.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = locValue
        map.addAnnotation(annotation)
        
        //centerMap(locValue)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellReuseIdentifier = "cell";
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier);
        tableView.delegate = self;
        tableView.dataSource = self;
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        map.delegate = self
        map.mapType = .standard
        map.isZoomEnabled = true
        map.isScrollEnabled = true
        
        if let coor = map.userLocation.location?.coordinate{
            map.setCenter(coor, animated: true)
        }
        
        map.userTrackingMode = .follow
        
        // flipped
        let lat = 39.95
        let lon = -75.192
        
        getPostsByLocation(lat: 39.95, lon: -75.192, { result in
            var res: [Post] = result
            for post in res {
                let dist = Float(post.distance)
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: lon, longitude: lat)
                
                if dist < 200 {
                    print("green")
                    self.map.addAnnotation(annotation)
                }
                else if (dist < 500) {
                    print("yellow")
                    self.map.addAnnotation(annotation)
                }
                else {
                    print("red")
                    self.map.addAnnotation(annotation)
                }
                getSpotById(id: post.id, { result2 in
                    print(result2)
                    self.updateList(resturant_name: result2.name)
                    print("--------------")
                })
            }
        })
    }
    
    func updateList(resturant_name: String) {
        resturant_names.append(resturant_name)
        tableView.reloadData()
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resturant_names.count;
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MapCell = self.tableView.dequeueReusableCell(withIdentifier: "MapCell") as! MapCell
        
        cell.store.text = resturant_names[indexPath.row];
        cell.store_image.image = #imageLiteral(resourceName: "temp")
        
        return cell;
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        performSegue(withIdentifier: "map_store", sender: cell)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

class MapCell: UITableViewCell {
    @IBOutlet var store: UILabel!
    @IBOutlet var store_image: UIImageView!
}

