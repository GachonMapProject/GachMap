//
//  UsageListCell.swift
//  GachMap
//
//  Created by 원웅주 on 5/3/24.
//

import SwiftUI

struct UsageListCell: View {
    
    var usages: RouteHistoryData
    @State var minutes = 0
    @State var seconds = 0
    
    func formatCreateDt(_ createDt: String) -> String? {
        // 입력 문자열을 Date 객체로 변환하는 DateFormatter 설정
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        inputDateFormatter.locale = Locale(identifier: "ko_KR")
        
        // 문자열을 Date 객체로 변환
        if let date = inputDateFormatter.date(from: createDt) {
            // Date 객체를 원하는 형식의 문자열로 변환하는 DateFormatter 설정
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.dateFormat = "yyyy년 M월 d일(E) a h시 mm분"
            outputDateFormatter.locale = Locale(identifier: "ko_KR")
            
            // Date 객체를 원하는 형식의 문자열로 변환
            let formattedDateString = outputDateFormatter.string(from: date)
            return formattedDateString
        } else {
            // 변환에 실패한 경우 nil 반환
            return nil
        }
    }
    
    // 입력받은 총 초를 분과 초로 변환
    func convertTime(totalTime : Int) {
        minutes = totalTime / 60
        seconds = totalTime % 60
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            HStack {
                Image(systemName: "figure.walk.motion")
                    .font(.system(size: 17, weight: .bold))
                Text("도보")
                    .font(.system(size: 17, weight: .bold))
            }
            .padding(.bottom, 7)
            .onAppear(){
                convertTime(totalTime: usages.totalTime)
            }
            
            HStack {
                //2024-03-25T...
                Text("날짜")
                    .font(.system(size: 15))
                Text(formatCreateDt(usages.createDt) ?? usages.createDt)
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
                Text("\(minutes)분 \(seconds)초")
                    .font(.system(size: 15, weight: .bold))
            }
            HStack {
                HStack(spacing: 0) {
                    Text("경로 평가")
                        .font(.system(size: 15))
                        .padding(.trailing, 7)
                    Text(String(usages.satisfactionRoute))
                        .font(.system(size: 15, weight: .bold))
                    Text("/5")
                        .font(.system(size: 13))
                }
                .padding(.trailing, 70)
                
                HStack(spacing: 0) {
                    Text("소요시간 만족도")
                        .font(.system(size: 15))
                        .padding(.trailing, 7)
                    Text(String(usages.satisfactionTime))
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
