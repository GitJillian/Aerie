//
//  LocationManager.swift
//  aerie
//
//  Created by Gitjillian on 2021/3/16.
//  Copyright © 2021 Yejing Li. All rights reserved.
//  Basically, location manager allows user to ask the apple location with a string, and it returns a list of places that matches its name

import UIKit
import Foundation
import CoreLocation

//location struct
struct Location {
    let title: String
    let coordinates: CLLocationCoordinate2D?
    let locationDict: [String:Any]
}

class LocationManager: NSObject {
    static let shared = LocationManager()
    
    //user will enter a string to describe a place, and it returns the possible results
    public func findLocations(with query: String, completion: @escaping ([Location]) -> Void){
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(query){ places, error in
            guard let places = places, error == nil else{
                completion([])
                return
            }
            
            //storing the locations into a list
            let models : [Location] = places.compactMap({ place in
                var name = ""
                
                if let locationName = place.name{
                    name += locationName
                }
                if let adminRegion = place.administrativeArea{
                    name += ", \(adminRegion)"
                }
                if let locality = place.locality{
                    name += ", \(locality)"
                }
                if let country = place.country{
                    name += ", \(country)"
                }
                
                let result = Location(title:       name,
                                      coordinates: place.location?.coordinate,
                                      locationDict: [Constants.location.locationName: "\(String(describing: place.name))" ,
                                                     Constants.location.adminRegion : "\(String(describing: place.administrativeArea))" ,
                                                     Constants.location.locality    : "\(String(describing: place.locality))",
                                                     Constants.location.country     : "\(String(describing: place.country))"
                                                    ]
                                      )
                return result
            })
            completion(models)
        }
    }
    
}
