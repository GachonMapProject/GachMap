//
//  NavigationInfoView.swift
//  GachMap
//
//  Created by 이수현 on 4/22/24.
//

import SwiftUI

struct NavigationInfoView: View {
    @EnvironmentObject var globalViewModel : GlobalViewModel
    
    let rotationDic = ["우회전" : "arrowshape.turn.up.right.circle.fill",
                       "좌회전" : "arrowshape.turn.up.left.circle.fill",
                       "직진" : "arrow.up.circle.fill"]
    @State var distance : Int = 0
    @State var rotation : String = "우회전"

    var body: some View {
        HStack{
            Image(systemName: rotationDic[rotation] ?? "arrow.up.circle.fill")
                .resizable()
                .foregroundColor(.blue)
                .frame(width: 50, height: 50)
                .padding(.leading)
                .aspectRatio(contentMode: .fit) // 이미지의 비율을 유지하면서 부모 뷰에 맞게 조정
            
            VStack(alignment: .leading){
                Text(globalViewModel.destination)
                    .font(.system(size: 16))
                Text("\(rotation) 후 \(distance)m 이동")
                    .font(.system(size: 20))
                    .bold()
            }
            .padding()
          
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.width * 0.2)
        .background(.white)
        .cornerRadius(20)
        .shadow(radius: 5, x: 2, y: 2)
    }
}

#Preview {
    NavigationInfoView()
}
