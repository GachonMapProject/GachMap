//
//  InquireListView.swift
//  GachMap
//
//  Created by 원웅주 on 4/30/24.
//

import SwiftUI

struct InquireListView: View {
    
    @Binding var showInquireListView: Bool
    
    var body: some View {
        NavigationView {
            ScrollView {
                
                // 버튼 시작
                Button(action: {
                    
                }, label: {
                    HStack {
                        Text("카테고리")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.gachonBlue)
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
                .frame(width: UIScreen.main.bounds.width - 30)
                // 버튼 끝
                
                Divider()
                    .frame(width: UIScreen.main.bounds.width - 30)
                
            } // end of ScrollView
            .padding(.top, 15)
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("문의내역 조회")
                        .font(.system(size: 23, weight: .bold))
                        .foregroundColor(.black)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showInquireListView = false
                    }, label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                            .background(
                                Circle()
                                    .fill(Color.gray)
                                    .opacity(0.7)
                                    .frame(width: 30, height: 30)
                            )
                    })
                    .padding(.trailing, 8)
                }
                
            } // end of .toolbar
        } // end of NavigationView
        
    } // end of body
} // end of View struct

#Preview {
    InquireListView(showInquireListView: Binding.constant(true))
}
