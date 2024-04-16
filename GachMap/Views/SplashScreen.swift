//
//  SplashScreen.swift
//  GachMap
//
//  Created by 원웅주 on 4/15/24.
//

import SwiftUI

struct SplashScreen: View {
    var body: some View {
        ZStack {
                    Color.blue
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        Image(systemName: "star.fill")
                            .font(.system(size: 100))
                            .foregroundColor(.white)
                        
                        Text("스플래시 화면")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                }
    }
}

#Preview {
    SplashScreen()
}
