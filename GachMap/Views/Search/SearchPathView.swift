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
    @State var showRoadSearchAlert = false
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
                        /* 현재위치 시작이 아니면 알림 띄우고 지도 따라가기
                             현재 위치면 AR 길찾기 바로 실행
                         */
                        showRoadSearchAlert = true
                        
                    }
                }, label: {
                    // 길찾기 뷰로 넘기기
                    VStack(spacing: 5) {
                        Image(systemName: "arrow.triangle.turn.up.right.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                        Text("길안내")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.white)
                    }
                })
                .frame(width: 50, height: 85)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.gachonBlue))
                .padding(.trailing, 5)
                .alert(isPresented: $showRoadSearchAlert){
                    Alert(title: Text("알림"), message: Text("출발 위치가 현재 위치가 아닐 경우, \n경로 미리보기만 가능합니다."), primaryButton: .default(Text("확인"), action: {
                        // 경로 미리보기로 이동 
                    }), secondaryButton: .cancel(Text("취소")))
                }
            
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
