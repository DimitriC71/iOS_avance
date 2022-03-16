//
//  Landmark.swift
//  Landmark-iOSavancé
//
//  Created by lpiem on 09/03/2022.
//

import Foundation
import CoreLocation
import UIKit

// MARK: - Landmark
struct Landmark: Decodable, Hashable {
    struct Coordinates: Decodable, Hashable {
        let longitude: Double
        let latitude: Double
    }
    
    enum Category: String, CaseIterable, Decodable {
        case lakes = "Lakes"
        case mountains = "Mountains"
        case rivers = "Rivers"
    }
    
    let id: Int
    let name: String
    let category: Category
    let city: String
    let state: String
    let isFeatured: Bool
    let isFavorite: Bool
    let park: String
    let description: String
    
    private let imageName: String
    private let coordinates: Coordinates
    
    var image: UIImage {
        return UIImage(named: imageName)!
    }
    
    var locationCoordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
    }
}

