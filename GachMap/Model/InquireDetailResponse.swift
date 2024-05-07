//
//  InquireDetailResponse.swift
//  GachMap
//
//  Created by 원웅주 on 5/6/24.
//

import Foundation

struct InquireDetailResponse: Decodable {
    var success: Bool
    var property: Int
    var message: String
    var data: InquireDetailData
}

struct InquireDetailData: Decodable {
    var inquiryCategory: String
    var inquiryId: Int
    var inquiryProgress: Bool
    var userId: Int64
    var inquiryTitle: String
    var inquiryContent: String
    var inquiryAnswer: String?
    var createDt: String
}
