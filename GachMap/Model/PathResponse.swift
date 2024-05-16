//
//  PathResponse.swift
//  GachMap
//
//  Created by 이수현 on 5/11/24.
//

import Foundation

struct PathResponse: Decodable {
    var success: Bool
    var property: Int
    var message: String
    var data: [PathData]?
}

struct PathData: Decodable {
    var routeType : String
    var totalTime : Int?
    var nodeList : [NodeList]
}


struct NodeList: Decodable {
    var nodeId : Int
    var latitude : Double
    var longitude : Double
    var altitude : Double
}

