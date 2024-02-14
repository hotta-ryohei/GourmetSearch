//
//  PinModel.swift
//  GourmetSearch
//
//  Created by 堀田凌平 on 2024/02/12.
//

import Foundation
import MapKit

struct PinModel {
    func pinModel(shops: [Shop]) -> [MKPointAnnotation] {
        var annotations: [MKPointAnnotation] = []
        for shop in shops {
            let latitude = shop.lat
            let longitude = shop.lng
            let location = CLLocationCoordinate2D(latitude: latitude , longitude: longitude )
            annotations.append(MKPointAnnotation(__coordinate: location))
        }
        return annotations
    }
}
