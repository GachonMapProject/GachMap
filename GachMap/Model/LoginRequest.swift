//
//  LoginRequest.swift
//  GachonMap
//
//  Created by 원웅주 on 4/12/24.
//

import Foundation

// 학과 서버로 로그인 요청
struct LoginRequest: Encodable {
    var username: String
    var password: String
}
