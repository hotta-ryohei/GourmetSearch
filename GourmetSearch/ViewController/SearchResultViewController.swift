//
//  SearchStoreResultViewController.swift
//  GourmetSearch
//
//  Created by 堀田凌平 on 2024/02/03.
//

import Foundation
import UIKit
class SearchResultViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var searchResultView: UITableView!

    var shops: [Shop] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchResultView.dataSource = self
    }
    
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
