//
//  ViewController.swift
//  Assignment-5
//
//  Created by TIANDA LIU on 2/12/20.
//  Copyright © 2020 TIANDA LIU. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    @IBOutlet var mapView: MKMapView! {
        didSet {mapView.delegate = self}
    }
    @IBOutlet var infoView: UIView!
    @IBOutlet var placeTitle: UILabel!
    @IBOutlet var placeDescription: UILabel!
    @IBOutlet var starButton: UIButton!
    
    @IBOutlet var favButton: UIButton!
    
    let dataManager = DataManager.sharedInstance
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // mapView properties
        mapView.showsCompass = false
        mapView.pointOfInterestFilter = .excludingAll
        
        // location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        self.askPermissions()
        
        
        // load data from Data.plist
        dataManager.loadAnnotationFromPlist()
        for location in dataManager.places.values {
            location.title = location.name
            mapView.addAnnotation(location)
            
            // add region
            let region = CLCircularRegion(center: location.coordinate, radius: 500, identifier: location.name!)
            region.notifyOnEntry = true
            region.notifyOnExit = true
            locationManager.startMonitoring(for: region)
        }
        
        // initial place
        let zoomLocation = CLLocationCoordinate2DMake(dataManager.initRegion[0],dataManager.initRegion[1])
        let span = MKCoordinateSpan.init(latitudeDelta: dataManager.initRegion[2], longitudeDelta: dataManager.initRegion[3])
        let viewRegion = MKCoordinateRegion(center: zoomLocation, span: span)
        mapView.setRegion(viewRegion, animated: true)
        
        // do not display the info view at begin
        infoView.alpha = 0
        
        // add listener to starButton
        self.starButton.addTarget(self, action: #selector(handleStartaped(_:)), for: .touchUpInside)
        self.starButton.tintColor = UIColor.orange
        
    }
    
    @objc func handleStartaped(_ button: UIButton) {
        if button.isSelected == false{
            button.isSelected = true
            if let name = self.placeTitle.text {
                dataManager.saveFavorites(name)
            }
        } else {
            button.isSelected = false
            if let name = self.placeTitle.text {
                dataManager.deleteFavorite(name)
            }
        }
    }
    
    func askPermissions() {
        let authStatus: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        
        switch authStatus {
        case .notDetermined, .denied, .restricted:
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
            return
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            return
        default:
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
            return
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? FavoritesViewController {
            destination.delegate = self
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? Place {
            let identifier = "Place"
            var view: PlaceMarkerView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? PlaceMarkerView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = PlaceMarkerView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = false
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .infoLight)
            }
            return view
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let favList = UserDefaults.standard.object(forKey: "FavList") as! [String]
        if let annotation = view.annotation as? Place {
            self.infoView.alpha = 0.8
            self.placeTitle.text = annotation.name
            self.placeDescription.text = annotation.longDescription
            if favList.contains(annotation.name!) {
                self.starButton.isSelected = true
            } else {
                self.starButton.isSelected = false
            }
        }
    }
}

extension MapViewController: PlacesFavoritesDelegate {
    func favoritePlace(name: String) {
        let place = dataManager.places[name]
        let coordinate = CLLocationCoordinate2D(latitude: place!.lat!, longitude: place!.long!)
        let span = MKCoordinateSpan.init(latitudeDelta: dataManager.initRegion[2], longitudeDelta: dataManager.initRegion[3])
        let viewRegion = MKCoordinateRegion(center: coordinate, span: span)
        self.mapView.setRegion(viewRegion, animated: true)
        //let annotation = dataManager.places[name]
        //show annotation ciew
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        default:
            manager.requestWhenInUseAuthorization()
        }
    }

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Enter region!")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Exit region!")
    }

    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion){
        if state == CLRegionState.inside {
            print("Entering...")
            let alert = UIAlertController(title: "Close to Interest Point", message: region.identifier, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        
    }
}
