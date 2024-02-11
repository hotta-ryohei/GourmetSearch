//
//  CategoryViewController.swift
//  GourmetSearch
//
//  Created by 堀田凌平 on 2024/02/11.
//

import Foundation
import UIKit
import CoreLocation
import KRProgressHUD

class CategoryViewController: UIViewController {
    
    @IBOutlet weak var categoryView: UITableView!
    
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

extension CategoryViewController: UITableViewDataSource,UITableViewDelegate {
    // 検索件数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CategoryModel.categoryName.count
    }
    
    // セルのデザインを設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = categoryView.dequeueReusableCell(withIdentifier: "categoryViewCell", for: indexPath) as? CategoryViewCell else {
            fatalError("cellidentifierError")
        }
        
        cell.categoryName.text = CategoryModel.categoryName[indexPath.row]
        cell.categoryImage.image = UIImage(named: CategoryModel.categoryName[indexPath.row])
        return cell
    }
    
    // タップしたセル番号を渡し、ResultViewを開く処理へ
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCellNumber = indexPath.row
        // リザルトビューを開く処理へ
        openResultView(cellNumber: selectedCellNumber)
    }
    
    // ResultViewを開く処理
    func openResultView(cellNumber: Int) {
        KRProgressHUD.show()
        // ResultViewControllerを取得
        let storyboard = self.storyboard!
        let resultView = storyboard.instantiateViewController(withIdentifier: "ResultViewController") as! ResultViewController
        let getStoreDataModel = GetStoreDataModel()
        let changeImageModel = ChangeImageModel()
        
        Task {
            do {
                // データを取得
                let storeDatas = try await getStoreDataModel.getStoreDataForCategory(latitude: latitude, longitude: longitude, category: CategoryModel.categoryName[cellNumber])
                // 画像データを変換
                let imageDatas = await changeImageModel.changeImageModel(shops: storeDatas.results.shop)
                // リザルトビューを開く処理へ
                KRProgressHUD.dismiss() // ロード終了
                openResultView(storeDatas: storeDatas, imageDatas: imageDatas)
            } catch {
                resultViewErrorAlert()
            }
        }
        
        // エラー時のアラート
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
}

extension CategoryViewController: CLLocationManagerDelegate {
    // 座標を取得するメソッド
    func getLocation(){
        let locationManager = CLLocationManager()
        let myLatitude = Double(locationManager.location?.coordinate.latitude ?? 0.00)
        let myLongitude = Double(locationManager.location?.coordinate.longitude ?? 0.00)
        locationManager.stopUpdatingLocation()
        latitude = myLatitude
        longitude = myLongitude
    }
    
}
