//
//  InquireSendRequest.swift
//  GachMap
//
//  Created by 원웅주 on 5/6/24.
//

import Foundation

struct InquireSendRequest: Encodable {
    var userId: Int64
    var inquiryTitle: String
    var inquiryContent: String
    var inquiryCategory: String
}
