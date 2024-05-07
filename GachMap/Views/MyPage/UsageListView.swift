//
//  UsageListView.swift
//  GachMap
//
//  Created by 원웅주 on 5/3/24.
//

import SwiftUI
import Alamofire

struct UsageListView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(0..<20, id: \.self) { _ in
                    UsageListCell()
                        .frame(width: UIScreen.main.bounds.width)
                        .padding(.top, 10)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("이용 내역")
                        .font(.system(size: 23, weight: .bold))
                        .foregroundColor(.black)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
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
    UsageListView()
}
