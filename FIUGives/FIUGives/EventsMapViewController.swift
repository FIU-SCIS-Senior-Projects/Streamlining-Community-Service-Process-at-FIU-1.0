//
//  MyHoursViewController.swift
//  FIUGives
//
//  Created by Katya Gumnova on 6/11/17.
//  Copyright © 2017 FIUGives. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class EventsMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate {
    var locationManager:CLLocationManager!
    let selectDatePicker = UIDatePicker()
    
    @IBOutlet weak var eventsMapView: MKMapView!
    @IBOutlet weak var dateSelectionTextField: UITextField!


    override func viewDidLoad() {
        super.viewDidLoad()
        dateSelectionTextField.delegate = self
        currentLocation()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dateSelectionTextField.text = ""
        for eventArray in EventCalendar.shared.myCalendar.values {
            for eachEvent in eventArray {
                let annotation = MKPointAnnotation()
                annotation.title = eachEvent.eventName
                annotation.subtitle = eachEvent.returnStartDate()
                annotation.coordinate = CLLocationCoordinate2D(latitude: eachEvent.eventLatitude, longitude: eachEvent.eventLongitude)
                eventsMapView.addAnnotation(annotation)
                
            }
        }
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //function to determine user's current location
    func currentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
  
   func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations[0] as CLLocation
        manager.stopUpdatingLocation()
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        eventsMapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error\(error)")
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        selectDatePicker.datePickerMode = UIDatePickerMode.date
        selectDatePicker.backgroundColor = UIColor.white
        textField.inputView = selectDatePicker
        selectDatePicker.addTarget(self, action: #selector(EventsMapViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = false
        toolBar.sizeToFit()
        toolBar.tintColor = UIColor.black
        
        let mapButton = UIBarButtonItem(title: "Map", style: .plain, target: self, action: #selector(EventsMapViewController.mapResults))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(EventsMapViewController.cancelSearch))
        toolBar.setItems([cancelButton, spaceButton, mapButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        dateSelectionTextField.text =  formatter.string(from: selectDatePicker.date)
        
    }
    
    func datePickerValueChanged (sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        dateSelectionTextField.text =  formatter.string(from: sender.date)
        print(selectDatePicker.date)

    }
    
    func mapResults() {
        dateSelectionTextField.resignFirstResponder()
        eventsMapView.removeAnnotations(eventsMapView.annotations)
        for eventArray in EventCalendar.shared.myCalendar.values {
            for eachEvent in eventArray {
                let order = Calendar.current.compare(eachEvent.eventDate.myEventDate, to: selectDatePicker.date, toGranularity: .day)
                if order  == ComparisonResult.orderedSame {
                let annotation = MKPointAnnotation()
                annotation.title = eachEvent.eventName
                annotation.subtitle = eachEvent.returnStartDate()
                annotation.coordinate = CLLocationCoordinate2D(latitude: eachEvent.eventLatitude, longitude: eachEvent.eventLongitude)
                eventsMapView.addAnnotation(annotation)
                }
            }
        }
    }
    
    func cancelSearch() {
        dateSelectionTextField.text = ""
        dateSelectionTextField.resignFirstResponder()
    }
}
