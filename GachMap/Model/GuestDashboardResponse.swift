//
//  GuestDashboardResponse.swift
//  GachonMap
//
//  Created by 원웅주 on 4/15/24.
//

import Foundation

struct GuestDashboardResponse: Decodable {
    var success: Bool
    var message: String
    var property: Int
    var data: GuestDashboardData
    var eventId: Int
    var eventName: String
    var temperature: Double
    var rainPrecipitation: Double
    var rainPrecipitationProbability: Double
}

struct GuestDashboardData: Decodable {
    
}
