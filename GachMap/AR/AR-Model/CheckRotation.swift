//
//  CheckRotation.swift
//  GachMap
//
//  Created by 이수현 on 4/22/24.
//

import Foundation
import SwiftUI
import ARKit


struct CheckRotation {
    @State var sourcePosition = SCNVector3(x: 0, y: 0, z: 0)
    
    func checkRotation(currentLocation: CLLocation, path: [Node]) -> [Rotation]{
        let steps = GetIntermediateCoordinate.getCoordinates(path: path)
        var rotationData = [Rotation]()
        
        
        // 첫번째 출발지의 상대좌표 구하기
        let firstDistance = distanceBetweenCoordinate(source: currentLocation, destination: path[0].location)
        let firstTransformMatrix = transformMatrix(source: currentLocation, destination: path[0].location, distance: firstDistance)
        let firstNode = SCNNode()
        firstNode.transform = firstTransformMatrix
        sourcePosition = firstNode.position

        
        for step in steps {
            // 다음 노드 상대 좌표
            let nextDistance = distanceBetweenCoordinate(source: currentLocation, destination: step.nextLocation)
            let nextTransformationMatrix = transformMatrix(source: currentLocation, destination: step.nextLocation, distance: nextDistance)
            let nextNode = SCNNode()
            nextNode.transform = nextTransformationMatrix
            
            // 현재 노드 상대좌표
            let distance = distanceBetweenCoordinate(source: currentLocation, destination: step.endLocation)
            let transformationMatrix = transformMatrix(source: currentLocation, destination: step.endLocation, distance: distance)
            let endNode = SCNNode()
            endNode.transform = transformationMatrix
            
            // 1번 노드에서 2번 노드로 향하는 방향 벡터
            let sourceToEndVector = simd_float2(endNode.position.x - sourcePosition.x,
                                                   endNode.position.z - sourcePosition.z)

            // 1번 노드에서 3번 노드로 향하는 방향 벡터
            let sourceToNextVector = simd_float2(nextNode.position.x - sourcePosition.x,
                                                 nextNode.position.z - sourcePosition.z)
            let angleInDegrees = sourceToEndVector.x * sourceToNextVector.y - sourceToEndVector.y * sourceToNextVector.x
            print("angleInDegrees : \(angleInDegrees)")
            
            
            let rotation = angleInDegrees < -300 ? "좌회전" : angleInDegrees > 300 ? "우회전" : "직진"
            rotationData.append(Rotation(rotation: rotation, distance: distance))
            print("rotation : \(rotation), distance : \(distance)")
            
            sourcePosition = endNode.position
        }
        return rotationData
    }
    
    // 두 좌표 간 거리 계산
    private func distanceBetweenCoordinate(source: CLLocation, destination: CLLocation) -> Double {
            return source.distance(from: destination)
    } // end of distanceBetweenCoordinate()
    
    
    // 출발지와 목적지 사이의 변환 행렬 계산 후 노드 위치 방향 설정
    private func transformMatrix(source: CLLocation, destination: CLLocation, distance: Double) -> SCNMatrix4 {

        // 시작 노드와 도착 노드의 고도 차이를 계산
        let altitudeDifference = source.altitude - destination.altitude
        let translation = SCNMatrix4MakeTranslation(0, Float(-altitudeDifference), Float(-distance)) // 이동행렬
        
        // SCNMatrix4MakeRotation(회전량, x, y, z)
        // y축 기준으로 베어링 각도 만큼 회전 -> 베어링은 시계 방향 기준, rotation은 반시계 기준이라 음수를 붙임 , 회전각에 시작위치-첫번째 노드의 회전을 더함
        let rotation = SCNMatrix4MakeRotation(-1 * (Float(source.coordinate.calculateBearing(coordinate: destination.coordinate))), 0, 1, 0)
        
        let transformationMatrix = SCNMatrix4Mult(translation, rotation)
        return transformationMatrix
    } // end of tansformMatrix
}

struct Rotation : Identifiable{
    var id : UUID = UUID()
    var rotation : String
    var distance : Double
}
