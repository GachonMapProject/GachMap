//
//  DeleteUserResponse.swift
//  GachMap
//
//  Created by 원웅주 on 4/18/24.
//

import Foundation

struct DeleteUserResponse: Decodable {
    var success: Bool
    var message: String
    var property: Int
    var data: DeleteUserData
}

struct DeleteUserData: Decodable {
    var userId: Int64 // == size of Bigint
}
