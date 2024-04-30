//
//  PathTimeView.swift
//  GachMap
//
//  Created by 이수현 on 4/30/24.
//

import SwiftUI

struct PathTimeView: View {
    let width = UIScreen.main.bounds.width / 2.9
    let height = UIScreen.main.bounds.height / 10
    let pathName = "최적 경로"
    let time = "3"
    let textGradient = Gradient(colors: [
        Color(red: 0.1451, green: 0.5412, blue: 0.6314).opacity(1.0),
        Color(red: 0.2078, green: 0.1647, blue: 0.7294).opacity(1.0),
        Color(red: 0.1412, green: 0.5373, blue: 0.6275).opacity(1.0)
    ])
    
    let isLogin : Bool
    
    var body: some View {
        VStack(alignment: .leading){
            Text(pathName)
                .font(.system(size: 18))
                .bold()
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 0))

            HStack(alignment: .lastTextBaseline){
                if isLogin {
                    Text("AI 예측")
                        .font(.system(size: 18))
                        .foregroundColor(.clear) // 텍스트 자체는 투명하게 설정합니다.
                        .overlay(
                            LinearGradient(
                                gradient: textGradient,
                                startPoint: .bottomLeading,
                                endPoint: .topTrailing
                            )
                            .mask(Text("AI 예측")).bold()
                        )
                }

                
                Spacer()
                HStack(alignment: .lastTextBaseline, spacing : 4){
                    Text(time)
                        .font(.system(size: 40))
                        .bold()
                    Text("분")
                        .font(.system(size: 18))
                        .bold()
                }
              
            }
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
        }
        .frame(width: width, height: height)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.blue, lineWidth: 3)
        )
        .background(Color.white)
    }
}

#Preview {
    PathTimeView(isLogin: true)
}
