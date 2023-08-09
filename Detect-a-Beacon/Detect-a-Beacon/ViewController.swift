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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        // Request permission to read location
        locationManager?.requestAlwaysAuthorization()
        
        view.backgroundColor = .gray
        
    }


}

