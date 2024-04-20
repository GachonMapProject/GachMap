//
//  UserInfoModifyRequest.swift
//  GachMap
//
//  Created by 원웅주 on 4/20/24.
//

import Foundation

struct UserInfoModifyRequest: Encodable {
    var password: String
    var userNickname: String
    var userSpeed: String
    var userGender: String
    var userBirth: Int
    var userHeight: Int
    var userWeight: Int
}
