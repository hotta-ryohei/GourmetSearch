//
//  ViewController.swift
//  GourmetSearch
//
//  Created by 堀田凌平 on 2024/02/02.
//

import UIKit
import MapKit
import KRProgressHUD

class MapViewController: UIViewController {
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet weak var searchStore: UIButton!
    @IBOutlet weak var radiusSlider: UISlider!
    
    private var locationManager: CLLocationManager!
    var searchRadius: Int = 1000 // 検索する半径
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization() // 位置情報の許可を呼び出す
        locationManager.delegate = self
        mapView.delegate = self
        mapView.userTrackingMode = .follow  // 地図の中心を現在地にするために初期値を追跡に設定
        let searchCircle: MKCircle = MKCircle(center:mapView.region.center, radius: CLLocationDistance(searchRadius))   // 現在地の周りに初期値である1000mの円を設定
        mapView.addOverlay(searchCircle)    // 円をマップに追加
        navigationItem.title = String("検索範囲: \(searchRadius)m") // ナビゲーションビューのtitleに検索範囲を表示
        
    }
    
    
    @IBAction func radiusSlider(_ sender: UISlider) {
        let sortRadiusSliderModel = SortRadiusSliderModel()
        let afterSortRadiusSlider = sortRadiusSliderModel.sortMetersRadiusSlider(radius: radiusSlider.value)
        // 返り値0は初期値の1000mになおす
        if afterSortRadiusSlider != 0 {
            searchRadius = afterSortRadiusSlider
        } else {
            searchRadius = 1000
        }
        // ナビゲーションビューのtitleも更新
        navigationItem.title = String("検索範囲: \(searchRadius)m")
        // 検索半径の更新があった時、updateCircleを呼び出す
        if let location = locationManager.location {
            updateCircle(location.coordinate)
        }
    }
    
    @IBAction func openResultView(_ sender: UIButton) {
        // ロード開始
        KRProgressHUD.show()
        
        let getStoreDataModel = GetStoreDataModel()
        let sortRadiusSliderModel = SortRadiusSliderModel()
        let changeImageModel = ChangeImageModel()
        
        // getStoreDataの引数を生成
        let rangeInt = sortRadiusSliderModel.sortIntRadiusSlider(radius: searchRadius)
        let myLatitude = Double((locationManager.location?.coordinate.latitude)!)
        let myLongitude = Double((locationManager.location?.coordinate.longitude)!)
        Task {
            do {
                // データを取得
                let storeDatas = try await getStoreDataModel.getStoreDataForMap(range: rangeInt, latitude: myLatitude, longitude: myLongitude)
                // 画像データを変換
                let imageDatas = await changeImageModel.changeImageModel(shops: storeDatas.results.shop)
                // リザルトビューを開く処理へ
                KRProgressHUD.dismiss() // ロード終了
                self.openResultView(storeDatas: storeDatas, imageDatas: imageDatas)
                
            } catch {
                resultViewErrorAlert()
            }
        }
    }
    
    func resultViewErrorAlert() {
        let alertController = UIAlertController(
            title: "データを取得できませんでした。",
            message: "もう一度試してください。",
            preferredStyle: .alert
        )
        
        let closeAlert = UIAlertAction(title: "閉じる", style: .cancel, handler: nil)
        
        alertController.addAction(closeAlert)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // ResultViewを開く処理
    func openResultView(storeDatas: StoreData, imageDatas: [UIImage]) {
        // ResultViewControllerの関数に合った形に変換
        let sendShopInfo = storeDatas.results.shop
        // ResultViewControllerを取得
        let storyboard = self.storyboard!
        
        // 付近のお店の有無で処理を変更
        if imageDatas .isEmpty {
            let resultView = storyboard.instantiateViewController(withIdentifier: "ZeroResultViewController") as! ZeroResultViewController
            navigationController?.pushViewController(resultView, animated: true)
        } else {
            let resultView = storyboard.instantiateViewController(withIdentifier: "ResultViewController") as! ResultViewController
            // ResultViewControllerにデータを渡す
            resultView.shops = sendShopInfo
            resultView.ImageData = imageDatas
            navigationController?.pushViewController(resultView, animated: true)
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
