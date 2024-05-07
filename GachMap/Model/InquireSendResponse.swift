//
//  InquireSendResponse.swift
//  GachMap
//
//  Created by 원웅주 on 5/6/24.
//

import Foundation

struct InquireSendResponse: Decodable {
    var success: Bool
    var property: Int
    var message: String
    var data: InquireSendData
}

struct InquireSendData: Decodable {
    var inquiryId: Int
    var userId: Int64
}
