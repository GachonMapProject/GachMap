//
//  ARBalloonView.swift
//  GachMap
//
//  Created by 이수현 on 4/27/24.
//

import SwiftUI



struct ARNaviInfoView: View {
    
    let rotationDic = ["우회전" : "arrowshape.turn.up.right.circle.fill",
                       "좌회전" : "arrowshape.turn.up.left.circle.fill",
                       "직진" : "arrow.up.circle.fill"]
    
    @State var distance : Int = 0
    @State var rotation : String = "우회전"
    
    var body: some View {
        ZStack(alignment: .top){
            
//            Image(systemName: "arrowtriangle.down.fill")
//                .resizable()
//                .frame(width: 180, height: 120)
//                .foregroundColor(.white)
//                .shadow(radius: 7, x: 2, y: 2)
                
            
            HStack(){
                Image(systemName: rotationDic[rotation] ?? "arrow.up.circle.fill")
                    .resizable()
                    .frame(width: 70, height: 70)
                    .foregroundColor(.blue)
                    .scaledToFit()
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 10))

                
                VStack{
                    Text("\(rotation) 후")
                        .bold()
                    Text("\(distance)m 이동")
                        .bold()
                }
                .font(.system(size: 24))
                .padding(.bottom, 20)

            }
            .frame(width: 220, height: 140)
            .background{
                Image(systemName: "bubble.middle.bottom.fill")
                    .resizable()
                    .foregroundColor(.white)
            }
            .cornerRadius(25)
            .shadow(radius: 7, x: 2, y: 2)

            
            
        
        }
    }
}



#Preview {
    ARNaviInfoView()
}
