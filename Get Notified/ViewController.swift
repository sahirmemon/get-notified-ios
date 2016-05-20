//
//  ViewController.swift
//  Get Notified
//
//  Created by Sahir Memon on 5/19/16.
//  Copyright © 2016 Sahir Memon. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

let radius = 10.0
let mapViewIdentifier = "MapViewIdentifier"
let annotationIdentifier = "AnnotationIdentifier"

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    // MARK:
    // MARK: View Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up CoreLocation
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        // Load the map with our annotation
        loadLocation()
        
    }
    
    func loadLocation() {
        let coordinate = CLLocationCoordinate2D(latitude: 33.777518, longitude: -84.389655)
       
        // Drop an annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Destination"
        annotation.subtitle = "75 5th Street"
        mapView?.addAnnotation(annotation)
        
        // Add a radius over the pin
        addRadiusOverlayForLocation(annotation)
        
        // Move the map to the destination point
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        mapView.setRegion(region, animated: true)
    
        // Start monitoring for geofencing
        if !CLLocationManager.isMonitoringAvailableForClass(CLCircularRegion){
            presentAlertWithTitle("Oh no!", message: "Looks like GeoFencing is not supported on this device :(", viewController: self)
            return
        }
        
        if CLLocationManager.authorizationStatus() != .AuthorizedAlways {
            presentAlertWithTitle("Whoops!", message: "We have not received your permission yet to access the device location :(", viewController: self)
        }
        
        let annotationRegion = regionWithAnnotation(annotation)
        locationManager.startMonitoringForRegion(annotationRegion)
        
    }
    
    // MARK:
    // MARK: Geofencing
    func regionWithAnnotation(annotation: MKAnnotation) -> CLCircularRegion {
        let region = CLCircularRegion(center: annotation.coordinate, radius: radius, identifier: annotationIdentifier)
        region.notifyOnEntry = true
        region.notifyOnExit = true
        return region
    }
    
    func stopMonitoringannotation(annotation: MKAnnotation) {
        for region in locationManager.monitoredRegions {
            if let circularRegion = region as? CLCircularRegion {
                if circularRegion.identifier == annotationIdentifier {
                    locationManager.stopMonitoringForRegion(circularRegion)
                }
            }
        }
    }
    
    
    // MARK:
    // MARK: MKMapViewDelegate
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = mapViewIdentifier
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = false
        }
        return nil
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circleRenderer = MKCircleRenderer(overlay: overlay)
            circleRenderer.lineWidth = 1.0
            circleRenderer.strokeColor = UIColor.redColor()
            circleRenderer.fillColor = UIColor.redColor().colorWithAlphaComponent(0.3)
            return circleRenderer
        }
        return MKPolylineRenderer()
    }
    
    
    // MARK:
    // MARK: Map Overlay
    
    func addRadiusOverlayForLocation(annotation: MKAnnotation) {
        mapView?.addOverlay(MKCircle(centerCoordinate: annotation.coordinate, radius: radius))
    }
    
    // MARK:
    // MARK: CLLocationManager Delegate
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        mapView.showsUserLocation = (status == .AuthorizedAlways)
    }
    
    func locationManager(manager: CLLocationManager, monitoringDidFailForRegion region: CLRegion?, withError error: NSError) {
        print("Monitoring failed for region with identifier: \(region!.identifier)")
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Location Manager failed with the following error: \(error)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

