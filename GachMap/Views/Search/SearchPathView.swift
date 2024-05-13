//
//  SearchPathView.swift
//  GachMap
//
//  Created by 이수현 on 5/13/24.
//

import SwiftUI

struct SearchPathView : View {
    let startText : String
    let endText : String
    var body: some View {
        // 출발, 도착 두 필드가 모두 true일때만 길찾기 버튼 활성화
        HStack(spacing: 0) {
            Image("gachonMark")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 33, height: 24, alignment: .leading)
                .padding(.leading)
            
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text(startText)
                        .font(.title3)
                    Spacer()
                    
                }
                .frame(height: 47.5)
                
                Divider()
                
                HStack {
                    Text(endText)
                        .font(.title3)
                    
                    Spacer()
                }
                .frame(height: 47.5)
            }
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
        
                Button(action: {
                    if (startText != "현재 위치"){
                    }
                }, label: {
                    // 길찾기 뷰로 넘기기
                    VStack(spacing: 5) {
                        Image(systemName: "arrow.triangle.turn.up.right.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                        Text("길찾기")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.white)
                    }
                })
                .frame(width: 50, height: 85)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.gachonBlue))
                .padding(.trailing, 5)
            
        } // end of HStack
        .frame(width: UIScreen.main.bounds.width - 30, height: 100)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(UIColor.systemBackground))
                .shadow(radius: 7, x: 2, y: 2)
        )
    }
}


//#Preview {
//    SearchPathView()
//}
