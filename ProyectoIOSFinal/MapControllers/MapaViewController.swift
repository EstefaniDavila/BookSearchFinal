//
//  MapaViewController.swift
//  ProyectoIOSFinal
//
//  Created by Victor Mollocondo Asillo on 3/07/22.
//



import UIKit
import MapKit

struct Store {
    var name: String
    var lattitude: CLLocationDegrees
    var longtitude: CLLocationDegrees
}

class MapaViewController: UIViewController, CLLocationManagerDelegate {

    
    @IBOutlet weak var mapView: MKMapView!
    
    var ubicacion = CLLocationManager()
    var contActualizaciones = 0
    
    var libros: [Libros] = []
    
    let locationManager = CLLocationManager()
    let radius: CLLocationDistance = 6000
    let startingLocation = CLLocation(latitude: -16.40866, longitude: -71.53644)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ubicacion.delegate = self
        ubicacion.requestWhenInUseAuthorization()
        mapView.showsUserLocation = true
        
        libros = obtenerLibrerias()
        
        setStartingPosition()
        let stores = getStoreLocation()
        setAnnotation(stores: stores)
        
    }
    
    @IBAction func centrarTapped(_ sender: Any) {
        if let coord = ubicacion.location?.coordinate{
            let region = MKCoordinateRegion.init(center:
                coord, latitudinalMeters: 1000,
                longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
            contActualizaciones += 1
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        isLocationServiceEnabled()
    }
    
    func displayAlert(isServiceEnabled:Bool){
      
            let serviceEnableMessage = "Location services must to be enabled to use this awesome app feature. You can enable location services in your settings."
            let authorizationStatusMessage = "This awesome app needs authorization to do some cool stuff with the map"
            
            let message = isServiceEnabled ? serviceEnableMessage : authorizationStatusMessage
            
            let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
            
            //create ok button
            let acceptAction = UIAlertAction(title: "OK", style: .default)
            
            //add ok button to alert
            alert.addAction(acceptAction)
            self.present(alert, animated: true, completion: nil)
    }

    
    func checkAuthorizationStatus(){
            
            let status = CLLocationManager.authorizationStatus()
            if status == .authorizedAlways || status == .authorizedWhenInUse {
                mapView.showsUserLocation = true
            }
            else if status == .restricted || status == .denied {
                displayAlert(isServiceEnabled: false)
            }
            else if status == .notDetermined {
                locationManager.requestWhenInUseAuthorization()
                mapView.showsUserLocation = true
            }
    }
    
    
    func isLocationServiceEnabled(){
        if CLLocationManager.locationServicesEnabled(){
            checkAuthorizationStatus()
        }
        else{
            displayAlert(isServiceEnabled: true)
        }
    }
    
    func setStartingPosition(){
            
        let position =  MKCoordinateRegion(center: startingLocation.coordinate,
                                               latitudinalMeters: radius,
                                               longitudinalMeters: radius)
        
        mapView.setRegion(position, animated: true)
    }
    
    
    func getStoreLocation() -> [Store]{
            return [
                Store(name: "San Francisco", lattitude: -16.39583, longtitude: -71.53389),
                Store(name: "Melga", lattitude: -16.39579, longtitude: -71.53389),
                Store(name: "Rivero", lattitude: -16.39878, longtitude: -71.53390),
                Store(name: "Palacio Viejo", lattitude: -16.40115, longtitude: -71.53605),
                Store(name: "Tristan", lattitude: -16.40246, longtitude: -71.53806),
                Store(name: "Tacna", lattitude: -16.39660, longtitude: -122.405990),
                Store(name: "Don Bosco", lattitude: -16.39750, longtitude: -71.52736),
                Store(name: "Santa Rosa", lattitude: -16.39904, longtitude: -71.52964)
            ]
        }
    
    func setAnnotation(stores:[Store]){
            
            for store in stores {
                let annotation = MKPointAnnotation()
                annotation.title = store.name
                
                
                annotation.coordinate = CLLocationCoordinate2D(latitude:store.lattitude,
                                                             longitude: store.longtitude)
                mapView.addAnnotation(annotation)
            }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations
        locations: [CLLocation]) {
        if contActualizaciones<1{
            let region = MKCoordinateRegion.init(center:
                ubicacion.location!.coordinate, latitudinalMeters: 1000,
                longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
            contActualizaciones += 1
        }else{
            ubicacion.stopUpdatingLocation()
        }
        //print("Ubicacion actualizada")
            
    }
    
}
