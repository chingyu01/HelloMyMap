//
//  ViewController.swift
//  HelloMyMap
//
//  Created by 蔡家文 on 2018/1/24.
//  Copyright © 2018年 appNumber. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit



class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    let locationManager = CLLocationManager()
    

    @IBOutlet weak var mainMapView: MKMapView!
    @IBAction func mapTypeChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            mainMapView.mapType = .standard
        case 1:
            mainMapView.mapType = .satellite
        case 2:
            mainMapView.mapType = .hybrid
        case 3:
            mainMapView.mapType = .satelliteFlyover
            
            let coordinate = CLLocationCoordinate2DMake(35.710063,139.8107)
            let camera = MKMapCamera(lookingAtCenter: coordinate, fromDistance: 800, pitch: 65, heading: 0)
        //            head: 0 , refers to head to North
            
            
        default:
            mainMapView.mapType = .standard
        }
    }
    
    @IBAction func userTrackingModeChanged(_ sender: UISegmentedControl) {
    }
    
    
    //protocl Methods
    //MARK: - CLLocationManagerDelegate Methods.
    //FIXME: fix something ...
    //TODO: do something ...
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let coordinate = locations.last?.coordinate else {
            return
        }
        NSLog("Current Location: \(coordinate.latitude),\(coordinate.longitude)")
        
    }
    //    Mark:-MKMapViewDelegate Methods
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = mapView.region.center
        NSLog("Region be changed to : \(center.latitude),\(center.longitude)")
    }
    //    Mark:- MKMapViewDelegate Methods
//    extention ViewController:MKMapVeiwDelegate {
//    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//    let center = mapView.region.center
//    NSLog("Region be changed to : \(center.latitude),\(center.longitude)")
//
//
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //Ask user's permission.
        locationManager.requestAlwaysAuthorization()
        
        //Prepare locatioMangaer.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .automotiveNavigation
        locationManager.startUpdatingLocation()
        
        mainMapView.delegate = self
        
        //    Add Annotation
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let coordinate = locationManager.location?.coordinate else {
            NSLog("No current location")
            return
        }
//        prepare region
        
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
//  MKCoordinate span view refers to the view we can see ranges between latitude 0.001 and longtitude 0.001...if you want to see larger viewm you can revise the value converted to 0.01 0r larger...
        
        let region = MKCoordinateRegion (center:coordinate, span:span)
        //        region would improve to enlarge...
        
        mainMapView.setRegion(region, animated: true)
        
//        Got current region
//        let annotatinCoodinate:CLLocationCoordinate2D =
//        CLLocationCoordinate2DMake(25.123456, 121.123456)
//        let currentRegion = mainMapView.region
        
//        put on "KFC"
        var storeCoordinate = coordinate
        storeCoordinate.latitude += 0.001
        storeCoordinate.longitude += 0.001
        
        let annotation = MKPointAnnotation()
// MKPointAnnotation-->MKAnnotation就是懂日文的人要和mainMapView
        annotation.coordinate = storeCoordinate
        annotation.title = "肯德基"
        annotation.subtitle = "真好吃"
//        MainMapView就是日本人
        mainMapView.addAnnotation(annotation)
        
//        mainMapView can help us to adjust latitude and longtitude on variety of devices
//        animate is true, which means to enlarge with animation
    }
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation{
            return nil
        }
        let identifier = "store"
        var result = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        if result == nil{
            result = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
    }   else {
        result?.annotation = annotation
    }
      return result
}

    


    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

