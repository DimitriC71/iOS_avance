//
//  CollectionViewCellCategory.swift
//  Landmark-iOSavancé
//
//  Created by lpiem on 10/03/2022.
//

import UIKit

class CollectionViewCellCategory: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    public func configure(landmark: Landmark) {
        image.image = landmark.image
        name.text = landmark.name
    }
}
