//
//  InquireListResponse.swift
//  GachMap
//
//  Created by 원웅주 on 5/6/24.
//

import Foundation

struct InquireListResponse: Decodable {
    var success: Bool
    var property: Int
    var message: String
    var data: [InquireListData]
}

struct InquireListData: Decodable {
    var inquiryId: Int
    var inquiryCategory: String
    var createDt: String
    var inquiryProgress: Bool
    var userId: Int64
    var inquiryTitle: String
}
