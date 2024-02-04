//
//  SortRadiusSliderModel.swift
//  GourmetSearch
//
//  Created by 堀田凌平 on 2024/02/03.
//

import Foundation

struct SortRadiusSliderModel {
    // radiusSliderで取得した値をapiに利用できるメートルに変換して返す
    func sortMetersRadiusSlider(radius: Float) -> Int {
        switch radius {
        case 1..<2:
            return 300
        case 2..<3:
            return 500
        case 3..<4:
            return 1000
        case 4..<5:
            return 2000
        case 5..<6,6:
            return 3000
        default:
            return 0    // どれにも当てはまらない場合は0を返してエラー処理を実行
        }
    }
    // 検索範囲を1~5に分ける
    func sortIntRadiusSlider(radius: Int) -> Int {
        switch radius {
        case 300:
            return 1
        case 500:
            return 2
        case 1000:
            return 3
        case 2000:
            return 4
        case 3000:
            return 5
        default:
            return 0    // どれにも当てはまらない場合は0を返してエラー処理を実行
        }
    }
}
