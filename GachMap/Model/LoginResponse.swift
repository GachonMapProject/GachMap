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
    var property: Int
    var data: Data
}

struct Data: Decodable {
    var userId: Int64 // == size of Bigint
}
