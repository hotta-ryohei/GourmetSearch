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
