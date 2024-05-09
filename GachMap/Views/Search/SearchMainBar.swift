//
//  SearchMainView.swift
//  GachMap
//
//  Created by 원웅주 on 4/28/24.
//

import SwiftUI

struct SearchMainBar: View {
    var body: some View {
        // 상단 검색바
        HStack {
            Image("gachonMark")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 33, height: 24, alignment: .leading)
                .padding(.leading)
            
            Text("어디로 갈까요?")
                .font(.title3)
                .foregroundColor(Color(.gray))
            
            Spacer()
        } // end of HStack (검색창)
        .frame(width: UIScreen.main.bounds.width - 30, height: 50)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(UIColor.systemBackground))
                .shadow(radius: 7, x: 2, y: 2)
        )
        .padding(.top, 10)
    }
}

#Preview {
    SearchMainBar()
}
