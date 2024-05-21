//
//  PathTimeView.swift
//  GachMap
//
//  Created by 이수현 on 4/30/24.
//

import SwiftUI

struct PathTimeView: View {
    let width = UIScreen.main.bounds.width / 2.3
    let height = UIScreen.main.bounds.height / 8
    let pathName : String
    let time : Int?
    let textGradient = Gradient(colors: [
        Color(red: 0.9686, green: 0.3608, blue: 0.1686).opacity(1.0),
        Color(red: 1.0, green: 0.0, blue: 0.0).opacity(1.0),
        Color(red: 0.9882, green: 0.1137, blue: 0.4824).opacity(1.0),
        Color(red: 0.8471, green: 0.0118, blue: 0.9176).opacity(1.0)

    ])
    
    let isLogin : Bool
    let num : Int
    @Binding var selectedPath : Int
    
    let pathNameDic = ["SHORTEST" : "최단 경로", "OPTIMAL" : "최적 경로", "busRoute" : "무당이 경로"]
    
    var body: some View {
        VStack(alignment: .leading){
            Text(pathNameDic[pathName] ?? "")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(time != nil ? .black : Color(red: 0.5137, green: 0.5137, blue: 0.5137))
                .padding(EdgeInsets(top: 10, leading: 8, bottom: 0, trailing: 0))
            Spacer()
            HStack(alignment: .lastTextBaseline){
                if isLogin && time != nil{
                    HStack(spacing : 0){
                        Image(systemName: "sparkles")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color(red: 0.9686, green: 0.3608, blue: 0.1686).opacity(1.0))
                        
                        Text("AI 예측")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.clear) // 텍스트 자체는 투명하게 설정합니다.
                            .overlay(
                                LinearGradient(
                                    gradient: textGradient,
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                                .mask(Text("AI 예측")
                                    .font(.system(size: 16, weight: .bold))
                                )
                            )
                    }
                    .padding(.leading, 8)
                }
                
                Spacer()
                    
   
                HStack(alignment: .lastTextBaseline, spacing : 2){
                    Text(time == nil ? "-" : String(format: "%.0f", round(Double(time ?? 0) / 60)))
                        .font(.system(size: 33))
                        .foregroundStyle(time != nil ? .black : Color(red: 0.5137, green: 0.5137, blue: 0.5137))
                        .bold()
                    Text("분")
                        .font(.system(size: 18))
                        .foregroundStyle(time != nil ? .black : Color(red: 0.5137, green: 0.5137, blue: 0.5137))
                        .bold()
                }
                .padding(EdgeInsets(top: 0, leading: 8, bottom: 10, trailing: 8))
                
            }
            
        }
        .frame(width: width, height: height)
        .background(time != nil ? .white : Color(red: 0.8, green: 0.8, blue: 0.8))
        .cornerRadius(15)
        .shadow(radius: 5, x: 2, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(selectedPath == num ? Color.blue : Color.clear, lineWidth: selectedPath == num ? 3 : 1)
        )
    }
 }


//#Preview {
//    PathTimeView(pathName: "최적 경로", time: "3", isLogin: true, selectedNum: Binding<Int>(3))
//}
