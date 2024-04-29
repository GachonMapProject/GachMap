//
//  InquireSendView.swift
//  GachMap
//
//  Created by 원웅주 on 4/30/24.
//

import SwiftUI

struct InquireSendView: View {
    
    @Binding var showInquireSendView: Bool
    
    @State private var showEscapeAlert: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("문의 항목")
                }
                
                HStack {
                    Text("문의 제목")
                }
                
                HStack {
                    Text("문의 내용")
                }
            } // end of VStack
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("1:1 문의하기")
                        .font(.system(size: 23, weight: .bold))
                        .foregroundColor(.black)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showEscapeAlert = true
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
                    .alert(isPresented: $showEscapeAlert) {
                        Alert(title: Text("경고"), message: Text("마이 페이지로 이동하시겠습니까?\n입력한 모든 정보가 초기화됩니다."), primaryButton: .default(Text("확인"), action: { showInquireSendView = false }), secondaryButton: .cancel(Text("취소"))
                        )
                    } // end of X Button
                }
                
            } // end of .toolbar
            
        } // end of NavigationView
        
    } // end of body
} // end of View struct

#Preview {
    InquireSendView(showInquireSendView: Binding.constant(true))
}
