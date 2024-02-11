//
//  CategoryViewController.swift
//  GourmetSearch
//
//  Created by 堀田凌平 on 2024/02/11.
//

import Foundation
import UIKit
import CoreLocation

class CategoryViewController: UIViewController {
    @IBOutlet var categoryView: UIView!
    var latitude: Double = 0.00
    var longitude: Double = 0.00
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let locationManager = CLLocationManager()
        locationManager.startUpdatingLocation()
        getLocation()
        
    }
}

extension CategoryViewController: CLLocationManagerDelegate {
    func getLocation(){
        let locationManager = CLLocationManager()
        let myLatitude = Double(locationManager.location?.coordinate.latitude ?? 0.00)
        let myLongitude = Double(locationManager.location?.coordinate.longitude ?? 0.00)
        locationManager.stopUpdatingLocation()
        latitude = myLatitude
        longitude = myLongitude
    }

}
