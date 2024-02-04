//
//  SearchStoreResultViewController.swift
//  GourmetSearch
//
//  Created by 堀田凌平 on 2024/02/03.
//

import Foundation
import UIKit
class SearchResultViewController: UIViewController{
    
    @IBOutlet weak var searchResultView: UITableView!
    
    var shopsNumber: Int = 0    // 検索結果の件数
    var shops: [Shop] = []  // StoreDataのShop情報を入れる変数
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchResultView.dataSource = self
        searchResultView.delegate = self
    }
}
extension SearchResultViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection results_available: Int) -> Int {
        return results_available
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを作成して返す（実際のデータを使ってセルをカスタマイズする必要があります）
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath)
        cell.textLabel?.text = "searchResult"
        return cell
    }
        
}
