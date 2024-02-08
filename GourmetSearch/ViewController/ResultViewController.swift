//
//  SearchStoreResultViewController.swift
//  GourmetSearch
//
//  Created by 堀田凌平 on 2024/02/03.
//

import Foundation
import UIKit
class ResultViewController: UIViewController{
    
    @IBOutlet weak var resultView: UITableView!
    
    var shopsNumber: Int = 10    // 検索結果の件数
    var shops: [Shop] = []  // StoreDataのShop情報を入れる変数
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultView.dataSource = self
        resultView.delegate = self
    }
}
extension ResultViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(shopsNumber)
        print(shops)
        return shopsNumber
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = resultView.dequeueReusableCell(withIdentifier: "ResultTableViewCell", for: indexPath)
        
        cell.textLabel?.text = "Shop \(indexPath.row + 1)"
        
        return cell
    }
        
}
