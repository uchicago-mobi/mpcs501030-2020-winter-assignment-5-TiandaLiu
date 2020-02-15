//
//  Place.swift
//  Assignment-5
//
//  Created by TIANDA LIU on 2/13/20.
//  Copyright © 2020 TIANDA LIU. All rights reserved.
//

import Foundation
import MapKit

class Place: MKPointAnnotation {
    var name: String?
    var longDescription: String?
    var lat: Double?
    var long: Double?
    var type: Int?
}
