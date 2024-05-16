//
//  GetIntermediateCoordinate.swift
//  GachonMap
//
//  Created by 이수현 on 4/9/24.
//

import Foundation
import CoreLocation


class GetIntermediateCoordinate {
    static func getCoordinates(path : [Node]) -> [Step] {
        var steps = [Step] ()
        
        // 경로의 첫지점부터 마지막 지점까지
        for i in 0..<path.count - 1{
            let next = i+2 == path.count ? 0 : i+2 // 마지막 경로의 next는 route[0]으로 표시
            let step = Step().intermediateRouteInfo(
                start: path[i],
                end: path[i+1],
                next: path[next],
                name: String(path[i].id)
            )
            
            steps.append(step)
        }
        return steps
    }
}


struct Step {
    var startLocation : CLLocation = CLLocation(coordinate: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), altitude: 0.0,
                                                horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: Date()) // 단계별 출발지 위치
    var endLocation : CLLocation = CLLocation(coordinate: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), altitude: 0.0,
                                              horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: Date()) // 단계별 목적지 위치
    var nextLocation : CLLocation = CLLocation(coordinate: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), altitude: 0.0,
                                               horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: Date()) // 단계별 목적지 다음 위치
    var locationName: String = "" // 단계의 위치 이름
    
    
    
    func intermediateRouteInfo(start : Node, end : Node, next : Node, name : String) -> Step {

//        
        // 중간 노드 사이의 이동 거리, 소요 시간, 목적지 위치, 단계의 위치 이름을 계산하고 Step 구조로 변경 후 반환하는 코드 필요
        return Step(startLocation: start.location, endLocation: end.location, nextLocation: next.location, locationName: name)
    }
}
