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
                
                InquireListCell()
                
            } // end of ScrollView
            .padding(.top, 15)
            .navigationBarTitleDisplayMode(.inline)
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
//            .naigationBarTitle("문의내역 조회", displayMode: .inline)
        } // end of NavigationView
        
    } // end of body
} // end of View struct

#Preview {
    InquireListView(showInquireListView: Binding.constant(true))
}
