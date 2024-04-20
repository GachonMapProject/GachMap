//
//  GuestInfoRequest.swift
//  GachMap
//
//  Created by 원웅주 on 4/19/24.
//

import Foundation

struct GuestInfoRequest: Encodable {
    var guestSpeed: String
    var gusetGender: String
    var guestBirth: Int
    var guestHeight: Int
    var guestWeight: Int
}
