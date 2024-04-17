//
//  LoginResponse.swift
//  GachonMap
//
//  Created by 원웅주 on 4/12/24.
//

import Foundation

struct LoginResponse: Decodable {
    var success: Bool
    var message: String
    var property: Int // 성공했는데 DB에 있는 사람: 200, 성공했는데 DB에 없는 사람: 202
    var data: LoginData
}

struct LoginData: Decodable {
    var userId: Int64 // == size of Bigint
}
