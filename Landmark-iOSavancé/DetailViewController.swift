//
//  DetailViewController.swift
//  Landmark-iOSavancé
//
//  Created by lpiem on 16/03/2022.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {
    var landmark : Landmark?

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let landmark = landmark {
            super.title = landmark.name
            let location = CLLocation(latitude: landmark.locationCoordinate.latitude, longitude: landmark.locationCoordinate.longitude)
            mapView.centerToLocation(location, regionRadius: 1000000.0)
            let place = Place(title: landmark.name, coordinate: CLLocationCoordinate2D(latitude: landmark.locationCoordinate.latitude,
                                                                                       longitude: landmark.locationCoordinate.longitude),
                              info: landmark.description)
            mapView.addAnnotation(place)
            imageView.image = landmark.image
            locationLabel.text = "Location : " + landmark.park + ", " + landmark.city + " - " + landmark.state
            descriptionLabel.text = "Description : " + landmark.description
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.layer.cornerRadius = imageView.bounds.width / 2
        //imageView.layer.cornerCurve = .circular
    }
}

