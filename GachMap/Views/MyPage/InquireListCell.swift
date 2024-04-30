//
//  InquireListCell.swift
//  GachMap
//
//  Created by 원웅주 on 4/30/24.
//

import SwiftUI

struct InquireListCell: View {
    
    @State private var isMoved: Bool = false
    
    var body: some View {
        // 버튼 시작
        Button(action: {
            isMoved = true
        }, label: {
            HStack {
                Text("카테고리")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.gachonBlue)
                    .frame(width: 60)
                    .padding(.trailing, 5)
                
                VStack(alignment: .leading) {
                    Text("문의 제목")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                    Text("작성일")
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                HStack {
                    Text("답변 대기중")
                        .padding(.leading, 10)
                        .padding(.trailing, 10)
                        .font(.system(size: 13))
                        .foregroundColor(.white)
                        .background(GeometryReader { geometry in
                            Color.clear
                            .preference(key: WidthPreferenceKey.self, value: geometry.size.width) }
                        )
                }
                .frame(height: 25)
                .contentShape(.capsule)
                .background(
                    Capsule()
                        .fill(.gachonBlue))
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
        })
        .frame(width: UIScreen.main.bounds.width - 30, height: 45)
        // 버튼 끝
        
        NavigationLink("", isActive: $isMoved) {
            InquireDetailView()
                .navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    InquireListCell()
}
