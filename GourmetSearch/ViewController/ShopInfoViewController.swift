//
//  ShopInfoViewController.swift
//  GourmetSearch
//
//  Created by 堀田凌平 on 2024/02/04.
//

import UIKit

class ShopInfoViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var access: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var url: UIButton!
    
    var sentInfo: Shop = Shop(name: "", address: "", mobile_access: "", open: "", urls: Url(pc: ""), photo: Photo(mobile: PhotoURL(l: "", s: "")), genre: Genre(name: ""))  // 初期値を設定
    var sentPhoto: UIImage = UIImage()  // ImageViewの写真を入れる変数
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        name.text = sentInfo.name
        address.text = sentInfo.address
        access.text = sentInfo.mobile_access
        url.setTitle("Webサイトはこちら", for: .normal)
        time.text = sentInfo.open
        imageView.image = sentPhoto
    }
    
    // urlButtonを押すとWebサイトに移動
    @IBAction func url(_ sender: UIButton) {
        guard let url = URL(string: sentInfo.urls.pc) else { return }
        UIApplication.shared.open(url)
    }

}
