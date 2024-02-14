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
    @IBOutlet weak var radiusChanger: UIStepper!
    @IBOutlet weak var addPin: UIButton!
    
    private var locationManager: CLLocationManager!
    var searchRadius: Int = 300 // 検索する半径
    var shops: [Shop] = []  // 店舗情報を一時保存する変数
    var UIImages: [UIImage] = []    // 写真を一時保存する変数
    var shopsPin: [MKPointAnnotation] = []  // ピンを入れる変数
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let stepper = radiusChanger
        let scale: CGFloat = 1.5
        stepper!.transform = CGAffineTransform(scaleX: scale, y: scale)
        
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization() // 位置情報の許可を呼び出す
        locationManager.delegate = self
        mapView.delegate = self
        mapView.userTrackingMode = .follow  // 地図の中心を現在地にするために初期値を追跡に設定
        let searchCircle: MKCircle = MKCircle(center:mapView.region.center, radius: CLLocationDistance(searchRadius))   // 現在地の周りに初期値である1000mの円を設定
        mapView.addOverlay(searchCircle)    // 円をマップに追加
        navigationItem.title = String("検索範囲: \(searchRadius)m") // ナビゲーションビューのtitleに検索範囲を表示
        
    }
    
    // UIStepperを操作した時の処理
    @IBAction func radiusChanger(_ sender: UIStepper) {
        // UIStepperで取得した値をメートルになおす処理
        let sortRadiusChangerModel = SortRadiusChangerModel()
        let afterSortRadiusChanger = sortRadiusChangerModel.sortMetersRadiusChanger(radius: Float(sender.value))
        // エラーの場合は初期値の300mに変更
        if afterSortRadiusChanger != 0 {
            searchRadius = afterSortRadiusChanger
        } else {
            searchRadius = 300
        }
        // ナビゲーションビューのtitleも更新
        navigationItem.title = String("検索範囲: \(searchRadius)m")
        // 検索半径の更新があった時、updateCircleを呼び出す
        if let location = locationManager.location {
            updateCircle(location.coordinate)
        }
    }
    
    // 検索ボタンが押された時の処理
    @IBAction func openResultView(_ sender: UIButton) {
        // ロード開始
        KRProgressHUD.show()
        
        let getStoreDataModel = GetStoreDataModel()
        _ = SortRadiusChangerModel()
        let changeImageModel = ChangeImageModel()
        
        // getStoreDataの引数を生成
        let rangeInt = Int(radiusChanger.value)
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
                KRProgressHUD.dismiss()
                resultViewErrorAlert()
            }
        }
    }
    
    // データが取得できなかったとき表示するアラート
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
    
    // ピンを表示するメソッド
    @IBAction func addPIn(_ sender: Any) {
        // ロード開始
        KRProgressHUD.show()
        mapView.removeAnnotations(shopsPin) // 現在あるピンを削除
        shopsPin = []   // 中身を初期化
        
        let getStoreDataModel = GetStoreDataModel()
        let pinModel = PinModel()
        let changeImageModel = ChangeImageModel()
        
        // getStoreDataの引数を生成
        let rangeInt = Int(radiusChanger.value)
        let myLatitude = Double((locationManager.location?.coordinate.latitude)!)
        let myLongitude = Double((locationManager.location?.coordinate.longitude)!)
        Task {
            do {
                // データを取得
                let storeDatas = try await getStoreDataModel.getStoreDataForMap(range: rangeInt, latitude: myLatitude, longitude: myLongitude)
                // 画像データを変換
                let imageDatas = await changeImageModel.changeImageModel(shops: storeDatas.results.shop)
                
                // ピンを表示する処理
                shopsPin = pinModel.pinModel(shops: storeDatas.results.shop)
                KRProgressHUD.dismiss() // ロード終了
                mapView.addAnnotations(shopsPin)    // ピンを追加
                shops = storeDatas.results.shop
                UIImages = imageDatas
            } catch {
                KRProgressHUD.dismiss() // ロード終了
                resultViewErrorAlert()
            }
        }
    }
    
    // ピンをタップしたら詳細画面を開くメソッド
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        do {
            let latitude = view.annotation?.coordinate.latitude
            let longitude = view.annotation?.coordinate.longitude
            // 位置情報が一致した店舗情報の配列番号を取得する処理
            var count: Int = 0
            for shop in shops {
                if latitude == shop.lat && longitude == shop.lng { break }
                count += 1
            }
    
            // 店舗詳細画面を開く処理
            let storyboard = self.storyboard!
            let shopInfoView = storyboard.instantiateViewController(withIdentifier: "ShopInfoViewController") as! ShopInfoViewController
            
            // shopsに含まれていないAnnotationViewをタップしたらindexErrorをスローし、エラーアラートを表示
            guard count < shops.count && count < UIImages.count else {
                throw ErrorModel.MyError.indexError
            }
            shopInfoView.sentInfo = shops[count]
            shopInfoView.sentPhoto = UIImages[count]
            present(shopInfoView, animated: true, completion: nil)
        } catch {
            resultViewErrorAlert()
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
