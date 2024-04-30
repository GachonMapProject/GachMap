//
//  PathTimeView.swift
//  GachMap
//
//  Created by 이수현 on 4/30/24.
//

import SwiftUI

struct PathTimeView: View {
    let width = UIScreen.main.bounds.width / 2.6
    let height = UIScreen.main.bounds.height / 9
    let pathName : String
    let time : String?
    let textGradient = Gradient(colors: [
        Color(red: 0.1451, green: 0.5412, blue: 0.6314).opacity(1.0),
        Color(red: 0.2078, green: 0.1647, blue: 0.7294).opacity(1.0),
        Color(red: 0.1412, green: 0.5373, blue: 0.6275).opacity(1.0)
    ])
    
    let isLogin : Bool
    let num : Int
    @Binding var selectedNum : Int
    
    var body: some View {
        VStack(alignment: .leading){
            Text(pathName)
                .font(.system(size: 23))
                .bold()
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 0))
            
            HStack(alignment: .lastTextBaseline){
                if isLogin {
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
                    Text(time == nil ? "-" : time!)
                        .font(.system(size: 35))
                        .bold()
                    Text("분")
                        .font(.system(size: 18))
                        .bold()
                }
                
            }
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
        }
        .frame(width: width, height: height)
        .background(.white)
        .cornerRadius(15)
        .shadow(radius: 5, x: 2, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(selectedNum == num ? Color.blue : Color.clear, lineWidth: selectedNum == num ? 3 : 1)
        )
    }
 }


//#Preview {
//    PathTimeView(pathName: "최적 경로", time: "3", isLogin: true, selectedNum: Binding<Int>(3))
//}
