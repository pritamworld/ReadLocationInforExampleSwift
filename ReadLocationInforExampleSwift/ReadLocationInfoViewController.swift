//
//  ViewController.swift
//  ReadLocationInforExampleSwift
//
//  Created by moxDroid on 2019-011-11.
//  Copyright © 2019 moxDroid. All rights reserved.
//

import UIKit
import CoreLocation

import AudioToolbox

class ReadLocationInfoViewController: UIViewController, CLLocationManagerDelegate
{
    @IBOutlet weak var lblLng: UILabel!
    @IBOutlet weak var lblLat: UILabel!
    
    var locationManager: CLLocationManager! = nil
    var startLocation: CLLocation!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        locationManager.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //guard let location = locations.last else { return }
        
        if let location = locations.first {
            
            print(location.coordinate)
            self.lblLat.text = "Latitude  : \(location.coordinate.latitude)"
            self.lblLng.text = "Longitude : \(location.coordinate.longitude)"
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == CLAuthorizationStatus.denied) {
            showLocationDisabledPopUp()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error :\(error)")
    }
    
    // Show the popup to the user if we have been deined access
    func showLocationDisabledPopUp() {
        let alertController = UIAlertController(title: "Background Location Access Disabled",
                                                message: "In order to deliver pizza we need your location",
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(openAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func getLocation() {
           // 1
           let status = CLLocationManager.authorizationStatus()

           switch status {
               // 1
           case .notDetermined:
                   locationManager.requestWhenInUseAuthorization()
                   return

               // 2
           case .denied, .restricted:
               let alert = UIAlertController(title: "Location Services disabled", message: "Please enable Location Services in Settings", preferredStyle: .alert)
               let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
               alert.addAction(okAction)

               present(alert, animated: true, completion: nil)
               return
           case .authorizedAlways, .authorizedWhenInUse:
               break

           @unknown default:
               fatalError()
           }

           // 4
           locationManager.delegate = self
           locationManager.desiredAccuracy = kCLLocationAccuracyBest
           startLocation = nil
           locationManager.startUpdatingLocation()
       }
    
    func updateUser(location: CLLocation)
       {
              print("Lat: \(location.coordinate.latitude), Lng: \(location.coordinate.longitude)")
           
           let latestLocation = location
           
         print(String(format: "Latitude: %.4f", latestLocation.coordinate.latitude))
         print(String(format: "Longitude: %.4f", latestLocation.coordinate.longitude))
         print(String(format: "Horizontal Accuracy: %.4f", latestLocation.horizontalAccuracy))
         print(String(format: "Altitude: %.4f", latestLocation.altitude))
         print(String(format: "Vertical Accuracy: %.4f", latestLocation.verticalAccuracy))
           
           if startLocation == nil {
                  startLocation = latestLocation
              }
              
              let distanceBetween: CLLocationDistance =
                  latestLocation.distance(from: startLocation)
              
              print(String(format: "%.2f", distanceBetween))
           
       }
    
    func vibrateMyPhone()
    {
        //AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        if #available(iOS 10.0, *) {
           UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
        //Vibration.success.vibrate()
    }
}

