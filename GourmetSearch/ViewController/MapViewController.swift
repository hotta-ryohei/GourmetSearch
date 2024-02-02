//
//  ViewController.swift
//  GourmetSearch
//
//  Created by 堀田凌平 on 2024/02/02.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet var mapView: MKMapView!
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
}

// 位置情報の使用許可を取るためのメソッド
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
            // 許可がされていない場合
        case .notDetermined:
            // 許可を求める
            locationManager.requestWhenInUseAuthorization()
            // 拒否されている場合
        case .restricted, .denied:
            // locationPermissionAlertを表示
            locationPermissionAlert()
            
            // 許可されている場合
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        default:
            break
        }
    }
    
    // 位置情報の使用を拒否されている場合表示されるアラート
    func locationPermissionAlert() {
        let alertController = UIAlertController(
            title: "位置情報の使用が拒否されています。",
            message: "このアプリには位置情報が必要です。設定から位置情報の使用を許可してください。",
            preferredStyle: .alert
        )
        
        let closeAlert = UIAlertAction(title: "閉じる", style: .cancel, handler: nil)
         
         alertController.addAction(closeAlert)
         
         present(alertController, animated: true, completion: nil)
    }
}
