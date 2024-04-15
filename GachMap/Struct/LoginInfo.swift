//
//  LoginInfo.swift
//  GachonMap
//
//  Created by 원웅주 on 4/14/24.
//

import Foundation

struct LoginInfo: Codable {
    var userCode: Int64?
    var isStudent: Bool
    var guestCode : String?
    
    // 근데 기기에 저장할때는 userId만 있어도 되지않나?
}
