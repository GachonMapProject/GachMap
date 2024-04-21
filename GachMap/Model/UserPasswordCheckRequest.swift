//
//  UserPasswordCheckRequest.swift
//  GachMap
//
//  Created by 원웅주 on 4/20/24.
//

import Foundation

struct UserPasswordCheckRequest: Encodable {
    var userId: Int64
    var password: String
}
