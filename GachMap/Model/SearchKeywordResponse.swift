//
//  SearchKeywordResponse.swift
//  GachMap
//
//  Created by 원웅주 on 5/8/24.
//

import Foundation

struct SearchKeywordResponse: Decodable {
    var success: Bool
    var property: Int
    var message: String
    var data: [SearchKeywordData]
}

struct SearchKeywordData: Decodable {
    var placeId: Int
    var placeName: String
    var placeSummary: String
}
