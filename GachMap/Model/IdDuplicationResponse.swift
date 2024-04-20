//
//  IdDuplicationResponse.swift
//  GachMap
//
//  Created by 원웅주 on 4/19/24.
//

import Foundation

struct IdDuplicationResponse: Decodable {
    var success: Bool
    var property: Int
    var message: String
    var data: String
}
