//
//  EventTabView.swift
//  GachonMap
//
//  Created by 원웅주 on 4/9/24.
//

import SwiftUI

struct EventTabView: View {
    @State var tabBarHeight = UITabBarController().tabBar.frame.size.height
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    var body: some View {
        VStack{
            Text("교내 행사")
                .font(.system(size: 35))
                .bold()
                .frame(width: screenWidth, height: 30, alignment: .leading)
                .padding(EdgeInsets(top: 10, leading: 30, bottom: 20, trailing: 0))
            
            HStack{
                ZStack(){
                    Image("festival")
                        .resizable()
                        .frame(width: screenWidth)
                        .scaledToFit()
                    HStack{
                        Image(systemName:"lessthan.circle.fill")
                            .font(.system(size: 35))
                            .foregroundColor(.gray)
                            .opacity(0.8)
                            .padding(.leading, 15)
                        
                        Spacer() // 가운데 여백 추가

                        Image(systemName:"greaterthan.circle.fill")
                            .font(.system(size: 35))
                            .foregroundColor(.gray)
                            .opacity(0.8)
                            .padding(.trailing, 15)
                    }
                    .frame(width: screenWidth)
                    
                    GeometryReader { geometry in
                        ZStack(alignment : .bottom){
                            VStack{
                                Text("본문 내용")
                                Button("더 알아보기", action: {})
                            }
                        }
                        .frame(width: geometry.size.width, height: geometry.size.height / 2)
                        .padding(.top, geometry.size.height / 2)
//                        .background(.black)
                    }


                }
                
            }
        }
        
        Text("TabBar 위치")
            .frame(width: screenWidth, height: tabBarHeight)
            .background(.blue)
    }
}

#Preview {
    EventTabView()
}
