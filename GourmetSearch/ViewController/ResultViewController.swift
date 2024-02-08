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
    
    var shops: [Shop] = []  // StoreDataのShop情報を入れる変数
    var ImageData: [UIImage] = []   // テーブルビュー内の写真をUIImage型で保存しておく変数
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultView.delegate = self
        resultView.dataSource = self
        resultView.register(UINib(nibName: "ResultViewCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "resultViewCell")
        
    }

}

extension ResultViewController: UITableViewDataSource,UITableViewDelegate {
    // 検索件数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shops.count
    }
    
    // セルのデザインを設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = resultView.dequeueReusableCell(withIdentifier: "resultViewCell", for: indexPath) as? ResultViewCell else {
            fatalError("cellidentifierError")
        }
        cell.name.text = shops[indexPath.row].name
        cell.address.text = shops[indexPath.row].address
        cell.logoImage.image = ImageData[indexPath.row]
        return cell
    }

    
    // タップしたセル番号を渡し、ShopInfoViewを開く処理へ
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCellNumber = indexPath.row
        // リザルトビューを開く処理へ
        openShopInfoView(cellNumber: selectedCellNumber)
    }
    
    // ShopInfoViewを開く処理
    func openShopInfoView(cellNumber: Int) {
        // ShopInfoViewControllerを取得
        let storyboard = self.storyboard!
        let shopInfoView = storyboard.instantiateViewController(withIdentifier: "ShopInfoViewController") as! ShopInfoViewController
        shopInfoView.sentInfo = shops[cellNumber]
        // TODO: ImageDataに情報を変換する処理を終えてから実行するようにする
        if ImageData .isEmpty {
            print("ImageDataが空白です")
        } else {
            shopInfoView.sentPhoto = ImageData[cellNumber]
        }
        navigationController?.pushViewController(shopInfoView, animated: true)
    }
}
