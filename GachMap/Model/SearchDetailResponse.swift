//
//  SearchDetailResponse.swift
//  GachMap
//
//  Created by 원웅주 on 5/8/24.
//

import Foundation

struct SearchDetailResponse: Decodable {
    var success: Bool
    var property: Int
    var message: String
    var data: SearchDetailData
}

struct SearchDetailData: Decodable {
    var placeName: String
    var placeLatitude: Double
    var placeLongitude: Double
    var placeSummary: String
    var placeId: Int
    var mainImagePath: String?
}
