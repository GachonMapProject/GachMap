//
//  UserInfoResponse.swift
//  GachonMap
//
//  Created by 원웅주 on 4/12/24.
//

import Foundation

struct UserInfoResponse: Decodable {
    var success: Bool
    var message: String
    var property: Int
    var data: UserData
}

struct UserData: Decodable {
    var userCode: Int64
}
