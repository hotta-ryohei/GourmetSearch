//
//  ChangeImageModel.swift
//  GourmetSearch
//
//  Created by 堀田凌平 on 2024/02/08.
//

import Foundation
import UIKit

struct ChangeImageModel {
    func changeImageModel(shops: [Shop]) async -> [UIImage] {
        var imageDatas: [UIImage] = []
        
        for shop in shops {
            let urlString = shop.photo.mobile.l
            
            if let url = URL(string: urlString) {
                do {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    if let imageData = UIImage(data: data) {
                        imageDatas.append(imageData)
                    } else {
                        print("urlの変換エラー")
                        imageDatas.append(UIImage(named: "noimage")!)
                    }
                } catch {
                    // エラーの場合、noimageの画像を変えす
                    print("urlの読み取りエラー: \(error)")
                    imageDatas.append(UIImage(named: "noimage")!)
                }
            }
        }
        return imageDatas
    }
}
