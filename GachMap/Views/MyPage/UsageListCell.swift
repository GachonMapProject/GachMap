//
//  UsageListCell.swift
//  GachMap
//
//  Created by 원웅주 on 5/3/24.
//

import SwiftUI

struct UsageListCell: View {
    
    var usages: RouteHistoryData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            HStack {
                Image(systemName: "figure.walk.motion")
                    .font(.system(size: 17, weight: .bold))
                Text("도보")
                    .font(.system(size: 17, weight: .bold))
            }
            .padding(.bottom, 7)
            
            HStack {
                //2024-03-25T...
                Text("날짜")
                    .font(.system(size: 15))
                Text(usages.createDt)
                    .font(.system(size: 15, weight: .bold))
            }
            HStack {
                Text("출발")
                    .font(.system(size: 15))
                Text(usages.departures)
                    .font(.system(size: 15, weight: .bold))
            }
            HStack {
                Text("도착")
                    .font(.system(size: 15))
                Text(usages.arrivals)
                    .font(.system(size: 15, weight: .bold))
            }
            HStack {
                Text("총 소요시간")
                    .font(.system(size: 15))
                Text(usages.totalTime)
                    .font(.system(size: 15, weight: .bold))
            }
            HStack {
                HStack(spacing: 0) {
                    Text("경로 평가")
                        .font(.system(size: 15))
                        .padding(.trailing, 7)
                    Text(usages.satisfactionRoute)
                        .font(.system(size: 15, weight: .bold))
                    Text("/5")
                        .font(.system(size: 13))
                }
                .padding(.trailing, 70)
                
                HStack(spacing: 0) {
                    Text("소요시간 만족도")
                        .font(.system(size: 15))
                        .padding(.trailing, 7)
                    Text(usages.satisfactionTime)
                        .font(.system(size: 15, weight: .bold))
                    Text("/5")
                        .font(.system(size: 13))
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width - 60, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.white)
                .shadow(radius: 5, x: 2, y: 2)
        )
    }
}

//#Preview {
//    UsageListCell()
//}
