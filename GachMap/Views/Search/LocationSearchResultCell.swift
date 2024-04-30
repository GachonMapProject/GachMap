//
//  LocationSearchResultCell.swift
//  GachMap
//
//  Created by 원웅주 on 4/28/24.
//

import SwiftUI

struct LocationSearchResultCell: View {
    
    var body: some View {
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
        .padding(.leading, 15)
        .padding(.trailing, 15)
//        .padding(.top, 5)
        
        Divider()
    }
}

#Preview {
    LocationSearchResultCell()
}
