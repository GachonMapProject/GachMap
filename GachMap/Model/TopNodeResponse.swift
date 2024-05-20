//
//  TopNodeResponse.swift
//  GachMap
//
//  Created by 원웅주 on 5/20/24.
//

import Foundation

struct TopNodeResponse: Decodable {
    var success: Bool
    var property: Int
    var message: String
    var data: [TopNodeData]
}

struct TopNodeData: Decodable {
    var nodeId: Int
    var nodeName: String
    var nodeLatitude: Double
    var nodeLongitude: Double
    var nodeAltitude: Double
}
