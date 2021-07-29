//
//  MapViewController.swift
//  VirtualTourist
//
//  Created by Alhanouf Alawwad on 14/12/1442 AH.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, UIGestureRecognizerDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    var fetchedResultsController:NSFetchedResultsController<Pin>!
    
    // MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFetchedResultsController()
        setupMapView()
        
    }
    // MARK:- Setup Fetched Results Controller
    func setupFetchedResultsController() {
        
        let fetchRequest:NSFetchRequest<Pin> = Pin.fetchRequest()
        fetchRequest.sortDescriptors = []
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataController.shared.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
        
        
    }
    // MARK:- Setup Map View
    func setupMapView() {
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longTapped(_:)))
        mapView.addGestureRecognizer(gestureRecognizer)
        gestureRecognizer.delegate = self
        
        if let region = getMapRegion(){
            
            mapView.setRegion(region, animated: true)
            
        }
        if let pins = fetchedResultsController.fetchedObjects {
            createAnnotations(pins)
            
        }
        
        
        
        
    }
    // MARK:- Handle Long Tap Gesture
    @objc func longTapped(_ gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == .began{
            
            let location = gestureRecognizer.location(in:mapView)
            let coordinate = mapView.convert(location, toCoordinateFrom:mapView)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
            
            mapView.setCenter(mapView.centerCoordinate, animated: true)
            
            let pin = Pin(context: DataController.shared.viewContext)
            pin.latitude = coordinate.latitude
            pin.longitude = coordinate.longitude
            
            DataController.shared.saveViewContext()
            try? fetchedResultsController.performFetch()
        }
        
    }
    
    // MARK: - Map Region
    func setupMapRegion(region:MKCoordinateRegion?){
        if let region = region {
            let userRegion = ["latitude":region.center.latitude ,
                              "longitude":region.center.longitude,
                              "latitudeDelta":region.span.latitudeDelta,
                              "longitudeDelta":region.span.longitudeDelta]
            UserDefaults.standard.set(userRegion,forKey:"userRegion")
            
        }
        
    }
    func getMapRegion()->MKCoordinateRegion?{
        if let userRegion  =  UserDefaults.standard.dictionary(forKey: "userRegion"){
            let centerCoordinate = CLLocationCoordinate2D(latitude: userRegion ["latitude"] as! CLLocationDegrees ,longitude: userRegion["longitude"] as! CLLocationDegrees )
            let spanCoordinate = MKCoordinateSpan(latitudeDelta: userRegion ["latitudeDelta"] as! CLLocationDegrees , longitudeDelta: userRegion["longitudeDelta"] as! CLLocationDegrees )
            return MKCoordinateRegion(center: centerCoordinate, span: spanCoordinate)
            
        }
        else {
            return nil
        }
        
        
    }
    
    // MARK:- Map Annotations
    func createAnnotations(_ pins: [Pin]){
        var annotations = [MKAnnotation]()
        for pin in pins {
            
            let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(pin.latitude), longitude: CLLocationDegrees(pin.longitude))
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            
            annotations.append(annotation)
            
            
        }
        mapView.addAnnotations(annotations)
    }
    
}
extension MapViewController :MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.animatesDrop = true
            pinView!.pinTintColor = .red
            
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    func mapView(_ mapView: MKMapView, didSelect view:
                    MKAnnotationView) {
        
        let photoAlbumVC : PhotoAlbumViewController
        photoAlbumVC = storyboard?.instantiateViewController(withIdentifier: "PhotoAlbumVC") as! PhotoAlbumViewController
        
        
        if let pins = fetchedResultsController.fetchedObjects {
            for pin in pins {
                if pin.latitude == view.annotation?.coordinate.latitude && pin.longitude == view.annotation?.coordinate.longitude {
                    photoAlbumVC.pin = pin
                    
                    navigationController!.pushViewController(photoAlbumVC, animated: true)
                    
                }
            }
        }
    }
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        setupMapRegion(region: mapView.region)
    }
}

