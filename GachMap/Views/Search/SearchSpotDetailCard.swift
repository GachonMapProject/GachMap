//
//  SearchSpotDetailView.swift
//  GachMap
//
//  Created by 원웅주 on 5/6/24.
//

import SwiftUI

struct SearchSpotDetailCard: View {
    var placeName: String
    // var placeSummary: String
    // var placeImage ...
    
    var body: some View {
        VStack {
            HStack {
                Image("festival")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 70, height: 70)
                    .cornerRadius(10)
                    .clipped()
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(placeName)
                        .font(.system(size: 20, weight: .bold))
                    Text("가천대학교 공학의 중심")
                        .font(.system(size: 15))
                    Spacer()
                }
                .frame(height: 70)
                .padding(.leading, 10)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading)
            
            HStack {
                HStack {
                    Button(action: {
                        
                    }, label: {
                        Text("출발지로 설정")
                            .font(.system(size: 15, weight: .bold))
                    })
                    .frame(width: 130, height: 33)
                    .foregroundColor(.white)
                    .background(Capsule()
                        .fill(.gachonBlue))
                }
                .frame(width: (UIScreen.main.bounds.width - 30) / 2, alignment: .trailing)
                .padding(.trailing, 10)
                
                HStack {
                    Button(action: {
                        
                    }, label: {
                        Text("도착지로 설정")
                            .font(.system(size: 15, weight: .bold))
                    })
                    .frame(width: 130, height: 33)
                    .foregroundColor(.white)
                    .background(Capsule()
                        .fill(.gachonBlue))
                }
                .frame(width: (UIScreen.main.bounds.width - 30) / 2, alignment: .leading)
                .padding(.leading, 10)
            }
            .padding(.top, 8)
            
        }
        .frame(width: UIScreen.main.bounds.width - 30, height: 150)
        .background(
            RoundedRectangle(cornerRadius: 13)
                .fill(Color(UIColor.systemGray6))
                .shadow(radius: 10)
        )
        
    }
}

struct SearchSpotDetailCard_Previews: PreviewProvider {
    static var previews: some View {
        SearchSpotDetailCard(placeName: "전달받은 장소명")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
