//
//  MapBarController.swift
//  Coronavirus tracker
//
//  Created by Tymoteusz Pasieka on 01/03/2020.
//  Copyright © 2020 Tymoteusz Pasieka. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class MapBarController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var typeOfMapSControl: UISegmentedControl!
    
    @IBOutlet weak var addFacilityButton: RoundedButton!
   
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    var mapBrain = MapBrain()
    
    var regionInMeters: Double {
        if typeOfMapSControl.selectedSegmentIndex == 0 {
             return 9000000
        } else {
             return 10000
        }
    
       
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMapBrain()
        mapView.delegate = self
       
        typeOfMapSControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
       
        
        //checkLocationServices()
        // Do any additional setup after loading the view.
    }
    
    func configureMapBrain() {
        if let tabBar = tabBarController as? CoronaTabBarController {
            mapBrain.tabBar = tabBar
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        checkLocationServices()
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func checkLocationAuthorization() {
       switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
           //locationManager.startUpdatingLocation()
        
            updateUIForSControl(typeOfMapSControl.selectedSegmentIndex)
            break
        case .denied:
            //show alert how to turn on permission
            break
        case .notDetermined:
    
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            //show alert whatsup
            break
        case .authorizedAlways:
            break
            
        @unknown default:
            print("error")
            break
        }
    }

    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            //alert, no location enabled
        }
    }
    
    
    
    func addAnnotationsForPoi() {
        mapView.removeAnnotations(mapView.annotations)
        if let tabBar = tabBarController as? CoronaTabBarController {
            let poiLocations = tabBar.statisticsBrain.healthPoi
            for location in poiLocations {
                if location.confirmed {
                    let pin = CustomPinAnnotation(type: .HealthPoi, of: 1, for: location.key)
                    pin.title = "\(location.name)"
                    pin.coordinate = CLLocationCoordinate2D(latitude: Double(truncating: location.coordinates.lat) ?? 3.21, longitude: Double(truncating: location.coordinates.long)  ?? 3.12)
                                   mapView.addAnnotation(pin)
                }
               
            }
            
        }
    }
    
    
    
    
    
    func updateUIForSControl(_ index: Int) {
        if index == 0 {
            addFacilityButton.isHidden = true
            mapView.removeAnnotations(mapView.annotations)
            if let confirmedAnnotations = mapBrain.addAnnotationForStats(statisticType: .Confirmed) {
                mapView.addAnnotations(confirmedAnnotations)
            }
            readGesture(false)
            addFacilityButton.isEnabled = false
            addFacilityButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        } else {
            print("healthFacility")
            addFacilityButton.isEnabled = true
            addFacilityButton.isHidden = false
            mapView.removeAnnotations(mapView.annotations)
            addAnnotationsForPoi()
            addFacilityButton.backgroundColor = #colorLiteral(red: 0.6513178945, green: 0.01196665503, blue: 0.185541451, alpha: 1)
        }
        centerViewOnUserLocation()
    }
    
    

    @IBAction func typeOfMapSCTapped(_ sender: UISegmentedControl) {
       updateUIForSControl(sender.selectedSegmentIndex)
    }
    
    @IBAction func addFacilityButtonTapped(_ sender: RoundedButton) {
        sender.isEnabled = false
        sender.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        readGesture(true)
    }
    
}















//MARK: - Adding& Removing PoiByTouch

extension MapBarController {
    
    func createYesNoPopUpToReportPoi (for key: String) {
        //1. Create the alert controller.
        let alert = UIAlertController(title: NSLocalizedString("Report false facility", comment: "Report false facility"), message: NSLocalizedString("Do you want to report a wrong facility?", comment: "Do you want to report a wrong facility?"), preferredStyle: .alert)

     


        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: NSLocalizedString("Report", comment: "Report"), style: .default, handler: {  (_) in
          //remove
            if let tabBar = self.tabBarController as? CoronaTabBarController {
                tabBar.firebaseManager.reportAFacility(for: key)
                tabBar.statisticsBrain.removePoi(for: key)
                self.addFacilityButton.isEnabled = true
                self.addFacilityButton.backgroundColor = #colorLiteral(red: 0.6513178945, green: 0.01196665503, blue: 0.185541451, alpha: 1)
                self.addAnnotationsForPoi()
            
            }
            
            
          
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .default, handler: { [weak alert] (_) in
            
            self.addFacilityButton.isEnabled = true
             self.addFacilityButton.backgroundColor = #colorLiteral(red: 0.6513178945, green: 0.01196665503, blue: 0.185541451, alpha: 1)
            alert?.dismiss(animated: true, completion: nil)
          
        }))

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    func createPopupWithInput(location: CLLocationCoordinate2D) {
        //1. Create the alert controller.
        let alert = UIAlertController(title: NSLocalizedString("Create health facility.", comment: "Create health facility."), message: NSLocalizedString("Add facility where patients can get help.", comment: "Add facility where patients can get help."), preferredStyle: .alert)

        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = NSLocalizedString("Enter facility name", comment: "Enter facility name")
        }

        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: NSLocalizedString("Confirm", comment: "Confirm"), style: .default, handler: { [weak alert] (_) in
            let textFieldText = alert?.textFields![0].text! // Force unwrapping because we know it exists.
            self.addFacilityAnnotationToFirebase(location: location, name: textFieldText!)
            self.addFacilityButton.isEnabled = true
             self.addFacilityButton.backgroundColor = #colorLiteral(red: 0.6513178945, green: 0.01196665503, blue: 0.185541451, alpha: 1)
          
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .default, handler: { [weak alert] (_) in
            alert?.dismiss(animated: true, completion: nil)
            self.addFacilityButton.isEnabled = true
             self.addFacilityButton.backgroundColor = #colorLiteral(red: 0.6513178945, green: 0.01196665503, blue: 0.185541451, alpha: 1)
          
        }))

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    func readGesture(_ start: Bool) {
        if start {
            let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
                  mapView.addGestureRecognizer(longTapGesture)
        } else {
            print("stop read gestures")
           if let longTapGestures = mapView.gestureRecognizers {
                for gesture in longTapGestures {
                   if let recognizer = gesture as? UILongPressGestureRecognizer {
                        mapView.removeGestureRecognizer(recognizer)
                   }
                }
            }
        }
      
    }

    
    @objc func longTap(sender: UIGestureRecognizer){
        print("long tap")
        if sender.state == .began {
            let locationInView = sender.location(in: mapView)
            let locationOnMap = mapView.convert(locationInView, toCoordinateFrom: mapView)
            //let pins = mapView.annotations
            createPopupWithInput(location: locationOnMap)
    
        }
    }
    
    
    
    func addFacilityAnnotationToFirebase(location: CLLocationCoordinate2D, name: String){
        
            if let tabBar = tabBarController as? CoronaTabBarController {
            let facility = HospitalFacility(poiName: name, coor: PoiCoordinates(lat: NSNumber(value: location.latitude), long: NSNumber(value: location.longitude)), conf: true, keyValue: "unknown")
                print("add facility before key")
                tabBar.firebaseManager.createPoiForHospital(for: facility.dictionary)
        }
        readGesture(false)
    }
}



//MARK: - LocationManagerDelegate


extension MapBarController: CLLocationManagerDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationView")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier:  "AnnotationView")
        } else {
            annotationView?.annotation = annotation
        }
        
        
        
        if let pin = annotationView?.annotation as? CustomPinAnnotation {
            print(pin.coordinate.latitude)
            print("image: \(pin.imageName)")
           annotationView?.image = UIImage(named: pin.imageName)
          
        }
        annotationView?.canShowCallout = true
        
        
        return annotationView
    }
    
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let pin = view.annotation as? CustomPinAnnotation, pin.dataType == .HealthPoi  {
            if !addFacilityButton.isEnabled {
                if let isKeyForFirebase = pin.keyForFirebase {
                    createYesNoPopUpToReportPoi(for: isKeyForFirebase)
                    print("want to remove")
                }
    
            }
            
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else {return}
//        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
//        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}
