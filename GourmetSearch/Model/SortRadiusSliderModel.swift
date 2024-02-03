//
//  SortRadiusSliderModel.swift
//  GourmetSearch
//
//  Created by 堀田凌平 on 2024/02/03.
//

import Foundation

struct SortRadiusSliderModel {
    // radiusSliderで取得した値を1~5に変換して返す
    func sortRadiusSlider(radius: Float) -> Int {
        switch radius {
        case 1..<2:
            return 1
        case 2..<3:
            return 2
        case 3..<4:
            return 3
        case 4..<5:
            return 4
        case 5..<6,6:
            return 5
        default:
            return 0    // どれにも当てはまらない場合は0を返してエラー処理を実行
        }
    }
}
