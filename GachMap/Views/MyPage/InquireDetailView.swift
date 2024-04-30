//
//  InquireDetailView.swift
//  GachMap
//
//  Created by 원웅주 on 4/30/24.
//

import SwiftUI

struct InquireDetailView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    let category = ["지점 문의", "경로 문의", "AI 소요시간 문의", "AR 문의", "행사 문의", "장소 문의", "기타 문의"]
    
    @State private var selectedCategory: String = ""
    @State private var inquireCategory: String = ""
    @State private var inquireDate: String = ""
    @State private var inquireTitle: String = ""
    @State private var inquireDetail: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("문의 항목")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                            Spacer()
                        }
                        
                        TextField("문의 항목", text: $inquireCategory)
                            .padding(.leading)
                            .multilineTextAlignment(.leading)
                            .disabled(true)
                            .frame(height: 45)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemGray6))
                            )
                    }
                    .padding(.top, 20)
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("작성일")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                            Spacer()
                        }
                        
                        TextField("작성일", text: $inquireDate)
                            .padding(.leading)
                            .multilineTextAlignment(.leading)
                            .disabled(true)
                            .frame(height: 45)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemGray6))
                            )
                    }
                    .padding(.top, 10)
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("제목")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                            Spacer()
                        }
                        
                        TextField("제목을 입력해주세요", text: $inquireTitle)
                            .padding(.leading)
                            .multilineTextAlignment(.leading)
                            .disabled(true)
                            .frame(height: 45)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemGray6))
                            )
                    }
                    .padding(.top, 10)
                    
                    VStack {
                        HStack {
                            Text("내용")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                            Spacer()
                        }
                        
                        TextEditor(text: $inquireDetail)
        //                        .overlay(alignment: .topLeading) {
        //                            Text("문의 내용을 입력해주세요")
        //                                .foregroundStyle(inquireDetail.isEmpty ? .gray : .clear)
        //                        }
                            .frame(height: 300, alignment: .top)
                            .multilineTextAlignment(.leading)
                            .disabled(true)
                            .padding(.leading)
                            .padding(.trailing)
                            .padding(.top, 10)
                            .scrollContentBackground(.hidden)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemGray6))
                            )
                    }
                    .padding(.top, 10)
                    .padding(.bottom)
                } // end of ScrollView
                
            } // 전체 VStack 끝
            .frame(width: UIScreen.main.bounds.width - 30)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "chevron.left")
                    })
                    
                    
                }
                ToolbarItem(placement: .principal) {
                    Text("문의 상세")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                }
            } // end of .toolbar
            .navigationBarBackButtonHidden()
        } // end of NavigationView
        
    } // end of body
} // end of View struct

#Preview {
    InquireDetailView()
}
