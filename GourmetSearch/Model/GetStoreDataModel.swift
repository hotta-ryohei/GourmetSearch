//
//  StoreData.swift
//  GourmetSearch
//
//  Created by 堀田凌平 on 2024/02/04.
//

import Foundation

class GetStoreDataModel {
    // 指定した検索範囲のお店情報を近い順に取得
    func getStoreData(range: Int, latitude: Double, longitude: Double) async throws -> StoreData {
        let APIKey = "4239ff237a17b68f"
        let url = URL(string: "https://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=\(APIKey)&lat=\(latitude)&lng=\(longitude)&range=\(range)&order=4&format=json")!
        let (data,_) = try await URLSession.shared.data(from: url)
        let decodedStoreData = try JSONDecoder().decode(StoreData.self, from: data)
        return decodedStoreData
    }
}
