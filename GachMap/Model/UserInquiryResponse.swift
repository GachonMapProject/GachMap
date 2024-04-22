//
//  UserInquiryResponse.swift
//  GachMap
//
//  Created by 원웅주 on 4/20/24.
//

import Foundation

struct UserInquiryResponse: Decodable {
    var success: Bool
    var property: Int
    var message: String
    var data: UserInquiryData
}

struct UserInquiryData: Decodable {
    var userId: Int64
    var username: String
    var userNickname: String
    var userSpeed: String
    var userGender: String
    var userBirth: Int
    var userHeight: Int
    var userWeight: Int
}
