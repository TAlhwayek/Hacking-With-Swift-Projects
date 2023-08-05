//
//  ViewController.swift
//  Capital Cities
//
//  Created by Tony Alhwayek on 8/3/23.
//

import MapKit
import WebKit
import UIKit

class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Challenge #2
        // Present first alert on startup to allow user to choose style
        presentMapAC()
        
        // Extra added on my own.
        // Allows user to change style whenver they want using a navbar button
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(presentMapAC))
        
        // Add pins to map
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.")
        let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.")
        mapView.addAnnotations([london, oslo, paris, rome, washington])
    }
    
    // Show popup when city tapped
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { return nil }
        
        let identifier = "Capital"
        
        // Challenge #1
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            // Also challenge #1 - Change pin tint color
            annotationView?.pinTintColor = .blue
            annotationView?.canShowCallout = true
            
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    // Modified this for challenge #3
    // Open up the city's wiki page when the info button is tapped
    // Present an alert when the popup is tapped
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        // Make sure it's a capital
        guard let capital = view.annotation as? Capital else { return }
        
        // Old code from tutorial, replaced with challenge #3's code
        // let placeName = capital.title
        // let placeInfo = capital.info
        //
        // let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
        // ac.addAction(UIAlertAction(title: "OK", style: .default))
        // present(ac, animated: true)
        
        var url = URL(string: "")
        
        // Switch statement to handle figuring out which link to open
        switch capital.title {
        case "London":
            url = URL(string: "https://en.wikipedia.org/wiki/London")
            break;
        case "Oslo":
            url = URL(string: "https://en.wikipedia.org/wiki/Oslo")
            break;
        case "Paris":
            url = URL(string: "https://en.wikipedia.org/wiki/Paris")
            break;
        case "Rome":
            url = URL(string: "https://en.wikipedia.org/wiki/Rome")
            break;
        case "Washington DC":
            url = URL(string: "https://en.wikipedia.org/wiki/Washington,_D.C.")
            break;
        default:
            url = URL(string: "https://en.wikipedia.org/")
            break;
        }
        
        // Check if url is not nil
        if let url = url {
            // Create new webview instance
            let webView = WKWebView()
            // Load specified url (wiki page in this case)
            webView.load(URLRequest(url: url))
            // Create generic view controller
            let viewController = UIViewController()
            // Display webview in viewcontroller
            viewController.view = webView
            // Display webview using navigation controller
            navigationController?.pushViewController(viewController, animated: true)
        }
        
    }
    
    // Present the choice alert
    // Made it its own function to get the bar button item working
    @objc func presentMapAC() {
        // Challenge #2
        let mapAC = UIAlertController(title: "Choose map style", message: nil, preferredStyle: .alert)
        
        // Make map show default style
        let standard = UIAlertAction(title: "Default", style: .default) { standard in
            self.mapView.mapType = .standard
        }
        
        // Make map show satellite style
        let satellite = UIAlertAction(title: "Satellite", style: .default) { satellite in
            self.mapView.mapType = .satellite
        }
        
        // Make map show hybrid style
        let hybrid = UIAlertAction(title: "Hybrid", style: .default) { hybrid in
            self.mapView.mapType = .hybrid
        }
        
        // Make map show hybrid style
        let hybridFlyover = UIAlertAction(title: "Hybrid Flyover", style: .default) { hybridFlyover in
            self.mapView.mapType = .hybridFlyover
        }
        
        // Add buttons to alert controller and present
        mapAC.addAction(standard)
        mapAC.addAction(satellite)
        mapAC.addAction(hybrid)
        mapAC.addAction(hybridFlyover)
        present(mapAC, animated: true)
    }
    
}

