//
//  CollectionViewCell.swift
//  Landmark-iOSavancé
//
//  Created by lpiem on 09/03/2022.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var image: UIImageView!
    
    public func configure(landmark: Landmark) {
        image.image = landmark.image
        name.text = landmark.name
    }
}
