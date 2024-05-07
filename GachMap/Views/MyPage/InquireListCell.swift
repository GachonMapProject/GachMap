//
//  InquireListCell.swift
//  GachMap
//
//  Created by 원웅주 on 4/30/24.
//

import SwiftUI

struct InquireListCell: View {
    
    @State private var isMoved: Bool = false
    @State private var selectedCategory: String = ""
    
    var inquiry: InquireListData
    
    func selectedInquiryCategory(category: String) -> String {
        switch category {
        case "Node":
            return "지점 문의"
        case "Route":
            return "경로 문의"
        case "AITime":
            return "AI 소요시간"
        case "AR":
            return "AR 문의"
        case "Event":
            return "행사 문의"
        case "Place":
            return "장소 문의"
        case "Etc":
            return "기타 문의"
        default:
            return ""
        }
    }

    
    var body: some View {
        // 버튼 시작
        Button(action: {
            isMoved = true
        }, label: {
            HStack {
                
                Text(selectedInquiryCategory(category: inquiry.inquiryCategory))
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.gachonBlue)
                    .frame(width: 60)
                    .padding(.trailing, 5)
                
                VStack(alignment: .leading) {
                    Text(inquiry.inquiryTitle)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                    Text(inquiry.createDt)
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                HStack {
                    if (inquiry.inquiryProgress == false) {
                        Text("답변 대기중")
                            .padding(.leading, 10)
                            .padding(.trailing, 10)
                            .font(.system(size: 13))
                            .foregroundColor(.white)
                            .background(GeometryReader { geometry in
                                Color.clear
                                .preference(key: WidthPreferenceKey.self, value: geometry.size.width) }
                            )
                    } else {
                        Text("답변 완료")
                            .padding(.leading, 10)
                            .padding(.trailing, 10)
                            .font(.system(size: 13))
                            .foregroundColor(.white)
                            .background(GeometryReader { geometry in
                                Color.clear
                                .preference(key: WidthPreferenceKey.self, value: geometry.size.width) }
                            )
                    }
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
        .frame(width: UIScreen.main.bounds.width - 30, height: 45)
        // 버튼 끝
        
        NavigationLink("", isActive: $isMoved) {
            InquireDetailView(inquiryId: inquiry.inquiryId)
                .navigationBarBackButtonHidden()
        }
    }
}

//#Preview {
//    InquireListCell()
//}
