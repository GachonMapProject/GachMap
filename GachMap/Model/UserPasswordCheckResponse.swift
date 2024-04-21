//
//  UserPasswordCheckResponse.swift
//  GachMap
//
//  Created by 원웅주 on 4/20/24.
//

import Foundation

struct UserPasswordCheckResponse: Decodable {
    var success: Bool
    var property: Int
    var message: String
    var data: UserPasswordData?
}

struct UserPasswordData: Decodable {
    var userId: Int64
}
