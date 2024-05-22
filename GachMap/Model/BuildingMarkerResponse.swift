//
//  BuildingMarkerResponse.swift
//  GachMap
//
//  Created by 원웅주 on 5/7/24.
//

import Foundation

struct BuildingMarkerResponse: Decodable {
    var success: Bool
    var property: Int
    var message: String
    var data: [BuildingMarkerData]
}

struct BuildingMarkerData: Decodable {
    var placeName: String
    var placeLatitude: Double
    var placeLongitude: Double
    var placeSummary : String?
    var mainImagePath : String?
    var placeId: Int
}
