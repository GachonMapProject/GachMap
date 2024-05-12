//
//  PathTimeView.swift
//  GachMap
//
//  Created by 이수현 on 4/30/24.
//

import SwiftUI

struct PathTimeView: View {
    let width = UIScreen.main.bounds.width / 2.5
    let height = UIScreen.main.bounds.height / 8
    let pathName : String
    let time : Int?
    let textGradient = Gradient(colors: [
        Color(red: 0.1451, green: 0.5412, blue: 0.6314).opacity(1.0),
        Color(red: 0.2078, green: 0.1647, blue: 0.7294).opacity(1.0),
        Color(red: 0.1412, green: 0.5373, blue: 0.6275).opacity(1.0)
    ])
    
    let isLogin : Bool
    let num : Int
    @Binding var selectedPath : Int
    
    let pathNameDic = ["SHORTEST" : "최단 경로", "OPTIMAL" : "최적 경로", "MUDANG" : "무당이 경로"]
    
    var body: some View {
        VStack(alignment: .leading){
            Text(pathNameDic[pathName] ?? "")
                .font(.system(size: 23))
                .foregroundStyle(time != nil ? .black : Color(red: 0.5137, green: 0.5137, blue: 0.5137))
                .bold()
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 0))
            Spacer()
            HStack(alignment: .lastTextBaseline){
                if isLogin && time != nil{
                    Text("AI 예측")
                        .font(.system(size: 20))
                        .bold()
                        .foregroundColor(.clear) // 텍스트 자체는 투명하게 설정합니다.
                        .overlay(
                            LinearGradient(
                                gradient: textGradient,
                                startPoint: .trailing,
                                endPoint: .leading
                            )
                            .mask(Text("AI 예측")).bold()
                        )
                }

                Spacer()
                HStack(alignment: .lastTextBaseline, spacing : 4){
                    Text(time == nil ? "-" : String(time ?? 0))
                        .font(.system(size: 33))
                        .foregroundStyle(time != nil ? .black : Color(red: 0.5137, green: 0.5137, blue: 0.5137))
                        .bold()
                    Text("분")
                        .font(.system(size: 18))
                        .foregroundStyle(time != nil ? .black : Color(red: 0.5137, green: 0.5137, blue: 0.5137))
                        .bold()
                }
                
            }
            .padding(EdgeInsets(top: 0, leading: 5, bottom: 10, trailing: 10))
        }
        .frame(width: width, height: height)
        .background(time != nil ? .white : Color(red: 0.8, green: 0.8, blue: 0.8))
        .cornerRadius(15)
        .shadow(radius: 5, x: 2, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(selectedPath == num ? Color.blue : Color.clear, lineWidth: selectedPath == num ? 3 : 1)
        )
    }
 }


//#Preview {
//    PathTimeView(pathName: "최적 경로", time: "3", isLogin: true, selectedNum: Binding<Int>(3))
//}
