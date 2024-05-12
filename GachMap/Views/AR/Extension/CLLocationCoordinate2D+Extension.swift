//
//  CLLocationCoordinate2D+Extension.swift
//  GachMap
//
//  Created by 이수현 on 4/21/24.
//

import Foundation
import CoreLocation

// 베어링 각도 계산
extension CLLocationCoordinate2D {
    
    func calculateBearing(coordinate: CLLocationCoordinate2D) -> Double {
        let a = sin(coordinate.longitude.toRadians() - longitude.toRadians()) * cos(coordinate.latitude.toRadians())
        let b = cos(latitude.toRadians()) * sin(coordinate.latitude.toRadians()) - sin(latitude.toRadians()) * cos(coordinate.latitude.toRadians()) * cos(coordinate.longitude.toRadians() - longitude.toRadians())
        return atan2(a, b)
    }
}
