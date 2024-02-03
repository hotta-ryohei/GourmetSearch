//
//  SortRadiusSliderModel.swift
//  GourmetSearch
//
//  Created by 堀田凌平 on 2024/02/03.
//

import Foundation

struct SortRadiusSliderModel {
    // radiusSliderで取得した値をapiに利用できるメートルに変換して返す
    func sortRadiusSlider(radius: Float) -> Int {
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
}
