//
//  DataManager.swift
//  Assignment-5
//
//  Created by TIANDA LIU on 2/13/20.
//  Copyright © 2020 TIANDA LIU. All rights reserved.
//

import Foundation
import MapKit
import UIKit
import CoreLocation


class DataManager {
    public static let sharedInstance = DataManager()
    var places = [String: Place]()
    let defaults = UserDefaults.standard
    var favList = [String]()
    var initRegion = [Double]()
    
    struct location: Codable {
        var name: String
        var description: String
        var lat: Double
        var long: Double
        var type: Int
    }
    
    struct Data: Codable {
        var places: [location]
        var region: [Double]
    }
    fileprivate init() {}
    
    func loadAnnotationFromPlist() {
        if let path = Bundle.main.path(forResource: "Data", ofType: "plist"), let xml = FileManager.default.contents(atPath: path),let data = try? PropertyListDecoder().decode(Data.self, from: xml) {
            for i in 0 ..< data.places.count {
                let place = data.places[i]
                let annotation = Place()
                annotation.name = place.name
                annotation.longDescription = place.description
                annotation.coordinate = CLLocationCoordinate2D(latitude: place.lat, longitude: place.long)
                annotation.lat = place.lat
                annotation.long = place.long
                annotation.type = place.type
                places[place.name] = annotation
            }
            self.initRegion = data.region
            self.defaults.set(favList, forKey: "FavList")
        }
    }
    func saveFavorites(_ name: String) {
        // has to be done this way, cannot read from self.favList directly
        self.favList = self.defaults.object(forKey: "FavList") as! [String]
        self.favList.append(name)
        self.defaults.set(favList, forKey: "FavList")
        print(favList)
        
    }
    func deleteFavorite(_ name: String) {
        self.favList = self.defaults.object(forKey: "FavList") as! [String]
        if let index = favList.firstIndex(of: name) {
            self.favList.remove(at: index)
            self.defaults.set(favList, forKey: "FavList")
        }
        print(favList)
    }
    
    // no need to implement
    func listFavorites() {}
    
}
