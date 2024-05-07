//
//  AIDescriptionView.swift
//  GachMap
//
//  Created by 이수현 on 5/1/24.
//

import SwiftUI

struct AIDescriptionView: View {
    var body: some View {
        HStack{
            Image(systemName: "person.crop.circle.badge.clock")
                .resizable()
                .frame(width: 30, height: 25)
                .scaledToFit()
                .padding(.horizontal, 10)
            HStack(spacing : 0){
                Text("AI 학습")
                Text(" 개인화 소요시간")
                    .bold()
                Text(" 제공")
            }
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width - 30, height: 40)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(
                    LinearGradient(gradient: Gradient(colors: [.red, .orange, .yellow, .green, .blue, .purple]), startPoint: .trailing, endPoint: .leading),
                    lineWidth: 3
                )
        )
        .background(.white)
        .cornerRadius(15)
        .shadow(radius: 5, x: 2, y: 2)
        .font(.system(size: 18))
    }
}

#Preview {
    AIDescriptionView()
}
