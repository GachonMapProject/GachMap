//
//  SignUpView.swift
//  GachMap
//
//  Created by 원웅주 on 4/17/24.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var userId = ""
    @State private var password = ""
    @State private var rePassword = ""
    @State private var isFull: Bool = false
    
    func isButtonEnabled() -> Bool {
        return !userId.isEmpty && !password.isEmpty && !rePassword.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            // 상단 이미지, 프로그레스 바
            VStack {
                Image("gach1000")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: UIScreen.main.bounds.height * 0.15)
                    .padding(.top, 35)
                
                HStack {
                    Rectangle()
                        .fill(.gachonBlue)
                        .frame(height: 3)
                    Rectangle()
                        .fill(Color(.systemGray4))
                        .frame(height: 3)
                }
                .padding(.top, 20)
            }
            .padding(.leading)
            .padding(.trailing)
            // end of 상단 이미지, 프로그레스 바
            
            // 내용 입력 부분
            VStack {
                ScrollView {
                    // 첫 번째 줄
                    VStack {
                        HStack {
                            Text("아이디")
                                .font(.system(size: 18, weight: .bold))
                            Text("필수")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.red)
                            Spacer()
                        }
                        
                        HStack {
                            TextField("6~12자리의 영문, 숫자", text: $userId)
                                .padding(.leading)
                                .autocapitalization(.none) // 대문자 설정 지우기
                                .disableAutocorrection(false) // 자동 수정 해제
                                .frame(height: 45)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(.systemGray6))
                                )
                            
                            Button(action: {
                                
                            }, label: {
                                Text("중복 확인")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(Color.white)
                                    .frame(width: 80, height: 45)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(userId.isEmpty ? Color(UIColor.systemGray4) : Color.gachonBlue)
                                    )
                            })
                            .disabled(userId.isEmpty)
                        }
                    }
                    .padding(.top, 20)
                    // end of 첫 번째 줄
                    
                    // 두 번째 줄
                    VStack {
                        HStack {
                            Text("비밀번호")
                                .font(.system(size: 18, weight: .bold))
                            Text("필수")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.red)
                            Spacer()
                        }
                        
                        SecureField("비밀번호 입력", text: $password)
                            .padding(.leading)
                            .autocapitalization(.none) // 대문자 설정 지우기
                            .disableAutocorrection(true) // 자동 수정 해제
                            .frame(height: 45)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemGray6))
                            )
                        
                        SecureField("비밀번호 재입력", text: $rePassword)
                            .padding(.leading)
                            .autocapitalization(.none) // 대문자 설정 지우기
                            .disableAutocorrection(true) // 자동 수정 해제
                            .frame(height: 45)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemGray6))
                            )
                        
                        Text("8~20자리의 영문, 숫자, 특수문자 필수 입력")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 5)
                    }
                    .padding(.top, 10)
                    // end of 두번째 줄
                    
                } // end of ScrollView
            } // end of 내용 입력 부분 VStack
            .padding(.leading)
            .padding(.trailing)
            // end of 내용 입력 부분
            
            // 하단 버튼 Stack
            HStack {
                Button(action: {
                    print(self.userId + self.password + self.rePassword)
                    
                    if userId != "" && password != "" {
                        isFull.toggle()
                    }
                    
                    NavigationLink(destination: InfoInputView()) {
                        EmptyView()
                    }
                    // post 보내기
                    
                }, label: {
                    Text("다음")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(isButtonEnabled() ? Color.gachonBlue : Color(UIColor.systemGray4))
                                .shadow(radius: 5, x: 2, y: 2)
                            )
                        .padding(.bottom, 20)
                        .padding(.top, 15)
                })
                .disabled(!isButtonEnabled())
            }
            .background(Color.white.opacity(0.0))
            .padding(.leading)
            .padding(.trailing)
            // end of 하단 버튼 Stack
        }
        
    } // end of body
} // end of View

#Preview {
    SignUpView()
}
