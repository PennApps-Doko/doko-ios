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
    var resturant_color: [UIColor] = []
    var resturant_desc: [String] = []
    var resturant_tags: [[String]] = []
    var lats: [Float] = []
    var lons: [Float] = []
    var img_url: [String] = []
    var company_url: [String] = []
    
//    var initialLocation = CLLocation(latitude: 51.5001524, longitude: -0.1262362)
    let regionRadius: CLLocationDistance = 4000
//    var locationManager: CLLocationManager!
    let locationManager = CLLocationManager()

    
    func centerMapOnLocation(location:CLLocation) {
        let coordianteRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 200.0, regionRadius * 200.0)
        map.setRegion(coordianteRegion, animated: true)
    }
    
    @IBOutlet var map: MKMapView!

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        map.mapType = MKMapType.standard
        
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: locValue, span: span)
        map.setRegion(region, animated: true)
        
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = locValue
//        map.addAnnotation(annotation)
        
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
        
        // blue dot
        if let coor = map.userLocation.location?.coordinate{
            map.setCenter(coor, animated: true)
        }
        map.userTrackingMode = .follow
        
        // custom point
        // flipped
        let lat = 39.95
        let lon = -75.192
        
        let annotation2 = MKPointAnnotation()
        annotation2.title = "White Dog Cafe"
        annotation2.coordinate = CLLocationCoordinate2D(latitude: 39.9535910, longitude: -75.19291)
        map.addAnnotation(annotation2)
        
        let annotation3 = MKPointAnnotation()
        annotation3.title = "Shake Shack"
        annotation3.coordinate = CLLocationCoordinate2D(latitude: 39.953953062438224, longitude: -75.18858019863558)
        map.addAnnotation(annotation3)
        
        let annotation4 = MKPointAnnotation()
        annotation4.title = "Starbucks"
        annotation4.coordinate = CLLocationCoordinate2D(latitude: 39.952976545573826, longitude: -75.1920680655571)
        map.addAnnotation(annotation4)
        
        let annotation5 = MKPointAnnotation()
        annotation5.title = "Accenture Cafe"
        annotation5.coordinate = CLLocationCoordinate2D(latitude: 39.95217294000004, longitude: -75.191655)
        map.addAnnotation(annotation5)
        
        let annotation6 = MKPointAnnotation()
        annotation6.title = "Towne Building"
        annotation6.coordinate = CLLocationCoordinate2D(latitude: 39.951562841944174, longitude: -75.1913309090729)
        map.addAnnotation(annotation6)
        
        
        getPostsByLocation(lat: 39.9522, lon: 75.1932, { result in
            var res: [Post] = result
            for post in res {
//                let dist = Float(post.distance)
                print(post.location[0])
                print(post.location[1])
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: lon, longitude: lat)
                var dist = CLLocation(latitude: 39.9522, longitude: 75.1932).distance(from: CLLocation(latitude: post.location[0], longitude: post.location[1]))
                print(dist)
                
                var text_color: UIColor!
                if dist < 200 {
                    print("green")
                    text_color = UIColor.green
                    self.map.addAnnotation(annotation)
                }
                else if (dist < 500) {
                    print("yellow")
                    text_color = UIColor.orange
                    self.map.addAnnotation(annotation)
                }
                else {
                    print("red")
                    text_color = UIColor.red
                    self.map.addAnnotation(annotation)
                }
                getSpotById(id: post.id, { result2 in
                    print(result2)
                    self.updateList(resturant_name: result2.name, color: self.getTextColor(dist: Int(dist)), desc: result2.restaurant.description, tags: result2.restaurant.tags, lat: Float(result2.location[0]), lon: Float(result2.location[1]), url: result2.postContent.images[0], url_2: result2.postContent.url)
                    print("--------------")
                })
            }
        })
    }
    
    func getTextColor(dist: Int) -> UIColor{
        var text_color: UIColor!
        if dist < 200 {
            print("green")
            text_color = UIColor.green
//            self.map.addAnnotation(annotation)
        }
        else if (dist < 500) {
            print("yellow")
            text_color = UIColor.orange
//            self.map.addAnnotation(annotation)
        }
        else {
            print("red")
            text_color = UIColor.red
//            self.map.addAnnotation(annotation)
        }
        return text_color
    }
    
    func updateList(resturant_name: String, color: UIColor, desc: String, tags: [String], lat: Float, lon: Float, url: String, url_2: String) {
        resturant_names.append(resturant_name)
        resturant_color.append(color)
        resturant_desc.append(desc)
        resturant_tags.append(tags)
        lats.append(lat)
        lons.append(lon)
        img_url.append(url)
        company_url.append(url_2)
        tableView.reloadData()
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resturant_names.count;
    }
    
    // create a cell for each table view row
    var dataToPass = [Any]()
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MapCell = self.tableView.dequeueReusableCell(withIdentifier: "MapCell") as! MapCell
        
        cell.store.text = resturant_names[indexPath.row];
        cell.store.textColor = resturant_color[indexPath.row]
        cell.store_image.image = #imageLiteral(resourceName: "temp")
        
        return cell;
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        dataToPass = [resturant_names[indexPath.row],
                      resturant_desc[indexPath.row],
                      resturant_tags[indexPath.row],
                      lats[indexPath.row],
                      lons[indexPath.row],
                      img_url[indexPath.row],
                      company_url[indexPath.row]]
        performSegue(withIdentifier: "map_store", sender: cell)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "map_store" {
            if let destinationVC = segue.destination as? StoreController {
                destinationVC.passed_name = dataToPass[0] as! String
                destinationVC.passed_desc = dataToPass[1] as! String
                destinationVC.passed_tags = dataToPass[2] as! [String]
                destinationVC.lat = dataToPass[3] as! Float
                destinationVC.lon = dataToPass[4] as! Float
                destinationVC.url = dataToPass[5] as! String
                destinationVC.source = dataToPass[6] as! String
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
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

