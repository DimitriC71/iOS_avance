//
//  Place.swift
//  CoreDataTodo
//
//  Created by lpiem on 08/03/2022.
//

import Foundation
import MapKit

class Place: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
}
