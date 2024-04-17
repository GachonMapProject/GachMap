//
//  DashboardView.swift
//  FreeGachonMap
//
//  Created by 원웅주 on 3/11/24.
//

import SwiftUI

// 여기서 로그인 정보 받아와서 회원/비회원 구분하고 분기

struct DashboardView: View {
    var body: some View {
        VStack() {
            VStack {
                HStack {
                    
                    HStack(spacing: 5) {
                        Text("김가천")
                            .font(.system(size: 28, weight: .bold))
                        Text("님")
                            .font(.system(size: 28))
                    }
                    .frame(alignment: .leading)
                    .padding(.leading, 17)
                    
                    Spacer()
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 7, style: .continuous)
                            .fill(.cyan)
                        
                        HStack {
                            Text("로그인")
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            Image(systemName: "person.circle")
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        }
                        
                    }
                    .frame(width: 95, height: 31, alignment: .trailing)
                    .padding(.trailing, 17)
                } // H1
                
                Spacer()
                
                HStack {
                    Text("안녕하세요!")
                        .font(.system(size: 28, weight: .bold))
                } // H2
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 17)
                
            } // V1
            
            VStack(spacing: 2) {
                HStack() {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .fill(.orange)
                            .shadow(radius: 7, x: 2, y: 2)
                            .frame(width: 193, height: 258)
                        
                        Text("AR 길찾기")
                    }
                    Spacer()
                    WeatherView()
                } // H3
                
                Spacer()
                
                HStack {
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .fill(.blue)
                            .shadow(radius: 7, x: 2, y: 2)
                            .frame(width: 131, height: 103)
                        
                        Text("캠퍼스맵")
                    }
                    
                    Spacer()
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .fill(.blue)
                            .shadow(radius: 7, x: 2, y: 2)
                            .frame(width: 198, height: 103)
                        
                        Text("행사 안내")
                    }
                } // H4
                
                Spacer()
                
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .fill(.gray)
                            .shadow(radius: 7, x: 2, y: 2)
                            .frame(width: 343, height: 500)
                        
                        Text("행사 안내")
                    }
                }
            }
            .frame(width: 343) // V2
            
        }
        .padding(.top, 20)// V3
    }
}

#Preview {
    ContentView()
}
