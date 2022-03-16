//
//  HeaderCollectionReusableView.swift
//  Landmark-iOSavancé
//
//  Created by lpiem on 09/03/2022.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var header: UILabel!
    
    func configureHeader(title: String) {
        header.text = title
    }
}
