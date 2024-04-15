//
//  Path.swift
//  GachonMapProject
//
//  Created by 이수현 on 4/8/24.
//

import Foundation
import CoreLocation
class Path {
    let ITtoGachon : [Node] = [
//        Node(name: "반도체 대학 정문", location: CLLocation(coordinate: CLLocationCoordinate2D(
//            latitude: 37.4508817,
//            longitude: 127.1274769),
//            altitude: 55.8, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: Date())),
//        Node(name: "반도체대학 코너", location: CLLocation(coordinate: CLLocationCoordinate2D(
//            latitude: 37.4506271,
//            longitude: 127.1274554),
//            altitude: 55.8, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: Date())),
        Node(name: "반도체대학 앞 동산 횡단보도", location: CLLocation(coordinate: CLLocationCoordinate2D(
            latitude: 37.45062308,
            longitude: 127.1276374),
            altitude: 55.8, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: Date())),
        Node(name: "광장계단 근처", location: CLLocation(coordinate: CLLocationCoordinate2D(
            latitude: 37.45048746,
            longitude: 127.1280814),
            altitude: 56.1, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: Date())),
        Node(name: "가천관 - 공과대학 횡단보도", location: CLLocation(coordinate: CLLocationCoordinate2D(
            latitude: 37.45019238,
            longitude: 127.1292529),
            altitude: 66.2, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: Date())),
        Node(name: "공과대학 - 가천관 횡단보도", location: CLLocation(coordinate: CLLocationCoordinate2D(
            latitude: 37.45003035,
            longitude: 127.129184),
            altitude: 66.2, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: Date())),
        Node(name: "바나연 코너 횡단보도", location: CLLocation(coordinate: CLLocationCoordinate2D(
            latitude: 37.4503820,
            longitude: 127.1280018),
            altitude: 56.0, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: Date())),
    ]
    
    let homeToAI : [Node] = [
        Node(name: "1", location: CLLocation(coordinate: CLLocationCoordinate2D(
            latitude: 37.4550932,
            longitude: 127.1278891),
            altitude: 34.2088904, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: Date())),
        Node(name: "2", location: CLLocation(coordinate: CLLocationCoordinate2D(
            latitude: 37.4547923,
            longitude: 127.1279073),
            altitude: 34.4858192, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: Date())),
        Node(name: "3", location: CLLocation(coordinate: CLLocationCoordinate2D(
            latitude: 37.4548058,
            longitude: 127.1287922),
            altitude: 37.0070698, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: Date())),
        Node(name: "4", location: CLLocation(coordinate: CLLocationCoordinate2D(
            latitude: 37.4552869,
            longitude: 127.1293650),
            altitude: 37.7882867, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: Date())),
        Node(name: "5", location: CLLocation(coordinate: CLLocationCoordinate2D(
            latitude: 37.4550233,
            longitude: 127.1297266),
            altitude: 39.0347311, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: Date())),
        Node(name: "6", location: CLLocation(coordinate: CLLocationCoordinate2D(
            latitude: 37.4548862,
            longitude: 127.1300610),
            altitude: 39.4468345, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: Date())),
        Node(name: "7", location: CLLocation(coordinate: CLLocationCoordinate2D(
            latitude: 37.4547786,
            longitude: 127.1306543),
            altitude: 40.1306543, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: Date())),
        Node(name: "8", location: CLLocation(coordinate: CLLocationCoordinate2D(
            latitude: 37.4550956,
            longitude: 127.1307173),
            altitude: 43.2198522, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: Date())),
        Node(name: "9", location: CLLocation(coordinate: CLLocationCoordinate2D(
            latitude: 37.4550196,
            longitude: 127.1312346),
            altitude: 42.1312346, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: Date())),
        Node(name: "10", location: CLLocation(coordinate: CLLocationCoordinate2D(
            latitude: 37.4550713,
            longitude: 127.1314970),
            altitude: 43.9502033, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: Date())),
        Node(name: "11", location: CLLocation(coordinate: CLLocationCoordinate2D(
            latitude: 37.4549904,
            longitude: 127.1319162),
            altitude: 48.8436239, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: Date())),
        Node(name: "12", location: CLLocation(coordinate: CLLocationCoordinate2D(
            latitude: 37.4550636,
            longitude: 127.1319774),
            altitude: 48.8436239, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: Date())),
        Node(name: "13", location: CLLocation(coordinate: CLLocationCoordinate2D(
            latitude: 37.4554228,
            longitude: 127.1320045),
            altitude: 45.8039285, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: Date())),
        Node(name: "14", location: CLLocation(coordinate: CLLocationCoordinate2D(
            latitude: 37.4554967,
            longitude: 127.1322877),
            altitude: 43.7873648, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: Date())),
        Node(name: "15", location: CLLocation(coordinate: CLLocationCoordinate2D(
            latitude: 37.4550021,
            longitude: 127.1331962),
            altitude: 53.4987379, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: Date())),
        Node(name: "16", location: CLLocation(coordinate: CLLocationCoordinate2D(
            latitude: 37.4550924,
            longitude: 127.1333371),
            altitude: 53.4987379, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: Date())),

    ]
//
//    let AIToHome : [Node] = [
//        Node(name: "16", latitude: 37.4550924, longitude: 127.1333371, altitude: 53.4987379),
//        Node(name: "15", latitude: 37.4550021, longitude: 127.1331962, altitude: 53.4987379),
//        Node(name: "14", latitude: 37.4554967, longitude: 127.1322877, altitude: 43.7873648),
//        Node(name: "13", latitude: 37.4554228, longitude: 127.1320045, altitude: 45.8039285),
//        Node(name: "12", latitude: 37.4550636, longitude: 127.1319774, altitude: 48.8436239),
//        Node(name: "11", latitude: 37.4549904, longitude: 127.1319162, altitude: 48.8436239),
//        Node(name: "10", latitude: 37.4550713, longitude: 127.1314970, altitude: 43.9502033),
//        Node(name: "9", latitude: 37.4550196, longitude: 127.1312346, altitude: 42.1312346),
//        Node(name: "8", latitude: 37.4550956, longitude: 127.1307173, altitude: 43.2198522),
//        Node(name: "7", latitude: 37.4547786, longitude: 127.1306543, altitude: 40.1306543),
//        Node(name: "6", latitude: 37.4548862, longitude: 127.1300610, altitude: 39.4468345),
//        Node(name: "5", latitude: 37.4550233, longitude: 127.1297266, altitude: 39.0347311),
//        Node(name: "4", latitude: 37.4552869, longitude: 127.1293650, altitude: 37.7882867),
//        Node(name: "3", latitude: 37.4548058, longitude: 127.1287922, altitude: 37.0070698),
//        Node(name: "2", latitude: 37.4547923, longitude: 127.1279073, altitude: 34.4858192),
//        Node(name: "1", latitude: 37.4550932, longitude: 127.1278891, altitude: 34.2088904),
//    ]
    
    let Library : [Node] = [
        Node(name: "L-1", location: CLLocation(coordinate: CLLocationCoordinate2D(
            latitude: 37.4526132,
            longitude: 127.1329152),
            altitude: 78.1330068, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: Date())),
        Node(name: "L-2", location: CLLocation(coordinate: CLLocationCoordinate2D(
            latitude: 37.4527370,
            longitude: 127.1329290),
            altitude: 123.2, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: Date())),
        Node(name: "L-3", location: CLLocation(coordinate: CLLocationCoordinate2D(
            latitude: 37.4527942,
            longitude: 127.1330613),
            altitude: 75.3932716, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: Date())),
//        Node(name: "L-2", location: CLLocation(coordinate: CLLocationCoordinate2D(
//            latitude: 37.4527370,
//            longitude: 127.1329290),
//            altitude: 75.5380124, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: Date())),
//        Node(name: "L-3", location: CLLocation(coordinate: CLLocationCoordinate2D(
//            latitude: 37.4527942,
//            longitude: 127.1330613),
//            altitude: 75.3932716, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: Date())),
        Node(name: "L-4", location: CLLocation(coordinate: CLLocationCoordinate2D(
            latitude: 37.4526397,
            longitude: 127.1330479),
            altitude: 75.4579715, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: Date())),
        Node(name: "L-5", location: CLLocation(coordinate: CLLocationCoordinate2D(
            latitude: 37.4524433,
            longitude: 127.1331701),
            altitude: 83.7085116, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: Date())),
        
//
//        Node(name: "L-1", latitude: 37.4526132, longitude: 127.1329152, altitude: 78.1330068,
//             coordinate: CLLocationCoordinate2D(latitude: 37.4526800, longitude: 127.1330068)),
//        Node(name: "L-2", latitude: 37.4527370, longitude: 127.1329290, altitude: 75.5380124,
//             coordinate: CLLocationCoordinate2D(latitude: 37.4527370, longitude: 127.1329290)),
//        Node(name: "L-3", latitude: 37.4527942, longitude: 127.1330613, altitude: 75.3932716,
//             coordinate: CLLocationCoordinate2D(latitude: 37.4527942, longitude: 127.1330613)),
//        Node(name: "L-4", latitude: 37.4526397, longitude: 127.1330479, altitude: 75.4579715,
//             coordinate: CLLocationCoordinate2D(latitude: 37.4526764, longitude: 127.1330926)),
//        Node(name: "L-5", latitude: 37.4524433, longitude: 127.1331701, altitude: 83.7085116,
//             coordinate: CLLocationCoordinate2D(latitude: 37.4524433, longitude: 127.1331701)),
    ]
    
//    let Library1 : [Node] = [
//        Node(name: "L1-1", latitude: 37.4525300, longitude: 127.1334579, altitude: 82.1884449),
//        Node(name: "L1-2", latitude: 37.4527988, longitude: 127.1338672, altitude: 90.1467710),
//        Node(name: "L1-3", latitude: 37.4526459, longitude: 127.1333929, altitude: 83.3014488),
//    ]
}
