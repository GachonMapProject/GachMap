//
//  SearchDoubleView.swift
//  GachMap
//
//  Created by 원웅주 on 5/4/24.
//

import SwiftUI

struct SearchDoubleView: View {
    
    @State private var startSearchText = ""
    @State private var endSearchText = ""
    
    var body: some View {
        // 상단 검색바
        HStack(spacing: 0) {
            Image("gachonMark")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 33, height: 24, alignment: .leading)
                .padding(.leading)
            
            VStack(alignment: .leading, spacing: 0) {
                TextField("출발", text: $startSearchText)
                    .font(.title3)
                    .frame(height: 47.5)
                
                Divider()
                
                TextField("도착", text: $endSearchText)
                    .font(.title3)
                    .frame(height: 47.5)
            }
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            
            if (startSearchText != "" || endSearchText != "") {
                Button(action: {
                    // 검색어 전달 API 함수 넣기
                    
                }, label: {
                    VStack(spacing: 5) {
                        Image(systemName: "magnifyingglass")
                            .font(.title2)
                            .foregroundColor(.white)
                        Text("검색")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                })
                .frame(width: 50, height: 85)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.gachonBlue))
                .padding(.trailing, 5)
            }
            
        } // end of HStack (검색창)
        .frame(width: UIScreen.main.bounds.width - 30, height: 100)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(UIColor.systemBackground))
                .shadow(radius: 7, x: 2, y: 2)
        )
        .padding(.top, 10)
    }
}

#Preview {
    SearchDoubleView()
}
