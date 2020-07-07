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


class MapBarController: UIViewController  {
    
    @IBOutlet weak var typeOfMapSControl: UISegmentedControl!
    @IBOutlet weak var addFacilityButton: RoundedButton!
    @IBOutlet weak var mapView: MKMapView!
    
    private var statisticsListViewModels: StatiscsListViewModel?
    private var mapControllerViewModel: MapControllerViewModel?
    
    private let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        typeOfMapSControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        checkLocationServices()
    }
    
    private func addConfirmedCasesAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
        if let viewModel = mapControllerViewModel {
            let confirmedCasesAnnotations = viewModel.returnCustomPinAnnotationsForConfirmedCases()
            mapView.addAnnotations(confirmedCasesAnnotations)
        }
        
    }
    
    private func addHealthFacilitiesAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
        if let mapControllerViewModel = mapControllerViewModel {
            let annotations = mapControllerViewModel.returnCustomPinAnnotaitonsForHealthFacilities()
            
            print("annotations: \(annotations)")
            mapView.addAnnotations(annotations)
            mapView.reloadInputViews()
        }
    }
    
    
    private func updateUIForSControl(_ index: Int) {
        if index == 0 {
            updateUIForConfirmedCases()
        } else {
            updateUIForHealthFacilities()
        }
        
        centerViewOnUserLocation()
    }
    
    private func updateUIForConfirmedCases() {
        addFacilityButton.isHidden = true
        readGesture(false)
        addFacilityButton.isEnabled = false
        addFacilityButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        addConfirmedCasesAnnotations()
    }
    
    private func updateUIForHealthFacilities () {
        addFacilityButton.isEnabled = true
        addFacilityButton.isHidden = false
        addFacilityButton.backgroundColor = #colorLiteral(red: 0.6513178945, green: 0.01196665503, blue: 0.185541451, alpha: 1)
        
        FirebaseManager().fetchHealhFacilities(model: HealthFacility.self) { [weak self] (healthFacilities, error) in
            if let error = error {print("data may be incomplete with error \(error.localizedDescription)")}
            if let healthFacility = healthFacilities {
                 self?.mapControllerViewModel?.healthFacilitiesList = healthFacility
            }
           
            DispatchQueue.main.async {
                self?.addHealthFacilitiesAnnotations()
            }
            
        }
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





//MARK: - setup map & localisation manager

extension MapBarController: MKMapViewDelegate {
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            
            let regionInMeters = (mapControllerViewModel?.getRegionInMeter(segment: typeOfMapSControl.selectedSegmentIndex))!
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    private func checkLocationAuthorization() {
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
    
    private func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            
            //alert, no location enabled
        }
    }
    internal func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}







//MARK: - Adding& Removing PoiByTouch

extension MapBarController {

    
    func createPopupWithInput(location: CLLocationCoordinate2D) {
        //1. Create the alert controller.
        let alert = UIAlertController(title: NSLocalizedString("Create health facility.", comment: "Create health facility."), message: NSLocalizedString("Add facility where patients can get help.", comment: "Add facility where patients can get help."), preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = NSLocalizedString("Enter facility name", comment: "Enter facility name")
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: NSLocalizedString("Confirm", comment: "Confirm"), style: .default, handler: { [weak alert, weak self] (_) in
            let textFieldText = alert?.textFields![0].text! // Force unwrapping because we know it exists.
            let healthFacility = HealthFacility(name: textFieldText!, coordinatesCCL: location)
            self?.addFacilityAnnotationToFirebase(healthFacility: healthFacility)
            self?.addFacilityButton.isEnabled = true
            self?.addFacilityButton.backgroundColor = #colorLiteral(red: 0.6513178945, green: 0.01196665503, blue: 0.185541451, alpha: 1)
            self?.readGesture(false)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .default, handler: { [weak alert, weak self] (_) in
            alert?.dismiss(animated: true, completion: nil)
            self?.addFacilityButton.isEnabled = true
            self?.addFacilityButton.backgroundColor = #colorLiteral(red: 0.6513178945, green: 0.01196665503, blue: 0.185541451, alpha: 1)
            self?.readGesture(false)
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
            print(locationOnMap)
            //let pins = mapView.annotations
            createPopupWithInput(location: locationOnMap)
            
        }
    }
    
    
    
    func addFacilityAnnotationToFirebase(healthFacility: HealthFacility){
        FirebaseManager().addHealthFacility(healthFacility: healthFacility) { [weak self] (error) in
            guard error == nil else {
                print(error!)
                DispatchQueue.main.async {
                    self?.createYesNoAlert(title: "Error occured", message: "Facility not added. Please try again") {}
                }
         
                return
                }
            DispatchQueue.main.async {
                self?.mapControllerViewModel?.healthFacilitiesList?.append(healthFacility)
                self?.addHealthFacilitiesAnnotations()
            }
           
        }
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
        
        if let pin = annotationView?.annotation as? PinProtocol {
            annotationView?.image = UIImage(named: pin.imageName)
        }
        annotationView?.canShowCallout = true
        
        return annotationView
    }
    
}

extension MapBarController: StateControllerProtocol {
    func setState(state: StateController) {
        print("stateSet in map")
        mapControllerViewModel = MapControllerViewModel(confirmedList: state.statisticsListViewModel.returnConfirmedCasesViewModels)
    }
    
}
