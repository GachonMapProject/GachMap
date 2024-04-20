//
//  UserInfoModifyResponse.swift
//  GachMap
//
//  Created by 원웅주 on 4/20/24.
//

import Foundation

struct UserInfoModifyResponse: Decodable {
    var success: Bool
    var property: Int
    var message: String
    var data: UserInfoModifyData
}

struct UserInfoModifyData: Decodable {
    var userId: Int64
}
