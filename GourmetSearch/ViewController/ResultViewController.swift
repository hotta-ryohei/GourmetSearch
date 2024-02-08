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
    
    var shopsNumber: Int = 0    // 検索結果の件数
    var shops: [Shop] = []  // StoreDataのShop情報を入れる変数
    var ImageData: [UIImage] = []   // テーブルビュー内の写真をUIImage型で保存しておく変数
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultView.delegate = self
        resultView.delegate = self
        
        
        // バックグラウンドで取得したURLをUIImageに変換
        DispatchQueue.global(qos: .userInteractive) .async {
            var ImageDatas: [UIImage] = []
            var numberInt: Int = 0
            // TODO: URLに変換できなかった際のエラー処理を追記する必要あり
            for _ in self.shops {
                let urls = self.shops[numberInt].photo.mobile.l
                numberInt += 1
                if let url = URL(string: urls) {
                    if let data = try? Data(contentsOf: url) {
                        let UIImageData: UIImage = UIImage(data: data) ?? UIImage()
                            ImageDatas.append(UIImageData)
                    }
                }
            }
            
            self.ImageData = ImageDatas
        }
        
    }

}

extension ResultViewController: UITableViewDataSource,UITableViewDelegate {
    // 検索件数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shopsNumber
    }
    
    // セルのデザインを設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = resultView.dequeueReusableCell(withIdentifier: "ResultViewCell", for: indexPath)
         cell.textLabel!.text = shops[indexPath.row].name
        
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
