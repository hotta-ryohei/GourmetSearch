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
    @IBOutlet weak var radiusSlider: UISlider!
    
    private var locationManager: CLLocationManager!
    var searchRadius: Int = 1000 // 検索する半径
    let sortRadiusSliderModel = SortRadiusSliderModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // locationManagerの初期設定
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization() // 位置情報の許可を呼び出す

        mapView.userTrackingMode = .follow  // 地図の中心を現在地にするために初期値を追跡に設定
        mapView.delegate = self
        let searchCircle: MKCircle = MKCircle(center:mapView.region.center, radius: CLLocationDistance(searchRadius))   // searchRadiusをもとに円の範囲を指定
        mapView.addOverlay(searchCircle)
        
    }
    
    
    @IBAction func radiusSlider(_ sender: UISlider) {
        let isIntRadius = sortRadiusSliderModel.sortRadiusSlider(radius: radiusSlider.value)
        searchRadius = isIntRadius
        
        // 検索半径の更新があった時、updateCircleを呼び出す
        if let location = locationManager.location {
            updateCircle(location.coordinate)
        }
    }
    
}


extension MapViewController: CLLocationManagerDelegate {
    // 位置情報の使用許可を取るためのメソッド
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
            // 許可がされていない場合
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization() // 許可を求める
            
            // 拒否されている場合
        case .restricted, .denied:
            locationPermissionAlert()   // locationPermissionAlertを表示
            
            // 許可されている場合
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation() // 位置情報を使用開始
            
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

extension MapViewController: MKMapViewDelegate {
    // マップに表示する円の設定
    func mapView(_ mapView: MKMapView,rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let settingCircle: MKCircleRenderer = MKCircleRenderer(overlay:  overlay)
        settingCircle.fillColor = UIColor.blue.withAlphaComponent(0.1)  // 塗りつぶしの色
        settingCircle.lineWidth = 0 // 外枠を無しにする
        return settingCircle
    }
    
    // 位置情報の更新があった時、updateCircleを呼び出す
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        updateCircle(location.coordinate)
    }

    // 円を更新するメソッド
    func updateCircle(_ coordinate: CLLocationCoordinate2D) {
        let searchCircle = MKCircle(center: coordinate, radius: CLLocationDistance(searchRadius))
        
        // 地図上の円を削除して、新しい円を追加する
        mapView.removeOverlays(mapView.overlays)
        mapView.addOverlay(searchCircle)
    }

}
