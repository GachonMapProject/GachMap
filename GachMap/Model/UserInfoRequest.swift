//
//  UserInfoRequest.swift
//  GachonMap
//
//  Created by 원웅주 on 4/12/24.
//

import Foundation

struct UserInfoRequest: Encodable {
    var userId: Int
    var userDepartment: String
    var userNickname: String
    var walkSpeed: String
    var userGender: String
    var userBirth: Date
    var userHeight: Double
    var userWeight: Double
}
