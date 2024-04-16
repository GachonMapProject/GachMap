//
//  PlaceCategoryResponse.swift
//  GachMap
//
//  Created by 이수현 on 4/16/24.
//

import Foundation

struct PlaceCategoryResponse : Decodable {
    var success: Bool
    var message: String
    var property: Int
    var data: CategoryData
}

struct CategoryData : Decodable {
    var placeId : Int
    var placeName : String
    var placeLatitude : Double
    var placeLongitude : Double
    var placeSummary : String
}

