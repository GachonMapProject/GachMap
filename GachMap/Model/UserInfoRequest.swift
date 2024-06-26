//
//  UserInfoRequest.swift
//  GachonMap
//
//  Created by 원웅주 on 4/12/24.
//

import Foundation

struct UserInfoRequest: Encodable {
    var username: String
    var password: String
    var userNickname: String
    var userSpeed: String
    var userGender: String
    var userBirth: Int
    var userHeight: Int
    var userWeight: Int
}
