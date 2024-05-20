//
//  SplashScreen.swift
//  GachMap
//
//  Created by 원웅주 on 4/15/24.
//

import SwiftUI

struct SplashScreen: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        if isActive {
            // 메인 화면으로 이동
            PrimaryView()
        } else {
            VStack {
                Image("gach1200")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 200)
                    .scaleEffect(size)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 1.2)) {
                            self.size = 1.0
                            self.opacity = 1.0
                        }
                    }
            }
            .onAppear {
                // 일정 시간 후에 메인 화면으로 전환
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
            .background(Color.white)
        }
    }
}

#Preview {
    SplashScreen()
        .environmentObject(GlobalViewModel())
        .environmentObject(NavigationController())
        .environmentObject(CoreLocationEx())
}
