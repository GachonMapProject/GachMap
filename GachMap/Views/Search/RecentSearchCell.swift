//
//  RecentSearchCell.swift
//  GachMap
//
//  Created by 원웅주 on 5/8/24.
//

import SwiftUI

struct RecentSearchCell: View {
    
    var body: some View {
        VStack {
            HStack {
                Text("최근 검색")
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
                
                Spacer()
                
                Button(action: {
                    
                }, label: {
                    Text("전체 삭제")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.gachonBlue)
                })
            }
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 3, trailing: 20))
            
            ScrollView {
                ForEach(0..<20, id: \.self) { _ in
                    VStack {
                        HStack {
                            Text("이수현")
                                .font(.body)
                            
                            Spacer()
                            
                            Button(action: {
                                
                            }, label: {
                                Image(systemName: "xmark")
                                    .font(.callout)
                                    .foregroundColor(.gray)
                            })
                        }
                        
                        Divider()
                    }
                    .padding(EdgeInsets(top: 3, leading: 20, bottom: 0, trailing: 20))
                }
            } // end of ScrollView
        } // end of 검색 기록 전체 영역
    } // end of body
}

#Preview {
    RecentSearchCell()
}
