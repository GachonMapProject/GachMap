//
//  ProfileTabView.swift
//  FreeGachonMap
//
//  Created by 원웅주 on 3/11/24.
//

import SwiftUI

struct ProfileTabView: View {
    var body: some View {
        NavigationStack {
            HStack {
                HStack {
                    Button(action: {
                        
                    }, label: {
                        HStack {
                            Text("회원 탈퇴하기")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(Color(.white))
                        }
                        .frame(width: UIScreen.main.bounds.width - 200, height: 45)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                //.fill(Color(.systemBlue))
                                .shadow(radius: 5, x: 2, y: 2)
                        )
                        .padding(.top, 20)
                    })
                } // end of Login Button
            }
            .navigationTitle("마이 페이지")
        }
    }
}

#Preview {
    ProfileTabView()
}
