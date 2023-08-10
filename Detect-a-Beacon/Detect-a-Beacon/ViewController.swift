//
//  ViewController.swift
//  Detect-a-Beacon
//
//  Created by Tony Alhwayek on 8/7/23.
//

import CoreLocation
import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate{

    @IBOutlet var distanceReading: UILabel!
    var locationManager: CLLocationManager?
    
    // Bool for challenge #1
    var foundBeacon: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        // Request permission to read location
        // Non-blocking call
        locationManager?.requestAlwaysAuthorization()
        
        view.backgroundColor = .gray
        
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            // Can we monitor beacons or not?
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                // Check if we can get range of beacons
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    // Scan for beacons
    func startScanning() {
        // Known good UUID
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let beaconRegion = CLBeaconRegion(uuid: uuid, major: 123, minor: 456, identifier: "MyBeacon")
        
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(in: beaconRegion)
    }
    
    // Update background and text based on distance of beacon
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 1) {
            switch distance {
            
            case .far:
                self.view.backgroundColor = .blue
                self.distanceReading.text = "FAR"
                
            case .near:
                self.view.backgroundColor = .orange
                self.distanceReading.text = "NEAR"
                
            case .immediate:
                self.view.backgroundColor = .red
                self.distanceReading.text = "IMMEDIATE"
            
            default:
                self.view.backgroundColor = .gray
                self.distanceReading.text = "UNKNOWN"
            }
        }
    }
    
    // Get location of beacon
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        // Challenge #1
        if !foundBeacon {
            let ac = UIAlertController(title: "Beacon detected", message: "Congratulations on detecting your first beacon!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            ac.addAction(okAction)
            present(ac, animated: true)
            foundBeacon = true
        }
        
        if let beacon = beacons.first {
            update(distance: beacon.proximity)
        } else {
            update(distance: .unknown)
        }
    }
}

