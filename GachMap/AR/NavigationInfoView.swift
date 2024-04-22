//
//  NavigationInfoView.swift
//  GachMap
//
//  Created by 이수현 on 4/22/24.
//

import SwiftUI

struct NavigationInfoView: View {
    let rotationDic = ["우회전" : "arrow.triangle.turn.up.right.circle.fill",
                       "좌회전" : "arrow.triangle.turn.up.left.circle.fill",
                       "직진" : "arrow.up.circle.fill"]
    @State var distance = 0
    @State var rotation = "우회전"
    @State var nodeName = "반도체대학"
    var body: some View {
        HStack{
            Image(systemName: rotationDic[rotation] ?? "arrow.up.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit) // 이미지의 비율을 유지하면서 부모 뷰에 맞게 조정
                .foregroundColor(.blue)
                .frame(width: 50, height: 50)
                .padding(.leading)
            
            VStack(alignment: .leading){
                Text(nodeName)
                    .font(.system(size: 16))
                Text("\(rotation) 후 \(distance)m 이동")
                    .font(.system(size: 20))
                    .bold()
            }
          
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.width * 0.2)
        .background(.white)
        .cornerRadius(15)
        .shadow(radius: 5, x: 2, y: 2)
    }
}

#Preview {
    NavigationInfoView()
}
