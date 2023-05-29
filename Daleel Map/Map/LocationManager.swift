//
//  LocationManager.swift
//  Daleel Map
//
//  Created by Fahad Al Khusaibi on 2/18/21.
//

import CoreLocation
import UIKit.UIImage
import NMAKit

extension MapVC: CLLocationManagerDelegate {
    
    
    func navigationManager(_ navigationManager: NMANavigationManager, didUpdateSpeedingStatus isSpeeding: Bool, forCurrentSpeed speed: Float, speedLimit: Float) {
        
        if !speedLimit.isZero {
            print("Speed = \(speedLimit)")
        }
    }
    
    

    
     //Mark:-
    func configureLocationManagerDelegate() {

        locationManager.delegate = self
        
        checkAuthorizationStatus()

    }
    
    //Mark:-
    func checkAuthorizationStatus() {
        
        if CLLocationManager.locationServicesEnabled() {
            
            locationManager(locationManager, didChangeAuthorization: locationManager.authorizationStatus)
            
        } else {
            
            print("Show alert how to enable location service at the setting")

        }
    }
    
    //Mark:- Check Authorization Status for location
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
            
        case .notDetermined:
            
            locationManager.requestWhenInUseAuthorization()

                                   
        case .authorizedWhenInUse, .authorizedAlways:
            
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
            
            if let img = UIImage(named: "Position") {

                let imageIcon = NMAImage(uiImage:img)//Add Image to a Marker


                let mapMarker = NMAMapMarker()

                mapMarker.icon = imageIcon

                mapView.positionIndicator.displayObject = mapMarker

            }

                                    
            mapView.positionIndicator.isVisible = true // Enable Position Indicator.
            
            mapView.positionIndicator.tracksCourse = true
            
            
            if useSimulater {
                
                hereMapStartUpdating()
                
            } else {
                
                locationManager.startUpdatingLocation()
        
            }
                        
            
        case .restricted, .denied:
            
            print("Alert user to enable location severice ")
            
            
        @unknown default :
            print("Error .....")//fatalError()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loc = locations.first {
            let coordinate =  loc.coordinate
            
            userLocation = NMAGeoCoordinates(latitude: coordinate.latitude, longitude: coordinate.longitude)
            
            
            if !onTrip, postionBtnEnable {
                
                self.mapView.set(geoCenter: self.userLocation, zoomLevel: 18, animation: .linear)

            }
            
            if onTrip {
                
                let timeToArrival = navigationManager.timeToArrival
                let distance =  navigationManager.distanceToDestination
                                
                let currentDateTime = Date().addingTimeInterval(timeToArrival)
                // initialize the date formatter and set the style
                let formatter = DateFormatter()
                formatter.timeStyle = .short
                formatter.dateStyle = .none
                let arrivingTime = formatter.string(from: currentDateTime)

                
                tripDistance.text = " \(TimeDecoding.secondToHHMMSS(timeToArrival))"
                
                tripDuration.text = "\(DistanceDecoding.meterToKm(UInt(distance))) | \(arrivingTime)"
            }
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
        
//        if postionBtnEnable {
//
//            UIView.animate(withDuration: 0.5) {
//
//                self.mapView.set(geoCenter: self.userLocation, zoomLevel: 18, animation: .none)
//
//            }
//
//        }

    }
    
    //Mark:- Updating the current postion on the map
    func hereMapStartUpdating(){
        
        // Change data source to HERE position data source
        
        let positionSource = NMADevicePositionSource()
        
        positionSource.setPositioningMethod(.GPS)
        
        positioningManager.dataSource = positionSource
    
        positioningManager.startPositioning()
        
        // Subscribe to position updates
        NotificationCenter.default.addObserver(self, selector: #selector(MapVC.didUpdatePosition),
                                               name: NSNotification.Name.NMAPositioningManagerDidUpdatePosition,
                                               object: positioningManager)
        
    }
    
    @objc func didUpdatePosition() {
        
        
        if let posttion = NMAPositioningManager.sharedInstance().currentPosition, let coordinates = posttion.coordinates {
            
            userLocation = coordinates
            
            if onTrip {
                
                let timeToArrival = navigationManager.timeToArrival
                let distance =  navigationManager.distanceToDestination
                                
                let currentDateTime = Date().addingTimeInterval(timeToArrival)
                // initialize the date formatter and set the style
                let formatter = DateFormatter()
                formatter.timeStyle = .short
                formatter.dateStyle = .none
                let arrivingTime = formatter.string(from: currentDateTime)

                
                tripDistance.text = " \(TimeDecoding.secondToHHMMSS(timeToArrival))"
                
                tripDuration.text = "\(DistanceDecoding.meterToKm(UInt(distance))) | \(arrivingTime)"
                
            }
            
            if !onTrip, postionBtnEnable {
                
                
                mapView.set(geoCenter: userLocation, animation: .bow)
                
            }
            
        }
    }
}



extension MapVC {
    //Mark:- Postion to Daleel Engineer Office
    func home(){


        self.userLocation = NMAGeoCoordinates(latitude: 23.5993926, longitude: 58.2474359)
        
        getLocation(latitude: 23.5993926, longitude: 58.2474359, zoomlevel: 18, animation: .none)
        
        
    }
    
    
    //Mark:- Postion The Map base on Lat and Lon
    func getLocation(latitude:Double,longitude:Double, zoomlevel:Float, animation:NMAMapAnimation){
        //create geo coordinate
        let geoCoordCenter = NMAGeoCoordinates(latitude: latitude, longitude: longitude)
        //set map view with geo center
        self.mapView.set(geoCenter: geoCoordCenter, zoomLevel: zoomlevel, animation: animation)
        
    }
}



