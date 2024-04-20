//
//  GuestInfoResponse.swift
//  GachMap
//
//  Created by 원웅주 on 4/19/24.
//

import Foundation

struct GuestInfoResponse: Decodable {
    var success: Bool
    var property: Int
    var message: String
    var data: GuestInfoData
}

struct GuestInfoData: Decodable {
    var guestId: Int
}
