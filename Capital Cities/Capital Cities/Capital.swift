//
//  Capital.swift
//  Capital Cities
//
//  Created by Tony Alhwayek on 8/3/23.
//

import MapKit
import UIKit

class Capital: NSObject, MKAnnotation, MKMapViewDelegate {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    
    init(title: String? = nil, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
    


}
