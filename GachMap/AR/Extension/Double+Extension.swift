//
//  Double+Extension.swift
//  GachMap
//
//  Created by 이수현 on 4/21/24.
//

import Foundation

// 라디안 <-> 각도 설정
extension Double {
    func toRadians() -> Double {
        return self * .pi / 180.0
    }
    
    func toDegrees() -> Double {
        return self * 180.0 / .pi
    }
}
