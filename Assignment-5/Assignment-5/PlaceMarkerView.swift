//
//  PlaceMarkerView.swift
//  Assignment-5
//
//  Created by TIANDA LIU on 2/13/20.
//  Copyright © 2020 TIANDA LIU. All rights reserved.
//

import Foundation
import MapKit

class PlaceMarkerView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            clusteringIdentifier = "Place"
            displayPriority = .defaultLow
            markerTintColor = .systemRed
            glyphImage = UIImage(systemName: "pin.fill")
        }
    }
}
