//
//  LoginInfo.swift
//  GachonMap
//
//  Created by 원웅주 on 4/14/24.
//

import Foundation

struct LoginInfo: Codable {
    var userCode: Int64?
    var guestCode: Int64?
    var isStudent: Bool
}
