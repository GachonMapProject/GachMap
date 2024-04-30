//
//  InquireSendView.swift
//  GachMap
//
//  Created by 원웅주 on 4/30/24.
//

import SwiftUI

struct InquireSendView: View {
    // Environment 추가하기 (바인딩 없애고)
    
    @Binding var showInquireSendView: Bool
    
    let category = ["지점 문의", "경로 문의", "AI 소요시간 문의", "AR 문의", "행사 문의", "장소 문의", "기타 문의"]
    
    @State private var showEscapeAlert: Bool = false
    @State private var selectedCategory: String = ""
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
                            Text("필수")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.red)
                            Spacer()
                        }
     
                        Picker("문의 항목", selection: $selectedCategory) {
                            ForEach(category, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(.automatic)
                        .frame(maxWidth: .infinity)
                        .frame(height: 45)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemGray6))
                        )
                    }
                    .padding(.top, 20)
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("제목")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                            Text("필수")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.red)
                            Spacer()
                        }
                        
                        TextField("제목을 입력해주세요", text: $inquireTitle)
                            .padding(.leading)
                            .multilineTextAlignment(.leading)
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
                            Text("필수")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.red)
                            Spacer()
                        }
                        
                        TextEditor(text: $inquireDetail)
    //                        .overlay(alignment: .topLeading) {
    //                            Text("문의 내용을 입력해주세요")
    //                                .foregroundStyle(inquireDetail.isEmpty ? .gray : .clear)
    //                        }
                            .frame(height: 300, alignment: .top)
                            .multilineTextAlignment(.leading)
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
                
                Button(action: {
                    
                }, label: {
                    Text("전달")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color(.white))
                        .frame(width: UIScreen.main.bounds.width - 30, height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(selectedCategory.isEmpty || inquireTitle.isEmpty || inquireDetail.isEmpty ? Color(UIColor.systemGray4) : Color.gachonBlue)
                                .shadow(radius: 5, x: 2, y: 2)
                        )
                })
                .disabled(selectedCategory.isEmpty || inquireTitle.isEmpty || inquireDetail.isEmpty)
                .padding(.bottom)
                
            } // end of 전체 VStack
            .frame(width: UIScreen.main.bounds.width - 30)
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
