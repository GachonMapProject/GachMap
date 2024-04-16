//
//  UserDashboardResponse.swift
//  GachonMap
//
//  Created by 원웅주 on 4/15/24.
//

import Foundation

struct UserDashboardResponse: Decodable {
    var success: Bool
    var message: String
    var property: Int
    var data: UserDashboardData
    var userCode: Int64
    var userNickname: String
    var eventId: Int
    var eventName: String
    var temperature: Double
    var rainPrecipitation: Double
    var rainPrecipitationProbability: Double
}

struct UserDashboardData: Decodable {
    
}
