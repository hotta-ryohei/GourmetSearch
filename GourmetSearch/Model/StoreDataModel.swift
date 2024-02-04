//
//  StoreDataModel.swift
//  GourmetSearch
//
//  Created by 堀田凌平 on 2024/02/04.
//

import Foundation

// APIで取得する情報型
struct StoreData: Decodable {
    let results: Results
}

struct Results: Decodable {
    let results_available: Int
    let shop: [Shop]
}

struct Shop: Decodable {
    let name: String
    let address: String
    let logo_image: String
    let access: String
    let photo: Photo
}

struct Photo: Decodable {
    let mobile: PhotoURL
}

struct PhotoURL: Decodable {
    let l: String
    let s: String
}