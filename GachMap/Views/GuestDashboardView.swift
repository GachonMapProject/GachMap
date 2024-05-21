//
//  DashboardView.swift
//  FreeGachonMap
//
//  Created by 원웅주 on 3/11/24.
//

import SwiftUI

struct GuestDashboardView: View {
    @EnvironmentObject var globalViewModel: GlobalViewModel
    
    @State private var isLoginMove: Bool = false
    
    var body: some View {
        
        VStack {
            VStack(spacing: 2) {
                
                HStack {
                    VStack(alignment: .leading) {
                        HStack(spacing: 6) {
                            Text("가천대학교")
                                .font(.system(size: 28, weight: .black))
                                .foregroundColor(.gachonBlue)
                            Text("방문을")
                                .font(.system(size: 28))
                        }
                        Text("환영합니다!")
                            .font(.system(size: 28, weight: .bold))
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        UserDefaults.standard.removeObject(forKey: "loginInfo")
                        
                        globalViewModel.isLogin = false
                    }, label: {
                        VStack(spacing: 5) {
                            Image(systemName: "iphone.and.arrow.forward")
                                .font(.system(size: 18, weight: .bold))
                            Text("로그인")
                                .font(.system(size: 15, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .frame(width: 80, height: 60)
                        .background(
                            RoundedRectangle(cornerRadius: 7)
                                .fill(.gachonBlue))
                    })
//                    .fullScreenCover(isPresented: $isLoginMove) {
//                        PrimaryView()
//                            .navigationBarBackButtonHidden()
//                    }
                }
                .padding(EdgeInsets(top: 0, leading: 17, bottom: 0, trailing: 17))
                
            } // V1
            
            VStack(spacing: 13) {
                HStack() {
                    Button(action: {
                        globalViewModel.showSearchView = true
                    }, label: {
                        ZStack {
                            Image("MuhanPointRight")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 180)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                            
                            VStack(alignment: .leading, spacing: 3) {
                                HStack {
                                    Text("🧭 AR 길찾기")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(.white)
                                    Spacer()
                                }
                                
                                Text("가천대 구석구석 AR 길찾기")
                                    .font(.system(size: 15))
                                    .foregroundColor(.white)
                                    .padding(.leading, 3)
                                Spacer()
                            }
                            .frame(maxHeight: .infinity)
                            .padding(EdgeInsets(top: 13, leading: 10, bottom: 0, trailing: 0))
                        }
                    })
                    .frame(width: 193, height: 258)
                    .background(
                        RoundedRectangle(cornerRadius: 13)
                            .fill(.dashboardBlue)
                            .shadow(radius: 7, x: 2, y: 2)
                    )
                    
                    
                    Spacer()
                    
                    WeatherView()
                        .shadow(radius: 7, x: 2, y: 2)
                } // H3
                
                //Spacer()
                
                HStack {
                    
                    Button(action: {
                        globalViewModel.selectedTab = 2
                    }, label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 3) {
                                Text("🏢")
                                Text("캠퍼스 맵")
                                Spacer()
                            }
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)
                            Spacer()
                        }
                        .padding(EdgeInsets(top: 13, leading: 15, bottom: 0, trailing: 0))
                    })
                    .frame(width: 131, height: 103)
                    .background(
                        RoundedRectangle(cornerRadius: 13)
                            .fill(.white)
                            .shadow(radius: 7, x: 2, y: 2)
                    )
                    
                    Spacer()
                    
                    Button(action: {
                        globalViewModel.selectedTab = 3
                    }, label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 3) {
                                Text("🎉")
                                Text("행사 안내")
                                Spacer()
                            }
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(EdgeInsets(top: 13, leading: 15, bottom: 0, trailing: 0))
                    })
                    .frame(width: 198, height: 103)
                    .background(
                        RoundedRectangle(cornerRadius: 13)
                            .fill(.dashboardPink)
                            .shadow(radius: 7, x: 2, y: 2)
                    )
                } // H4
                
                Image("gach1000")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.top, 30)
            }
            .frame(width: 343) // V2
            
        }
        .padding(.top, 20)// V3
        
    } // end of body
} // end of View struct

#Preview {
    GuestDashboardView()
        .environmentObject(GlobalViewModel())
}
